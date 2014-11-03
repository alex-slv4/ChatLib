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
	import org.igniterealtime.xiff.data.Message;
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
			//message.receipt = Message.RECEIPT_REQUEST;
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
					var communicator:ICommunicator = startChatWithJID(message.from.unescaped);
					communicator.add(message);
					communicator.dispatchEvent(event);
					break;
					chatModel.dispatchEvent(event);
				case Message.TYPE_GROUPCHAT:
					//TODO: create chat tab
					var a =1;
					break;
				default :
					super.onMessage(event);
			}
		}

		public function startChatWithJID(buddy:UnescapedJID):ICommunicator {
			var node:String = buddy.node;
			var communicator:ICommunicator = chatModel.conversations[node];
			if(communicator == null) {
				communicator = new DirectCommunicator(buddy);
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
