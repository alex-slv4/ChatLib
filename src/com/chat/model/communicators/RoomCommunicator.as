/**
 * Created by AlexanderSla on 11.11.2014.
 */
package com.chat.model.communicators {
	import com.chat.events.CommunicatorCommandEvent;
	import com.chat.model.ChatRoom;

	public class RoomCommunicator extends WritableCommunicator {

		private var _chatRoom:ChatRoom;

		public function RoomCommunicator(chatRoom:ChatRoom) {
			_chatRoom = chatRoom;
			commandsMap["/room"] = CommunicatorCommandEvent.ROOM;
		}

		override public function send(data:Object):int {
			var result:int = super.send(data);
			if(result == SUCCESS){
				dispatch(CommunicatorCommandEvent.ROOM_MESSAGE, [data]);
			}
			return result;
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