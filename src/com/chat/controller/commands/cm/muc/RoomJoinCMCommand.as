/**
 * Created by kvint on 11.11.14.
 */
package com.chat.controller.commands.cm.muc {
import com.chat.controller.commands.cm.CMCommand;
import com.chat.model.ChatRoom;
import com.chat.model.communicators.ICommunicator;
import flash.events.Event;

import org.as3commons.logging.api.ILogger;
import org.as3commons.logging.api.getLogger;

import org.igniterealtime.xiff.core.UnescapedJID;
import org.igniterealtime.xiff.events.RoomEvent;
import org.igniterealtime.xiff.events.XIFFErrorEvent;
import org.igniterealtime.xiff.util.JIDUtil;

import robotlegs.bender.framework.api.IInjector;

public class RoomJoinCMCommand extends CMCommand {

	private static const log			:ILogger 		= getLogger(RoomJoinCMCommand);

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

		addRoomListeners();

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

	protected function addRoomListeners():void
	{
		_chatRoom.addEventListener( RoomEvent.AFFILIATIONS, onRoomEvent);
		_chatRoom.addEventListener( RoomEvent.CONFIGURE_ROOM, onRoomEvent);
		_chatRoom.addEventListener( RoomEvent.DECLINED, onRoomEvent);
		_chatRoom.addEventListener( RoomEvent.NICK_CONFLICT, onRoomEvent);
		_chatRoom.addEventListener( RoomEvent.ROOM_DESTROYED, onRoomEvent);
		_chatRoom.addEventListener( RoomEvent.ROOM_JOIN, onRoomJoin);
		_chatRoom.addEventListener( RoomEvent.ROOM_LEAVE, onRoomEvent);
		_chatRoom.addEventListener( RoomEvent.USER_DEPARTURE, onRoomEvent);
		_chatRoom.addEventListener( RoomEvent.USER_JOIN, onRoomEvent);
		_chatRoom.addEventListener( RoomEvent.USER_KICKED, onRoomEvent);
		_chatRoom.addEventListener( RoomEvent.USER_BANNED, onRoomEvent);

		_chatRoom.addEventListener(XIFFErrorEvent.XIFF_ERROR, onXiffError);
	}

	protected function removeRoomListeners():void
	{
		_chatRoom.removeEventListener( RoomEvent.AFFILIATIONS, onRoomEvent);
		_chatRoom.removeEventListener( RoomEvent.CONFIGURE_ROOM, onRoomEvent);
		_chatRoom.removeEventListener( RoomEvent.DECLINED, onRoomEvent);
		_chatRoom.removeEventListener( RoomEvent.NICK_CONFLICT, onRoomEvent);
		_chatRoom.removeEventListener( RoomEvent.ROOM_DESTROYED, onRoomEvent);
		_chatRoom.removeEventListener( RoomEvent.ROOM_JOIN, onRoomEvent);
		_chatRoom.removeEventListener( RoomEvent.ROOM_LEAVE, onRoomEvent);
		_chatRoom.removeEventListener( RoomEvent.USER_DEPARTURE, onRoomEvent);
		_chatRoom.removeEventListener( RoomEvent.USER_JOIN, onRoomEvent);
		_chatRoom.removeEventListener( RoomEvent.USER_KICKED, onRoomEvent);
		_chatRoom.removeEventListener( RoomEvent.USER_BANNED, onRoomEvent);

		_chatRoom.removeEventListener(XIFFErrorEvent.XIFF_ERROR, onXiffError);
	}

	protected function onRoomEvent(event:Event):void
	{
		log.debug("!!!! ROOM EVENT ({0}): {1}", [_chatRoom.room.roomName, event.type]);
	}

	protected function onXiffError(event:XIFFErrorEvent):void
	{
		log.debug("!!!! ROOM ERROR ({0}) - errorCode: {1}, errorCondition: {2}, errorType: {3}, errorMessage: {4}", [_chatRoom.room.roomName, event.errorCode, event.errorCondition, event.errorType, event.errorMessage]);
	}
}
}
