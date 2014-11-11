/**
 * Created by AlexanderSla on 11.11.2014.
 */
package com.chat.controller.commands {
import com.chat.controller.ChatController;
import com.chat.model.communicators.DirectCommunicator;
import com.chat.model.data.ChatMessage;

import org.igniterealtime.xiff.data.Message;

public class SendPrivateMessageCMCommand extends CMCommand {

		[Inject]
		public var chatController:ChatController;

		override protected function _execute():void {
			var message:ChatMessage = new ChatMessage(directCommunicatorData.participant.escaped);

			message.type = Message.TYPE_CHAT;
			message.from = directCommunicatorData.chatUser.jid.escaped;
			message.body = params[0];

			chatController.sendMessage(message);
		}
		private function get directCommunicatorData():DirectCommunicator {
			return communicator as DirectCommunicator;
		}
		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
