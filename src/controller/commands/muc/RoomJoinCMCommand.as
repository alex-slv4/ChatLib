/**
 * Created by kvint on 11.11.14.
 */
package controller.commands.muc {
	import controller.ChatController;
	import controller.commands.CMCommand;

	import model.ChatModel;

	import model.ChatRoom;

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
			event;
		}

		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
