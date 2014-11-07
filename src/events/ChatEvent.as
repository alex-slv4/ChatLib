/**
 * Created by kvint on 02.11.14.
 */
package events {
	public class ChatEvent extends DataEvent {

		//public static const NEW_CONVERSATION:String = "onNewConversation";
		public static const SEND_MESSAGE:String = "onSendMessage";
		public static const ON_MESSAGE_READ:String = "onMessageRead";

		public function ChatEvent(type:String, data:Object = null) {
			super(type, data);
		}

	}
}
