/**
 * Created by kvint on 29.11.14.
 */
package com.chat.config {
	import com.chat.controller.commands.cm.ClearCMCommand;
	import com.chat.controller.commands.cm.CloseCMCommand;
	import com.chat.controller.commands.cm.HelpCMCommand;
	import com.chat.controller.commands.cm.InfoCMCommand;
	import com.chat.controller.commands.cm.TraceCMCommand;
	import com.chat.controller.commands.cm.message.RetrieveHistoryCMCommand;
	import com.chat.controller.commands.cm.muc.RoomCMCommand;
	import com.chat.controller.commands.cm.muc.RoomCreateCMCommand;
	import com.chat.controller.commands.cm.roster.RosterCMCommand;
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.communicators.RoomCommunicator;

	import flash.utils.Dictionary;

	import org.as3commons.lang.DictionaryUtils;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	public class CMCommandsConfig implements ICMCommandsConfig {

		private var _globalCommands:Dictionary = new Dictionary();
		private var _concreteCommands:Dictionary = new Dictionary();

		[PostConstruct]
		public function init():void {
			_globalCommands["trace"] = TraceCMCommand;
			_globalCommands["history"] = RetrieveHistoryCMCommand;
			_globalCommands["clear"] = ClearCMCommand;
			_globalCommands["help"] = HelpCMCommand;
			_globalCommands["info"] = InfoCMCommand;
			_globalCommands["close"] = CloseCMCommand;
			_globalCommands["roster"] = RosterCMCommand;

			_concreteCommands[RoomCommunicator] = new Dictionary();
			_concreteCommands[RoomCommunicator]["room"] = RoomCMCommand;

			_concreteCommands[DirectCommunicator] = new Dictionary();
			_concreteCommands[DirectCommunicator]["invite"] = RoomCreateCMCommand;
		}


		public function getCommand(name:String, forClass:Class = null):Class {
			if(forClass){
				var concreteCommand:Dictionary = _concreteCommands[forClass];
				if(concreteCommand && concreteCommand.hasOwnProperty(name)){
					return concreteCommand[name];
				}
			}
			return _globalCommands[name];
		}

		public function getCommands(forClass:Class = null):Array {
			var commands:Array = [];
			if(forClass){
				var concreteCommand:Dictionary = _concreteCommands[forClass];
				if(concreteCommand){
					commands = DictionaryUtils.getKeys(concreteCommand);
				}
			}
			commands = commands.concat(DictionaryUtils.getKeys(_globalCommands));
			return commands;
		}
	}
}
