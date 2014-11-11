/**
 * Created by kvint on 01.11.14.
 */
package controller {
	import events.ChatModelEvent;
	import events.CommunicatorEvent;

	import flash.events.Event;

	import model.ChatModel;
	import model.ChatUser;
	import model.communicators.ICommunicator;
	import model.data.ChatMessage;

	import org.igniterealtime.xiff.core.Browser;
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.archive.RetrieveStanza;
	import org.igniterealtime.xiff.data.archive.archive_internal;
	import org.igniterealtime.xiff.data.disco.DiscoExtension;
	import org.igniterealtime.xiff.data.disco.DiscoFeature;
	import org.igniterealtime.xiff.data.disco.InfoDiscoExtension;
	import org.igniterealtime.xiff.events.LoginEvent;
	import org.igniterealtime.xiff.events.MessageEvent;
	import org.igniterealtime.xiff.util.DateTimeParser;

	use namespace archive_internal;

	public class ChatController extends BaseChatController {

		[Inject]
		public var chatModel:ChatModel;

		private var _browser:Browser;

		[PostConstruct]
		override public function init():void {
			super.init();

			chatModel.addEventListener(ChatModelEvent.COMMUNICATOR_ACTIVATED, communicatorEventHandler);
			chatModel.addEventListener(ChatModelEvent.COMMUNICATOR_ADDED, communicatorEventHandler);
			chatModel.addEventListener(ChatModelEvent.COMMUNICATOR_REMOVED, communicatorEventHandler);

			_browser = new Browser(connection);
		}
		override protected function setupCurrentUser():void {
			_currentUser = new ChatUser(_connection.jid);
			chatModel.currentUser = _currentUser;
		}

		private function communicatorEventHandler(event:ChatModelEvent):void {
			var communicator:ICommunicator = event.data as ICommunicator;
			switch (event.type){
				case ChatModelEvent.COMMUNICATOR_ADDED:
					communicator.addEventListener(CommunicatorEvent.ITEM_RECEIPT_REPLIED, handleReceiptRequested);
					break;
				case ChatModelEvent.COMMUNICATOR_REMOVED:
					communicator.removeEventListener(CommunicatorEvent.ITEM_RECEIPT_REPLIED, handleReceiptRequested);
					break;
				case ChatModelEvent.COMMUNICATOR_ACTIVATED:
					chatModel.activeCommunicator = communicator;
					break;
			}
		}

		override protected function setupRoster():void {
			super.setupRoster();
			chatModel.roster = _roster;
		}

		public function sendRoomMessage(message:ChatMessage):void {
			connection.send(message);

			var communicator:ICommunicator = chatModel.provider.getCommunicator(message);
			communicator.add(message);
		}
		public function sendMessage(message:ChatMessage):void {
			//Append receipt data
			requestReceipt(message);

			//Send the message
			connection.send(message);

			message.receipt = null;

			var communicator:ICommunicator = chatModel.provider.getCommunicator(message);
			communicator.add(message);
		}

		override protected function onMessageCome(event:MessageEvent):void {
			var message:ChatMessage = ChatMessage.createFromBase(event.data);
			event.data = message;
			handleReceiptReceived(message);
			switch (message.type) {
				case Message.TYPE_CHAT:
				case Message.TYPE_GROUPCHAT:
					if(message.body == null){
						//TODO: fix it
						trace("message skip", message.id);
						return;
					}
					var communicator:ICommunicator = chatModel.provider.getCommunicator(message);
					communicator.add(message);
					break;
				default :
					super.onMessageCome(event);
			}
		}

		private function requestReceipt(message:ChatMessage):void {
			message.receipt = Message.RECEIPT_REQUEST;
			chatModel.receiptRequests[message.id] = message;
		}

		private function handleReceiptReceived(ackMessage:ChatMessage):void {
			if (ackMessage.receipt == Message.RECEIPT_RECEIVED) { //It's ack ackMessage
				var receiptMessage:ChatMessage = chatModel.receiptRequests[ackMessage.receiptId];
				if (receiptMessage) {
					delete chatModel.receiptRequests[ackMessage.receiptId];
					receiptMessage.receipt = null;
					receiptMessage.read = true;
					var iCommunicator:ICommunicator = chatModel.provider.getCommunicator(receiptMessage);
					iCommunicator.dispatchEvent(new CommunicatorEvent(CommunicatorEvent.ITEM_UPDATED, receiptMessage));
				}
			}
		}

		public function handleReceiptRequested(event:CommunicatorEvent):void {
			var message:ChatMessage = event.data as ChatMessage;
			if (message.receipt == Message.RECEIPT_REQUEST) {
				message.receipt = null;
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
			_browser.getServiceInfo(null, onServerInfo);
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
				var chatNS:Namespace = new Namespace(null, archive_internal);
				var chat:XML = iq.xml.chatNS::chat[0];
				var chats:XMLList = chat.children();
				var str:String = "";
				var startDate:Date = DateTimeParser.string2dateTime(chat.attribute("start"));
				for each (var tag:XML in chats) {
					if(tag.localName() == "from"){
						str += formatDate(startDate) + " " + chat.attribute("with") + ": " + tag.body;
					}else{
						str += formatDate(startDate) + " " + chatModel.currentUser.jid + ": " + tag.body;
					}
					str += "\n";
				}
				trace(str);
			}
			var stanza:RetrieveStanza = new RetrieveStanza();
			stanza.withJID = new EscapedJID("joe@localhost");
			test.addExtension(stanza);
			connection.send(test);
		}

		private function formatDate(startDate:Date):String {
			return startDate.toString();
		}

		public function activateCommunicator(communicator:ICommunicator):void {
			chatModel.dispatchEvent(new ChatModelEvent(ChatModelEvent.COMMUNICATOR_ACTIVATED, communicator));
		}
		public function destroy():void {
			//TODO: destroy
		}
	}
}
