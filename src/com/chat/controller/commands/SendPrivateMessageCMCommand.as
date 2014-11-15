/**
 * Created by AlexanderSla on 11.11.2014.
 */
package com.chat.controller.commands {
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.data.ChatMessage;
	import com.chat.model.data.MessageItem;

	import flash.utils.clearTimeout;

	import org.igniterealtime.xiff.data.Message;

	public class SendPrivateMessageCMCommand extends CMCommand {

		override protected function executeIfNoErrors():void {


			var message:ChatMessage = new ChatMessage(directCommunicatorData.participant.escaped);

			message.type = Message.TYPE_CHAT;
			message.from = directCommunicatorData.chatUser.jid.escaped;
			message.body = params[0];
			message.state = Message.STATE_ACTIVE;
			directCommunicatorData.push(new MessageItem(message));

			controller.sendMessage(message);

			clearTimeout(SendMessageStateCMCommand.STATE_TIMER_ID);
		}

		private function get directCommunicatorData():DirectCommunicator {
			return communicator as DirectCommunicator;
		}
		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
