/**
 * Created by kvint on 17.11.14.
 */
package com.chat.controller.commands.cm.muc {
	import com.chat.model.communicators.ICommunicatorBase;

	public class RoomLeaveCMCommand extends RoomCMCommand {


		public function RoomLeaveCMCommand(communicator:ICommunicatorBase, params:Array) {
			super(communicator, params);
		}

		override protected function executeIfNoErrors():void {
			print("leave");
			roomCommunicator.chatRoom.leave();
			model.communicators.dispose(roomCommunicator);
		}
	}
}
