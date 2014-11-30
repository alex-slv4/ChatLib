/**
 * Created by kvint on 16.11.14.
 */
package com.chat.controller.commands.cm {
	import com.chat.model.communicators.ICommunicatorBase;

	public class InfoCMCommand extends CMCommand {

		public function InfoCMCommand(communicator:ICommunicatorBase, params:Array) {
			super(communicator, params);
		}

		override protected function executeIfNoErrors():void {
			print(communicator.toString());
			print("Current user:", model.currentUser.jid);
		}
	}
}
