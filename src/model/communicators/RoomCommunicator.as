/**
 * Created by AlexanderSla on 11.11.2014.
 */
package model.communicators {
	import model.ChatRoom;

	public class RoomCommunicator extends DefaultCommunicator {

		private var _chatRoom:ChatRoom;

		public function RoomCommunicator(chatRoom:ChatRoom) {
			_chatRoom = chatRoom;
		}

		override public function get type():int {
			return CommunicatorType.MUC;
		}

		override public function get label():String {
			return _chatRoom.room.roomName;
		}

		public function get chatRoom():ChatRoom {
			return _chatRoom;
		}
	}
}
