/**
 * Created by kvint on 14.11.14.
 */
package com.chat.controller.commands {
	import org.igniterealtime.xiff.core.UnescapedJID;

	public class AddUserCMCommand extends CMCommand {

		override protected function _execute():void {
			var bodyName:String = params[0];
			chatController.addBuddy(new UnescapedJID(bodyName));
		}

		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
