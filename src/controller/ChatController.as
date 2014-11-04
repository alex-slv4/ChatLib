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
			var message:Message = event.data as Message;
			requestReceipt(message);
			var node:String = message.to.node;
			var communicator:ICommunicator = chatModel.conversations[node];
			communicator.add(message);
			connection.send(event.data as Message);
		}


		override protected function setupCurrentUser():void {
			_currentUser = new ChatUser(_connection.jid);
			chatModel.currentUser = _currentUser;
		}

		override protected function onMessage(event:MessageEvent):void {
			var message:Message = event.data as Message;
			switch (message.type){
				case Message.TYPE_CHAT:
				case Message.TYPE_GROUPCHAT:
					var communicator:ICommunicator = getCommunicatorForMessage(message);
					communicator.add(message);
					communicator.dispatchEvent(event);
					break;
				default :
					receiveReceipt(message);
					super.onMessage(event);
			}
		}

		private function requestReceipt(message:Message):void {
			message.receipt = Message.RECEIPT_REQUEST;
			chatModel.receiptRequests[message.id] = message;
		}
		private function receiveReceipt(message:Message):void {
			if(message.receipt == Message.RECEIPT_RECEIVED) { //It's ack message
				var receiptMessage:Message = chatModel.receiptRequests[message.receiptId];
				if(receiptMessage) {
					receiptMessage.receipt = null;
					delete chatModel.receiptRequests[message.receiptId];
					chatModel.dispatchEvent(new ChatEvent(ChatEvent.ON_MESSAGE_READ, receiptMessage));
				}
				//TODO: implement communicator fetch
				//var communicator:ICommunicator = getCommunicatorForMessage(receiptMessage);
				//communicator.markAsRead(receiptMessage);
			}
		}

		public function markMessageAsReceived(message:Message):void {
			if(message.from.equals(chatModel.currentUser.jid.escaped, true)) return;

			if(message.receipt == Message.RECEIPT_REQUEST) {
				var ackMessage:Message = new Message()
				ackMessage.from = message.to;
				ackMessage.to = message.from;
				ackMessage.receipt = Message.RECEIPT_RECEIVED;
				ackMessage.receiptId = message.id;
				connection.send(ackMessage);
			}
		}

		public function getCommunicatorForMessage(message:Message):ICommunicator {
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
				communicator = new DirectCommunicator(jid);
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
