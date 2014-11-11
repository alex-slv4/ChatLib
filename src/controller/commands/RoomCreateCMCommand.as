/**
 * Created by AlexanderSla on 11.11.2014.
 */
package controller.commands {
	import controller.ChatController;

	import model.ChatModel;
	import model.communicators.RoomCommunicator;

	public class RoomCreateCMCommand extends CMCommand {

		[Inject]
		public var chatModel:ChatModel;
		[Inject]
		public var chatController:ChatController;

		override protected function _execute():void {
			var roomName:String = params[0];
			var iCommunicator:RoomCommunicator = chatModel.provider.getCommunicator(roomName) as RoomCommunicator;
			iCommunicator.chatRoom.chatManager = chatController;
			iCommunicator.chatRoom.create(roomName);

		}

		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
