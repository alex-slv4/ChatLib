/**
 * Created by kvint on 13.11.14.
 */
package com.chat.controller.commands.cm {
	import com.chat.config.ICMCommandsConfig;
	import com.chat.model.communicators.ICommunicatorBase;

	public class HelpCMCommand extends CMCommand {

		[Inject]
		public var commandsMap:ICMCommandsConfig;

		public function HelpCMCommand(communicator:ICommunicatorBase, params:Array) {
			super(communicator, params);
		}

		override protected function executeIfNoErrors():void {
			var keys:Array = commandsMap.getCommands(communicator ? (communicator as Object).constructor : null);
			print(communicator);
			for (var i:int = 0; i < keys.length; i++) {
				print(keys[i]);
			}
		}

	}
}
