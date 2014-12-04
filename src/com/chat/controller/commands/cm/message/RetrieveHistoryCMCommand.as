/**
 * Created by kvint on 16.11.14.
 */
package com.chat.controller.commands.cm.message {
	import com.chat.controller.commands.cm.CMCommand;
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.data.ICItem;

	import flash.utils.setTimeout;

	import robotlegs.bender.framework.api.IInjector;

	public class RetrieveHistoryCMCommand extends CMCommand {

		[Inject]
		public var injector:IInjector;

		override protected function executeIfNoErrors():void {
			directCommunicator.history.fetchNext(onHistoryLoaded);
		}

		private function onHistoryLoaded(items:Vector.<ICItem>):void {
			for (var i:int = 0; i < items.length; i++) {
				directCommunicator.push(items[i]);
			}
			if(items.length > 0){
				setTimeout(directCommunicator.history.fetchNext, 10, arguments.callee);
			}
		}

		private function get directCommunicator():DirectCommunicator {
			return communicator as DirectCommunicator;
		}
	}
}
