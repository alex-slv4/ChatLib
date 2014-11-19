/**
 * Created by kvint on 16.11.14.
 */
package com.chat.controller.commands.cm {
	public class InfoCMCommand extends CMCommand {

		override protected function executeIfNoErrors():void {
			print(communicator.toString());
			print("Current user:", model.currentUser.jid);
		}
	}
}
