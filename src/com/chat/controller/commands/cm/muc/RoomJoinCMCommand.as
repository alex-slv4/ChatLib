/**
 * Created by kvint on 11.11.14.
 */
package com.chat.controller.commands.cm.muc {
	import com.chat.model.ChatRoom;
	import com.chat.model.communicators.ICommunicatorBase;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.events.RoomEvent;

	public class RoomJoinCMCommand extends RoomCMCommand {

		public function RoomJoinCMCommand(communicator:ICommunicatorBase, params:Array) {
			super(communicator, params);
		}

		override protected function executeIfNoErrors():void {
			var roomName:String = params[0];
			var password:String = params[1];
			var roomJID:UnescapedJID = new UnescapedJID(roomName + "@" + model.conferenceServer);
			_chatRoom = new ChatRoom();
			injector.injectInto(_chatRoom);
			_chatRoom.addEventListener(RoomEvent.ROOM_JOIN, onRoomJoin);
			_chatRoom.join(roomJID, password);
		}

		private function onRoomJoin(event:RoomEvent):void {
			//Room joined
			communicators.getFor(_chatRoom).active = true;
		}

		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
