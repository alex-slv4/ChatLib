/**
 * Created by AlexanderSla on 11.11.2014.
 */
package com.chat.controller.commands.cm {
	import com.chat.model.data.citems.CTitle;

	public class TestCMCommand extends CMCommand {

		override protected function executeIfNoErrors():void {
			communicator.items.append(new CTitle("TestCMCommand"));
			for(var i:int = 0; i < params.length; i++) {
				var string:String = params[i];
				print(string);
			}
		}
	}
}
