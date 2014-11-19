/**
 * Created by AlexanderSla on 19.11.2014.
 */
package com.chat.model.communicators.factory {
	import com.chat.model.ChatRoom;
	import com.chat.model.communicators.ICommunicator;
	import com.chat.model.communicators.RoomCommunicator;

	public class RoomCreator implements ICreator{

		private var _chatRoom:ChatRoom;

		public function RoomCreator(chatRoom:ChatRoom) {
			_chatRoom = chatRoom;
		}

		public function get uid():String {
			return _chatRoom.room.roomJID.bareJID;
		}

		public function create():ICommunicator {
			return new RoomCommunicator(_chatRoom);
		}
	}
}
