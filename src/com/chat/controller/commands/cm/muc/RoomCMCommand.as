/**
 * Created by AlexanderSla on 11.11.2014.
 */
package com.chat.controller.commands.cm.muc {
	import com.chat.controller.commands.cm.MacroCMCommand;
	import com.chat.events.CommunicatorCommandEvent;
	import com.chat.model.ChatRoom;
	import com.chat.model.communicators.ICommunicator;
	import com.chat.model.communicators.RoomCommunicator;

	import org.igniterealtime.xiff.data.forms.FormExtension;
	import org.igniterealtime.xiff.events.RoomEvent;

	public class RoomCMCommand extends MacroCMCommand {

		protected var _chatRoom:ChatRoom;

		public function RoomCMCommand() {
			subCommands["join"] = CommunicatorCommandEvent.ROOM_JOIN;
			subCommands["create"] = CommunicatorCommandEvent.ROOM_CREATE;
		}


		override public function execute():void {
			if(communicator is RoomCommunicator){
				subCommands["info"] = CommunicatorCommandEvent.ROOM_INFO;
			}
			super.execute();
		}
	}
}
