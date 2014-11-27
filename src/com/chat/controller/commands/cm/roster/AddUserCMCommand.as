/**
 * Created by kvint on 14.11.14.
 */
package com.chat.controller.commands.cm.roster {
	import com.chat.controller.commands.cm.CMCommand;

	import org.igniterealtime.xiff.core.UnescapedJID;

	public class AddUserCMCommand extends CMCommand {

		override protected function executeIfNoErrors():void {
			var bodyName:String = params[0];
			var hasDomain:Boolean = bodyName.indexOf("@") == -1;
			bodyName += hasDomain ? "@" + model.connection.domain : "";
			var bodyJID:UnescapedJID = new UnescapedJID(bodyName);
			model.roster.addContact(bodyJID, bodyJID.node.toString(), "Buddies", true);
		}

		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
