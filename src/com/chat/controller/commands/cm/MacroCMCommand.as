/**
 * Created by kvint on 14.11.14.
 */
package com.chat.controller.commands.cm {
	import com.chat.events.CommunicatorCommandEvent;

	import flash.utils.Dictionary;

	import org.as3commons.lang.DictionaryUtils;

	public class MacroCMCommand extends CMCommand {

		protected var subCommands:Dictionary = new Dictionary();

		override protected function onParamsError():void {
			printInfo();
		}

		protected function printInfo():void {
			print(this);
			var keys:Array = DictionaryUtils.getKeys(subCommands);
			for (var i:int = 0; i < keys.length; i++) {
				print(keys[i]);
			}
		}

		public function runSubCommand(commandName:String):void {
			var eventName:String = subCommands[commandName];
			var subParams:Array = params.concat();
			subParams.shift();
			bus.dispatchEvent(new CommunicatorCommandEvent(eventName, communicator, subParams));
		}
		override public function get requiredParamsCount():int {
			return 1;
		}

		override protected function executeIfNoErrors():void {
			var subCommandName:String = params[0];
			var keys:Array = DictionaryUtils.getKeys(subCommands);
			if (keys.indexOf(subCommandName) != -1) {
				runSubCommand(subCommandName);
			} else {
				onSubCommandNotFound(subCommandName);
			}
		}

		protected function onSubCommandNotFound(subCommandName:String):void {
			error(this, subCommandName, "not found");
		}
	}
}
