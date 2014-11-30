/**
 * Created by AlexanderSla on 11.11.2014.
 */
package com.chat.controller.commands.cm.muc {
	import com.chat.controller.commands.cm.MacroCMCommand;
	import com.chat.model.ChatRoom;
	import com.chat.model.communicators.ICommunicatorBase;
	import com.chat.model.communicators.RoomCommunicator;

	public class RoomCMCommand extends MacroCMCommand {

		protected var _chatRoom:ChatRoom;

		public function RoomCMCommand(communicator:ICommunicatorBase, params:Array) {
			super(communicator, params);
			subCommands["join"] = RoomJoinCMCommand;
			subCommands["create"] = RoomCreateCMCommand;
			subCommands["leave"] = RoomLeaveCMCommand;
		}

		protected function get roomCommunicator():RoomCommunicator {
			return communicator as RoomCommunicator;
		}
	}
}
