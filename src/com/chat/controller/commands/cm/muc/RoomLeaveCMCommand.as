/**
 * Created by kvint on 17.11.14.
 */
package com.chat.controller.commands.cm.muc {
	import com.chat.controller.commands.cm.CMCommand;
	import com.chat.model.communicators.RoomCommunicator;

	public class RoomLeaveCMCommand extends CMCommand {

		override protected function executeIfNoErrors():void {
			print("leave");
			if(roomCommunicator){
				roomCommunicator.chatRoom.leave(false);
				model.communicators.dispose(roomCommunicator);
			}
		}
		private function get roomCommunicator():RoomCommunicator {
			return communicator as RoomCommunicator;
		}
	}
}
