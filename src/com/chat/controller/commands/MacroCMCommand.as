/**
 * Created by kvint on 14.11.14.
 */
package com.chat.controller.commands {
	import com.adobe.utils.DictionaryUtil;
	import com.chat.events.CommunicatorCommandEvent;

	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	public class MacroCMCommand extends CMCommand {

		protected var subCommands:Dictionary = new Dictionary();

		override protected function onParamsError():void {
			printInfo();
		}

		protected function printInfo():void {
			print(this);
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

		override protected function executeIfNoErrors():void {
			var subCommandName:String = params[0];
			var keys:Array = DictionaryUtil.getKeys(subCommands);
			if (keys.indexOf(subCommandName) != -1) {
				runSubCommand(subCommandName);
			} else {
				error(this, "failed");
			}
		}
	}
}
