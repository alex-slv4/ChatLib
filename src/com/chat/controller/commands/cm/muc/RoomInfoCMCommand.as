/**
 * Created by kvint on 11.11.14.
 */
package com.chat.controller.commands.cm.muc {
	import com.chat.controller.commands.cm.CMCommand;
	import com.chat.model.ChatUser;
	import com.chat.model.communicators.RoomCommunicator;

	public class RoomInfoCMCommand extends CMCommand {

		override protected function executeIfNoErrors():void {
			for (var i:int = 0; i < roomCommunicator.chatRoom.users.length; i++) {
				var user:ChatUser = roomCommunicator.chatRoom.users.getItemAt(i) as ChatUser;
				print(user.displayName + " (" + user.jid + ")");

			}
		}
		private function get roomCommunicator():RoomCommunicator {
			return communicator as RoomCommunicator;
		}
	}
}