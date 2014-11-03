/**
 * Created by kvint on 01.11.14.
 */
package model {
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	import org.igniterealtime.xiff.im.Roster;

	public class ChatModel extends EventDispatcher {

		private var _currentUser:ChatUser;
		public var conversations:Dictionary = new Dictionary();
		private var _roster:Roster;

		public function ChatModel() {

		}

		public function get currentUser():ChatUser {
			return _currentUser;
		}

		public function set currentUser(value:ChatUser):void {
			_currentUser = value;
		}

		public function get roster():Roster {
			return _roster;
		}

		public function set roster(value:Roster):void {
			_roster = value;
		}
	}
}
