/**
 * Created by kvint on 14.11.14.
 */
package com.chat.controller.commands {
	import com.adobe.utils.DictionaryUtil;
	import com.chat.events.CommunicatorCommandEvent;

	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	public class MacroCMCommand extends CMCommand {

		[Inject]
		public var eventDispatcher:IEventDispatcher;
		protected var subCommands:Dictionary = new Dictionary();

		override protected function onParamsError():void {
			printInfo();
		}

		private function printInfo():void {
			var keys:Array = DictionaryUtil.getKeys(subCommands);
			for (var i:int = 0; i < keys.length; i++) {
				print(keys[i]);
			}
		}

		public function runSubCommand(commandName:String):void {
			var eventName:String = subCommands[commandName];
			var subParams:Array = params.concat();
			subParams.shift();
			eventDispatcher.dispatchEvent(new CommunicatorCommandEvent(eventName, communicator, subParams));
		}
		override public function get requiredParamsCount():int {
			return 1;
		}

		override protected function _execute():void {
			var subCommandName:String = params[0];
			var keys:Array = DictionaryUtil.getKeys(subCommands);
			if (subCommandName in keys) {
				runSubCommand(subCommandName);
			} else {
				error("MUCCMCommand failed");
			}
		}
	}
}
