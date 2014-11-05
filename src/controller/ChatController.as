/**
 * Created by kvint on 01.11.14.
 */
package controller {
	import events.ChatEvent;

	import flash.events.Event;

	import model.ChatModel;
	import model.ChatUser;
	import model.communicators.DirectCommunicator;
	import model.communicators.ICommunicator;
	import model.data.ChatMessage;

	import org.igniterealtime.xiff.core.Browser;

	import org.igniterealtime.xiff.core.UnescapedJID;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.archive.ChatStanza;
	import org.igniterealtime.xiff.data.archive.ListStanza;
	import org.igniterealtime.xiff.data.archive.RetrieveStanza;
	import org.igniterealtime.xiff.data.disco.DiscoExtension;
	import org.igniterealtime.xiff.data.disco.DiscoFeature;
	import org.igniterealtime.xiff.data.disco.InfoDiscoExtension;
	import org.igniterealtime.xiff.data.im.RosterItemVO;
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
			chatModel.addEventListener(ChatEvent.SEND_MESSAGE, onMessageSend)
		}

		override protected function setupRoster():void {
			super.setupRoster();
			chatModel.roster = _roster;
		}

		private function onMessageSend(event:ChatEvent):void {
			var message:ChatMessage = event.data as ChatMessage;

			//Append receipt data
			requestReceipt(message);

			//Send the message
			connection.send(message);

			//Add message to communicator
			var node:String = message.to.node;
			var communicator:ICommunicator = chatModel.conversations[node];
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
			switch (message.type){
				case Message.TYPE_CHAT:
				case Message.TYPE_GROUPCHAT:
					var communicator:ICommunicator = getCommunicatorForMessage(message);
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
			if(message.receipt == Message.RECEIPT_RECEIVED) { //It's ack message
				var receiptMessage:ChatMessage = chatModel.receiptRequests[message.receiptId];
				if(receiptMessage) {
					delete chatModel.receiptRequests[message.receiptId];

					receiptMessage.read = true;
					chatModel.dispatchEvent(new ChatEvent(ChatEvent.ON_MESSAGE_READ, receiptMessage));
				}
				//TODO: implement communicator fetch
				//var communicator:ICommunicator = getCommunicatorForMessage(receiptMessage);
				//communicator.markAsRead(receiptMessage);
			}
		}

		public function markMessageAsReceived(message:ChatMessage):void {
			if(message.read) return;
			if(message.from.equals(chatModel.currentUser.jid.escaped, true)) return;
			if(message.receipt == Message.RECEIPT_REQUEST) {
				message.read = true;
				var ackMessage:Message = new Message();
				ackMessage.from = message.to;
				ackMessage.to = message.from;
				ackMessage.receipt = Message.RECEIPT_RECEIVED;
				ackMessage.receiptId = message.id;
				connection.send(ackMessage);
			}
		}

		public function getCommunicatorForMessage(message:ChatMessage):ICommunicator {
			var buddy:UnescapedJID = message.from.unescaped;
			return getCommunicatorForJID(buddy);
		}
		public function getCommunicatorForRosterItem(ri:RosterItemVO):ICommunicator {
			return getCommunicatorForJID(ri.jid);
		}
		private function getCommunicatorForJID(jid:UnescapedJID):ICommunicator {
			var node:String = jid.node;
			var communicator:ICommunicator = chatModel.conversations[node];
			if(communicator == null) {
				communicator = new DirectCommunicator(jid, chatModel.currentUser);
				chatModel.conversations[node] = communicator;
				chatModel.dispatchEvent(new ChatEvent(ChatEvent.NEW_CONVERSATION, communicator));
			}
			return communicator;
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
				if(feature.varName == "urn:xmpp:archive:auto"){
					return;
				}
			}
			//TODO: add normal reaction
			throw new Error("Server not configured");
		}

		public function test():void {
			var test:IQ = new IQ(null, IQ.TYPE_GET);
			test.callback = function(iq:IQ):void {
				var extension1:ListStanza = iq.getExtension(ListStanza.ELEMENT_NAME) as ListStanza;
				for (var i:int = 0; i < extension1.chats.length; i++) {
					var chat:ChatStanza = extension1.chats[i];
					trace(chat.withJID);

				}
			}
			/*var xml:XML = <iq type='get' id='page1'>
							<retrieve xmlns='urn:xmpp:archive'>
								<set xmlns='http://jabber.org/protocol/rsm'>
									<max>1</max>
								</set>
							</retrieve>
						</iq>;*/
			var retrieveStanza:RetrieveStanza = new RetrieveStanza();

			test.addExtension(retrieveStanza);
			connection.send(test);
		}
	}
}
