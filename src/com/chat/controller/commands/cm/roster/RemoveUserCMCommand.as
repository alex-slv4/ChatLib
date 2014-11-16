/**
 * Created by kvint on 16.11.14.
 */
package com.chat.controller.commands.cm.roster {
	import com.chat.controller.commands.cm.CMCommand;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.im.RosterItemVO;

	public class RemoveUserCMCommand extends CMCommand {

		override protected function executeIfNoErrors():void {
			var bodyName:String = params[0];
			var bodyJID:UnescapedJID;
			try {

				bodyJID = new UnescapedJID(bodyName);

			} catch (e:Error) {

				error(e.message);

			}finally{

				var rosterItem:RosterItemVO = RosterItemVO.get(bodyJID);
				controller.removeBuddy(rosterItem);
				print(bodyName, "removed");
			}
		}

		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
