/**
 * Created by AlexanderSla on 11.11.2014.
 */
package controller.commands {
	import controller.ChatController;

	import model.ChatModel;
	import model.ChatRoom;
	import model.communicators.ICommunicator;
	import model.communicators.RoomCommunicator;

	import org.igniterealtime.xiff.data.forms.FormExtension;

	import org.igniterealtime.xiff.events.RoomEvent;

	public class RoomCreateCMCommand extends CMCommand {

		[Inject]
		public var chatModel:ChatModel;
		[Inject]
		public var chatController:ChatController;
		private var _chatRoom:ChatRoom;

		override protected function _execute():void {
			var roomName:String = params[0];
			_chatRoom = new ChatRoom();
			_chatRoom.chatManager = chatController;
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
			var iCommunicator:ICommunicator = chatModel.provider.getCommunicator(_chatRoom);
			iCommunicator;
		}

		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
