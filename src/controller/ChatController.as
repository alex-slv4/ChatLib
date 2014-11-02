/**
 * Created by kvint on 01.11.14.
 */
package controller {
	import events.ChatEvent;

	import flash.events.Event;

	import model.ChatModel;
	import model.ChatUser;

	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.events.LoginEvent;
	import org.igniterealtime.xiff.events.MessageEvent;

	import view.tabs.TeamCommunicator;

	public class ChatController extends BaseChatController {

		[Inject]
		public var chatModel:ChatModel;

		[PostConstruct]
		override public function init():void {
			super.init();
		}

		override protected function setupCurrentUser():void {
			_currentUser = new ChatUser(_connection.jid);
			chatModel.currentUser = _currentUser;
		}

		override protected function onMessage(event:MessageEvent):void {
			var message:Message = event.data as Message;
			switch (message.type){
				case Message.TYPE_CHAT:
					if(chatModel.conversations[message.from.bareJID]){
					}else{
						chatModel.conversations[message.from.bareJID] = {};
						chatModel.dispatchEvent(new ChatEvent(ChatEvent.NEW_CONVERSATION, message));
					}
					chatModel.dispatchEvent(event);
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

		override public function dispatchEvent(event:Event):Boolean {
			return chatModel.dispatchEvent(event);
		}

		override protected function onLogin(event:LoginEvent):void {
			super.onLogin(event);
			//chatModel.tabsProvider.addItem("test");
		}
	}
}
