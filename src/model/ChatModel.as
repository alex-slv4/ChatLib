/**
 * Created by kvint on 01.11.14.
 */
package model {
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class ChatModel extends EventDispatcher{

		private var _currentUser:ChatUser;
		public var conversations:Dictionary = new Dictionary();

		public function ChatModel() {

		}

		public function get currentUser():ChatUser {
			return _currentUser;
		}

		public function set currentUser(value:ChatUser):void {
			_currentUser = value;
		}
	}
}
