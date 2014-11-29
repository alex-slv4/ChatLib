/**
 * Created by AlexanderSla on 11.11.2014.
 */
package com.chat.controller.commands.cm {
	import com.chat.model.communicators.ICommunicatorBase;

	public class ClearCMCommand extends CMCommand {

		public function ClearCMCommand(communicator:ICommunicatorBase, params:Array) {
			super(communicator, params);
		}

		override protected function executeIfNoErrors():void {
			communicator.clear();
		}
	}
}
