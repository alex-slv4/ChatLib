/**
 * Created by kvint on 11.11.14.
 */
package com.chat.controller.commands.cm.muc {
	import com.chat.model.ChatUser;
	import com.chat.model.communicators.ICommunicatorBase;

	import org.igniterealtime.xiff.data.IPresence;

	public class RoomInfoCMCommand extends RoomCMCommand {

		public function RoomInfoCMCommand(communicator:ICommunicatorBase, params:Array) {
			super(communicator, params);
		}

		override protected function executeIfNoErrors():void {
			for (var i:int = 0; i < roomCommunicator.chatRoom.users.length; i++) {
				var user:ChatUser = roomCommunicator.chatRoom.users.getItemAt(i) as ChatUser;
				var presence:IPresence = model.presences.getByUID(user.jid.bareJID);
				var online:Boolean = presence != null;
				print(user.displayName + " (" + user.jid + ")", online ? "on" : "off");

			}
		}
	}
}
