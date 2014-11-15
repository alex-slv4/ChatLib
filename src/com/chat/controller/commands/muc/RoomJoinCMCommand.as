/**
 * Created by kvint on 11.11.14.
 */
package com.chat.controller.commands.muc {
	import com.chat.controller.commands.CMCommand;
	import com.chat.model.ChatRoom;
	import com.chat.model.communicators.ICommunicator;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.events.RoomEvent;

	public class RoomJoinCMCommand extends CMCommand {

		private var _chatRoom:ChatRoom;

		override protected function executeIfNoErrors():void {
			var roomName:String = params[0];
			var roomJID:UnescapedJID = new UnescapedJID(roomName + "@" + controller.conferenceServer);
			_chatRoom = new ChatRoom();
			_chatRoom.chatManager = controller;
			_chatRoom.addEventListener(RoomEvent.ROOM_JOIN, onRoomJoin);
			_chatRoom.join(roomJID);
		}

		private function onRoomJoin(event:RoomEvent):void {
			var iCommunicator:ICommunicator = model.provider.getCommunicator(_chatRoom);
			iCommunicator; //Room created
		}

		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
