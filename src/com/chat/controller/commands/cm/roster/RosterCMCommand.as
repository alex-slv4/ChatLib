/**
 * Created by kvint on 14.11.14.
 */
package com.chat.controller.commands.cm.roster {
	import com.chat.controller.commands.cm.MacroCMCommand;
	import com.chat.model.communicators.ICommunicatorBase;

	public class RosterCMCommand extends MacroCMCommand {

		public function RosterCMCommand(communicator:ICommunicatorBase, params:Array) {
			super(communicator, params);
			subCommands["info"] = RosterInfoCommand;
			subCommands["add"] = RosterAddCMCommand;
			subCommands["remove"] = RosterRemoveCMCommand;
		}
	}
}
