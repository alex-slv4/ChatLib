/**
 * Created by kvint on 01.11.14.
 */
package model {
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	import model.communicators.CommunicatorProvider;

	import org.igniterealtime.xiff.im.Roster;

	public class ChatModel extends EventDispatcher {

		private var _currentUser:ChatUser;
		private var _roster:Roster;
		public var receiptRequests:Dictionary = new Dictionary();
		private var _communicatorProvider:CommunicatorProvider;

		public function ChatModel() {
			_communicatorProvider = new CommunicatorProvider(this);
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

		public function get communicatorProvider():CommunicatorProvider {
			return _communicatorProvider;
		}
	}
}
