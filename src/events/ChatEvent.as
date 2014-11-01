/**
 * Created by kvint on 02.11.14.
 */
package events {
	import flash.events.Event;

	public class ChatEvent extends Event {


		public static const NEW_CONVERSATION:String = "onNewConversation";
		private var _data:Object;

		public function ChatEvent(type:String, data:Object = null) {
			super(type, false, false);
			_data = data;
		}

		public function get data():Object {
			return _data;
		}
	}
}
