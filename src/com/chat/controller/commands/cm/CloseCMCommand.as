/**
 * Created by kvint on 18.11.14.
 */
package com.chat.controller.commands.cm {
	import com.chat.model.communicators.ICommunicator;

	public class CloseCMCommand extends CMCommand {

		override protected function executeIfNoErrors():void {
			if(communicator is ICommunicator){
				model.communicators.dispose(communicator as ICommunicator);
			}
		}
	}
}
