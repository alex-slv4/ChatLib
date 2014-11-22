/**
 * Created by kvint on 14.11.14.
 */
package com.chat.controller.commands.cm.roster {
	import com.chat.controller.commands.cm.CMCommand;

	import org.igniterealtime.xiff.data.IPresence;

	import org.igniterealtime.xiff.data.im.RosterItemVO;

	public class RosterInfoCommand extends CMCommand {

		override protected function executeIfNoErrors():void {
			print(this);
			for (var i:int = 0; i < model.roster.length; i++) {
				var itemAt:RosterItemVO = model.roster.getItemAt(i);
				var presence:IPresence = model.presences.getByUID(itemAt.jid.toString());
				var online:Boolean = presence != null;
				print(itemAt.nickname, itemAt.jid.toString(), "|", itemAt.subscribeType, "|", online ? "on" : "off");
			}
		}
	}
}
