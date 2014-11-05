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

	import org.igniterealtime.xiff.core.UnescapedJID;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.im.RosterItemVO;
	import org.igniterealtime.xiff.events.LoginEvent;
	import org.igniterealtime.xiff.events.MessageEvent;

	public class ChatController extends BaseChatController {

		[Inject]
		public var chatModel:ChatModel;

		[PostConstruct]
		override public function init():void {
			super.init();
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
			roster.fetchRoster();
			//chatModel.tabsProvider.addItem("test");
		}

	}
}
