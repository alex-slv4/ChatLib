/**
 * Created by kvint on 18.11.14.
 */
package com.chat.controller.commands.cm {
	import com.chat.model.communicators.ICommunicator;
	import com.chat.model.communicators.ICommunicatorBase;

	public class CloseCMCommand extends CMCommand {

		public function CloseCMCommand(communicator:ICommunicatorBase, params:Array) {
			super(communicator, params);
		}

		override protected function executeIfNoErrors():void {
			if(communicator is ICommunicator){
				communicators.dispose(communicator as ICommunicator);
			}
		}
	}
}
