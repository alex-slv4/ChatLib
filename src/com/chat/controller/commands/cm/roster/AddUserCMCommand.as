/**
 * Created by kvint on 14.11.14.
 */
package com.chat.controller.commands.cm.roster {
	import com.chat.controller.commands.cm.CMCommand;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.util.JIDUtil;

	public class AddUserCMCommand extends CMCommand {

		override protected function executeIfNoErrors():void {
			var bodyJID:UnescapedJID = JIDUtil.createJID(params[0], model.connection.domain);
			model.roster.addContact(bodyJID, bodyJID.node.toString(), "Buddies", true);
		}

		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
