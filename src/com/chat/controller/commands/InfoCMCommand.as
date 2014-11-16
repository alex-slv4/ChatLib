/**
 * Created by kvint on 16.11.14.
 */
package com.chat.controller.commands {
	public class InfoCMCommand extends CMCommand {

		override protected function executeIfNoErrors():void {
			print(communicator);
			print("Current user:", model.currentUser.jid);
		}
	}
}
