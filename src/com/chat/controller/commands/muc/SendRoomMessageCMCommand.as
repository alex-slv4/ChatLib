/**
 * Created by kvint on 11.11.14.
 */
package com.chat.controller.commands.muc {
	import com.chat.controller.commands.CMCommand;
	import com.chat.model.communicators.RoomCommunicator;
	import com.chat.model.data.ChatMessage;

	import org.igniterealtime.xiff.data.Message;

	public class SendRoomMessageCMCommand extends CMCommand {

		override protected function executeIfNoErrors():void {
			var messageText:String = params[0];
			var message:ChatMessage = new ChatMessage();
			message.type = Message.TYPE_GROUPCHAT;
			message.from = model.currentUser.jid.escaped;
			message.to = roomCommunicator.chatRoom.room.roomJID.escaped;
			message.body = messageText;
			controller.sendRoomMessage(message);
		}

		private function get roomCommunicator():RoomCommunicator {
			return communicator as RoomCommunicator;
		}

		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
