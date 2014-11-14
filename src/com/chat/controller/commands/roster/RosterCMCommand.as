/**
 * Created by kvint on 14.11.14.
 */
package com.chat.controller.commands.roster {
	import com.chat.controller.commands.*;
	import com.chat.events.CommunicatorCommandEvent;

	public class RosterCMCommand extends MacroCMCommand {

		public function RosterCMCommand() {
			subCommands["info"] = CommunicatorCommandEvent.ROSTER_INFO;
			subCommands["add"] = CommunicatorCommandEvent.ROSTER_ADD;
		}
	}
}
