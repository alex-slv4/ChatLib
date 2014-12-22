/**
 * Created by AlexanderSla on 19.11.2014.
 */
package com.chat.model.communicators.factory.communicators {
	import com.chat.model.ChatRoom;
	import com.chat.model.communicators.RoomCommunicator;

	public class RoomCreator extends DefaultCommunicatorCreator {

		public function RoomCreator(chatRoom:ChatRoom, uid:String) {
			super(chatRoom, uid);
		}

		override public function create():* {
			if(data is ChatRoom){
				return new RoomCommunicator(data as ChatRoom);
			}
			return super.create();
		}
	}
}
