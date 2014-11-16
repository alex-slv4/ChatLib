/**
 * Created by kvint on 14.11.14.
 */
package com.chat.controller.commands.cm.roster {
	import com.chat.controller.commands.cm.MacroCMCommand;
	import com.chat.events.CommunicatorCommandEvent;

	public class RosterCMCommand extends MacroCMCommand {

		public function RosterCMCommand() {
			subCommands["info"] = CommunicatorCommandEvent.ROSTER_INFO;
			subCommands["add"] = CommunicatorCommandEvent.ROSTER_ADD;
			subCommands["remove"] = CommunicatorCommandEvent.ROSTER_REMOVE;
		}
	}
}
