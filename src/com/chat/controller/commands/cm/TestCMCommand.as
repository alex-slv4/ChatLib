/**
 * Created by kvint on 18.11.14.
 */
package com.chat.controller.commands.cm {
	public class TestCMCommand extends CMCommand {

		override protected function executeIfNoErrors():void {
			model.provider.destroyCommunicator(communicator);
		}
	}
}
