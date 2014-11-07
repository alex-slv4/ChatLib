/**
 * Created by kvint on 01.11.14.
 */
package controller {
	import events.CommunicatorEvent;

	import flash.events.Event;

	import model.ChatModel;
	import model.ChatUser;
	import model.communicators.ICommunicator;
	import model.data.ChatMessage;

	import org.igniterealtime.xiff.core.Browser;
	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.archive.ChatStanza;
	import org.igniterealtime.xiff.data.archive.ListStanza;
	import org.igniterealtime.xiff.data.archive.RetrieveStanza;
	import org.igniterealtime.xiff.data.disco.DiscoExtension;
	import org.igniterealtime.xiff.data.disco.DiscoFeature;
	import org.igniterealtime.xiff.data.disco.InfoDiscoExtension;
	import org.igniterealtime.xiff.events.LoginEvent;
	import org.igniterealtime.xiff.events.MessageEvent;

	public class ChatController extends BaseChatController {

		[Inject]
		public var chatModel:ChatModel;

		private var _browser:Browser;

		[PostConstruct]
		override public function init():void {
			super.init();
			_browser = new Browser(connection);
		}

		override protected function setupRoster():void {
			super.setupRoster();
			chatModel.roster = _roster;
		}

		public function sendMessage(message:ChatMessage):void {

			//Append receipt data
			requestReceipt(message);

			//Send the message
			connection.send(message);

			var communicator:ICommunicator = chatModel.provider.getCommunicator(message);
			communicator.add(message);
			//Remove receipt
		}


		override protected function setupCurrentUser():void {
			_currentUser = new ChatUser(_connection.jid);
			chatModel.currentUser = _currentUser;
		}

		override protected function onMessage(event:MessageEvent):void {
			var message:ChatMessage = ChatMessage.createFromBase(event.data);
			event.data = message;
			switch (message.type) {
				case Message.TYPE_CHAT:
				case Message.TYPE_GROUPCHAT:
					var communicator:ICommunicator = chatModel.provider.getCommunicator(message);
					communicator.add(message);
					communicator.dispatchEvent(event);
					break;
				default :
					onReceiptReceived(message);
					super.onMessage(event);
			}
		}

		private function requestReceipt(message:ChatMessage):void {
			message.receipt = Message.RECEIPT_REQUEST;
			chatModel.receiptRequests[message.id] = message;
		}

		private function onReceiptReceived(message:ChatMessage):void {
			if (message.receipt == Message.RECEIPT_RECEIVED) { //It's ack message
				var receiptMessage:ChatMessage = chatModel.receiptRequests[message.receiptId];
				if (receiptMessage) {
					delete chatModel.receiptRequests[message.receiptId];

					receiptMessage.read = true;
					var iCommunicator:ICommunicator = chatModel.provider.getCommunicator(receiptMessage);
					iCommunicator.dispatchEvent(new CommunicatorEvent(CommunicatorEvent.ITEM_UPDATED, receiptMessage));
				}
				//TODO: implement communicator fetch
				//var communicator:ICommunicator = getCommunicatorForMessage(receiptMessage);
				//communicator.markAsRead(receiptMessage);
			}
		}

		public function markMessageAsReceived(message:ChatMessage):void {
			if (message.read) return;
			if (message.from.equals(chatModel.currentUser.jid.escaped, true)) return;
			if (message.receipt == Message.RECEIPT_REQUEST) {
				message.read = true;
				var ackMessage:Message = new Message();
				ackMessage.from = message.to;
				ackMessage.to = message.from;
				ackMessage.receipt = Message.RECEIPT_RECEIVED;
				ackMessage.receiptId = message.id;
				connection.send(ackMessage);
			}
		}

		override public function dispatchEvent(event:Event):Boolean {
			return chatModel.dispatchEvent(event);
		}

		override protected function onLogin(event:LoginEvent):void {
			super.onLogin(event);
			_browser.getServiceInfo(null, onServerInfo)
			//chatModel.tabsProvider.addItem("test");
		}

		private function onServerInfo(iq:IQ):void {
			var extension1:InfoDiscoExtension = iq.getExtension(DiscoExtension.ELEMENT_NAME) as InfoDiscoExtension;
			for (var i:int = 0; i < extension1.features.length; i++) {
				var feature:DiscoFeature = extension1.features[i];
				if (feature.varName == "urn:xmpp:archive:auto") {
					return;
				}
			}
			//TODO: add normal reaction
			throw new Error("Server not configured");
		}

		public function test():void {
			_connection.enableExtensions(RetrieveStanza);
			var test:IQ = new IQ(null, IQ.TYPE_GET);
			test.callback = function (iq:IQ):void {
				var extension1:ListStanza = iq.getAllExtensionsByNS(ListStanza.NS)[0];
				for (var i:int = 0; i < extension1.chats.length; i++) {
					var chat:ChatStanza = extension1.chats[i];
					trace(chat.withJID);

				}
			}
			var listStanza:RetrieveStanza = new RetrieveStanza();
			//listStanza.withJID = new EscapedJID("joe@localhost");
			test.addExtension(listStanza);
			connection.send(test);
		}
	}
}
