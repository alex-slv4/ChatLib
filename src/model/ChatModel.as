/**
 * Created by kvint on 01.11.14.
 */
package model {
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	import org.igniterealtime.xiff.im.Roster;

	public class ChatModel extends EventDispatcher {

		public var conversations:Dictionary = new Dictionary();
		private var _currentUser:ChatUser;
		private var _roster:Roster;
		public var receiptRequests:Dictionary = new Dictionary();

		public function ChatModel() {
			receiptRequests;
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
