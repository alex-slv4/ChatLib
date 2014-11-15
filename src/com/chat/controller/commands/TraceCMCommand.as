/**
 * Created by AlexanderSla on 11.11.2014.
 */
package com.chat.controller.commands {
	public class TraceCMCommand extends CMCommand {

		override protected function executeIfNoErrors():void {
			print("trace:");
			for(var i:int = 0; i < params.length; i++) {
				var string:String = params[i];
				print(string);
			}
		}
	}
}
