/**
 * Created by kvint on 18.12.14.
 */
package com.chat.model.communicators.factory.uid {
	import com.chat.model.ChatRoom;

	public class RoomUIDCreator extends DefaultUIDCreator {
		public function RoomUIDCreator(data:ChatRoom) {
			super(data);
		}

		override public function toString():String {
			if(data is ChatRoom){
				return (data as ChatRoom).room.roomJID.bareJID;
			}
			return super.toString();
		}
	}
}
