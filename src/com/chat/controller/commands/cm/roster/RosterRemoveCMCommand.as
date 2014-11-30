/**
 * Created by kvint on 16.11.14.
 */
package com.chat.controller.commands.cm.roster {
	import com.chat.controller.commands.cm.CMCommand;
	import com.chat.model.communicators.ICommunicatorBase;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.im.RosterItemVO;

	public class RosterRemoveCMCommand extends CMCommand {

		public function RosterRemoveCMCommand(communicator:ICommunicatorBase, params:Array) {
			super(communicator, params);
		}

		override protected function executeIfNoErrors():void {
			var bodyName:String = params[0];
			var bodyJID:UnescapedJID;
			try {

				bodyJID = new UnescapedJID(bodyName);

			} catch (e:Error) {

				error(e.message);

			}finally{

				var rosterItem:RosterItemVO = RosterItemVO.get(bodyJID);
				model.roster.removeContact(rosterItem);
				print(bodyName, "removed");
			}
		}

		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
