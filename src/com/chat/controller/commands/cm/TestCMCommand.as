/**
 * Created by kvint on 18.11.14.
 */
package com.chat.controller.commands.cm {
	import com.chat.model.communicators.UIDCommunicator;

	public class TestCMCommand extends CMCommand {

		override protected function executeIfNoErrors():void {
			if(communicator is UIDCommunicator){
				model.provider.destroyCommunicator(communicator as UIDCommunicator);
			}

		}
	}
}
