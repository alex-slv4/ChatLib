/**
 * Created by kvint on 11.11.14.
 */
package com.chat.controller.commands.cm.muc {
	import com.chat.controller.commands.cm.message.SendMessageBaseCommand;
	import com.chat.controller.commands.cm.message.SendMessageStateCMCommand;
	import com.chat.model.communicators.ICommunicatorBase;
	import com.chat.model.communicators.RoomCommunicator;

	import org.igniterealtime.xiff.data.Message;

	public class SendRoomMessageCMCommand extends SendMessageBaseCommand {

		public function SendRoomMessageCMCommand(communicator:ICommunicatorBase, params:Array) {
			super(communicator, params);
		}

		override protected function executeIfNoErrors():void {
			var messageText:String = params[0];
			var message:Message = new Message();
			message.type = Message.TYPE_GROUPCHAT;
			message.from = model.currentUser.jid.escaped;
			message.to = roomCommunicator.chatRoom.room.roomJID.escaped;
			message.body = messageText;
			message.state = Message.STATE_ACTIVE;

			SendMessageStateCMCommand.cancel();

			send(message);
		}

		private function get roomCommunicator():RoomCommunicator {
			return communicator as RoomCommunicator;
		}

		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
