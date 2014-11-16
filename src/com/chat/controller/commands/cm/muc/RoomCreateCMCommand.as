/**
 * Created by kvint on 17.11.14.
 */
package com.chat.controller.commands.cm.muc {
	import com.chat.model.ChatRoom;
	import com.chat.model.communicators.ICommunicator;

	import org.igniterealtime.xiff.data.forms.FormExtension;
	import org.igniterealtime.xiff.events.RoomEvent;

	public class RoomCreateCMCommand extends RoomCMCommand {

		override protected function executeIfNoErrors():void {
			var roomName:String = params[0]
			_chatRoom = new ChatRoom();
			_chatRoom.chatManager = controller;
			_chatRoom.create(roomName);
			_chatRoom.addEventListener(RoomEvent.CONFIGURE_ROOM, onRoomConfigure);
			_chatRoom.addEventListener(RoomEvent.CONFIGURE_ROOM_COMPLETE, onRoomConfigureComplete);

		}

		private function onRoomConfigure(event:RoomEvent):void {
			var formExtension:FormExtension = event.data as FormExtension;

			_chatRoom.room.configure(formExtension);

			_chatRoom.room.changeSubject(_chatRoom.room.roomName);
		}

		private function onRoomConfigureComplete(event:RoomEvent):void {

			_chatRoom.removeEventListener(RoomEvent.CONFIGURE_ROOM, onRoomConfigure);
			_chatRoom.removeEventListener(RoomEvent.CONFIGURE_ROOM_COMPLETE, onRoomConfigureComplete);

			var iCommunicator:ICommunicator = model.provider.getCommunicator(_chatRoom);
			//iCommunicator.activate();
		}
	}
}
