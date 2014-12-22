/**
 * Created by kvint on 11.11.14.
 */
package com.chat.controller.commands.cm.muc {
	import com.chat.controller.commands.cm.CMCommand;
	import com.chat.events.CommunicatorEvent;
	import com.chat.model.ChatModel;
	import com.chat.model.ChatRoom;
	import com.chat.model.IChatModel;
	import com.chat.model.communicators.ICommunicator;
	import com.chat.model.communicators.ICommunicatorBase;
	import com.chat.model.communicators.RoomCommunicator;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.events.RoomEvent;
	import org.igniterealtime.xiff.util.JIDUtil;

	import robotlegs.bender.framework.api.IInjector;

	public class RoomJoinCMCommand extends CMCommand {

		[Inject]
		public var injector:IInjector;

		private var _chatRoom:ChatRoom;
		private var _roomCommunicator:ICommunicator;

		override protected function executeIfNoErrors():void {
			var roomName:String = params[0];
			var password:String = params[1];
			var roomJID:UnescapedJID = JIDUtil.createJID(roomName, model.conferenceServer);
			_chatRoom = new ChatRoom();
			injector.injectInto(_chatRoom);
			_chatRoom.addEventListener(RoomEvent.ROOM_JOIN, onRoomJoin);
			_chatRoom.join(roomJID, password);
			_roomCommunicator = communicators.getFor(_chatRoom);
		}

		private function onRoomJoin(event:RoomEvent):void {
			_chatRoom.removeEventListener(RoomEvent.ROOM_JOIN, onRoomJoin);
			//Room joined
			_roomCommunicator.active = true;
		}

		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
