/**
 * Created by kvint on 02.11.14.
 */
package events {
	public class ChatEvent extends DataEvent {

		public static const NEW_CONVERSATION:String = "onNewConversation";

		public function ChatEvent(type:String, data:Object = null) {
			super(type, data);
		}

	}
}
