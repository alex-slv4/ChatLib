/**
 * Created by kvint on 16.11.14.
 */
package com.chat.controller.commands.cm.message {
	import com.chat.controller.commands.cm.CMCommand;
	import com.chat.model.communicators.DirectCommunicator;

	import robotlegs.bender.framework.api.IInjector;

	public class RetrieveHistoryCMCommand extends CMCommand {

		[Inject]
		public var injector:IInjector;

		override protected function executeIfNoErrors():void {
			var count:int = params[0];
			directCommunicator.history.fetch();
		}

		private function get directCommunicator():DirectCommunicator {
			return communicator as DirectCommunicator;
		}
	}
}
