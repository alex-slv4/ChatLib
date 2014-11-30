/**
 * Created by kvint on 14.11.14.
 */
package com.chat.controller.commands.cm {
	import com.adobe.utils.DictionaryUtil;
	import com.chat.model.communicators.ICommunicatorBase;
	import com.chat.signals.CommunicatorSignal;

	import flash.utils.Dictionary;

	import robotlegs.bender.framework.api.IInjector;

	public class MacroCMCommand extends CMCommand {

		[Inject]
		public var communicatorSignal:CommunicatorSignal;

		[Inject]
		public var injector:IInjector;

		protected var subCommands:Dictionary = new Dictionary();


		public function MacroCMCommand(communicator:ICommunicatorBase, params:Array) {
			super(communicator, params);
		}

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
			var subParams:Array = params.concat();
			subParams.shift();
			var CommandClass:Class = subCommands[commandName];
			if(CommandClass) {
				var command:CMCommand = new CommandClass(communicator, subParams);
				injector.injectInto(command);
				command.execute();
			}
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
				onSubCommandNotFound(subCommandName);
			}
		}

		protected function onSubCommandNotFound(subCommandName:String):void {
			error(this, subCommandName, "not found");
		}
	}
}
