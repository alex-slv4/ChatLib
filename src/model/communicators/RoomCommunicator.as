/**
 * Created by AlexanderSla on 11.11.2014.
 */
package model.communicators {
	import model.ChatRoom;

	public class RoomCommunicator extends DefaultCommunicator {

		private var _name:String;
		private var _chatRoom:ChatRoom;

		public function RoomCommunicator(name:String) {
			_name = name;
			_chatRoom = new ChatRoom();
		}

		public function get chatRoom():ChatRoom {
			return _chatRoom;
		}
	}
}
