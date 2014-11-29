/**
 * Created by kvint on 29.11.14.
 */
package com.chat.controller.commands.cm {
	import com.chat.config.ICMCommandsConfig;
	import com.chat.model.communicators.IWritableCommunicator;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;
	import robotlegs.bender.framework.api.IInjector;

	public class ExecuteCMCommand implements ICommand{

		[Inject]
		public var communicator:IWritableCommunicator;

		[Inject]
		public var commandName:String;

		[Inject]
		public var commandParams:Array;

		[Inject]
		public var commandsConfig:ICMCommandsConfig;

		[Inject]
		public var injector:IInjector;

		public function execute():void {
			var CommandClass:Class = commandsConfig.getCommand(commandName, communicator ? (communicator as Object).constructor : null);
			if(CommandClass){
				var command:CMCommand = new CommandClass(communicator, commandParams);
				injector.injectInto(command);
				command.execute();
			}else{
				//communicator.send()
			}
		}
	}
}
