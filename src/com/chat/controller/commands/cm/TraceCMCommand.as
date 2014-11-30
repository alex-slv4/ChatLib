/**
 * Created by AlexanderSla on 11.11.2014.
 */
package com.chat.controller.commands.cm {
	import com.chat.model.communicators.ICommunicatorBase;

	public class TraceCMCommand extends CMCommand {

		public function TraceCMCommand(communicator:ICommunicatorBase, params:Array) {
			super(communicator, params);
		}

		override protected function executeIfNoErrors():void {
			print("trace:");
			for(var i:int = 0; i < params.length; i++) {
				var string:String = params[i];
				print(string);
			}
		}
	}
}
