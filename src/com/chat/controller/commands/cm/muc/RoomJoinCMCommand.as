/**
 * Created by kvint on 11.11.14.
 */
package com.chat.controller.commands.cm.muc {
	import com.chat.controller.commands.cm.CMCommand;
	import com.chat.events.CommunicatorEvent;
	import com.chat.model.ChatRoom;
	import com.chat.model.communicators.ICommunicatorBase;
	import com.chat.model.communicators.RoomCommunicator;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.events.RoomEvent;

	public class RoomJoinCMCommand extends CMCommand {

		private var _chatRoom:ChatRoom;
		private var _roomCommunicator:RoomCommunicator;

		override protected function executeIfNoErrors():void {
			var roomName:String = params[0];
			var roomJID:UnescapedJID = new UnescapedJID(roomName + "@" + controller.conferenceServer);
			_chatRoom = new ChatRoom();
			_chatRoom.chatManager = controller;
			_chatRoom.addEventListener(RoomEvent.ROOM_JOIN, onRoomJoin);
			_chatRoom.join(roomJID);
			_roomCommunicator = communicators.getFor(_chatRoom) as RoomCommunicator;
		}

		private function onRoomJoin(event:RoomEvent):void {
			//Room joined
			_roomCommunicator.active = true;
		}

		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
