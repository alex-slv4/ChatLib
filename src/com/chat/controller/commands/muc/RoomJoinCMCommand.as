/**
 * Created by kvint on 11.11.14.
 */
package com.chat.controller.commands.muc {
import com.chat.controller.ChatController;
import com.chat.controller.commands.CMCommand;
import com.chat.model.ChatModel;
import com.chat.model.ChatRoom;
import com.chat.model.communicators.ICommunicator;

import org.igniterealtime.xiff.core.UnescapedJID;
import org.igniterealtime.xiff.events.RoomEvent;

public class RoomJoinCMCommand extends CMCommand {

		[Inject]
		public var chatModel:ChatModel;
		[Inject]
		public var chatController:ChatController;
		private var _chatRoom:ChatRoom;

		override protected function _execute():void {
			var roomName:String = params[0];
			var roomJID:UnescapedJID = new UnescapedJID(roomName + "@" + chatController.conferenceServer);
			_chatRoom = new ChatRoom();
			_chatRoom.chatManager = chatController;
			_chatRoom.addEventListener(RoomEvent.ROOM_JOIN, onRoomJoin);
			_chatRoom.join(roomJID);
		}

		private function onRoomJoin(event:RoomEvent):void {
			var iCommunicator:ICommunicator = chatModel.provider.getCommunicator(_chatRoom);
			iCommunicator; //Room created
		}

		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
