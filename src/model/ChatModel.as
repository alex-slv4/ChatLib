/**
 * Created by kvint on 01.11.14.
 */
package model {
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	import model.communicators.ICommunicatorProvider;

	import org.igniterealtime.xiff.im.Roster;

	[Event(name="onCommunicatorAdded", type="events.ChatModelEvent")]
	[Event(name="onCommunicatorRemoved", type="events.ChatModelEvent")]
	[Event(name="onCommunicatorActivated", type="events.ChatModelEvent")]

	public class ChatModel extends EventDispatcher {

		[Inject]
		public var provider:ICommunicatorProvider;
		private var _currentUser:ChatUser;
		private var _roster:Roster;
		public var receiptRequests:Dictionary = new Dictionary();

		[PostConstruct]
		public function init():void {
			provider.chatModel = this;
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
