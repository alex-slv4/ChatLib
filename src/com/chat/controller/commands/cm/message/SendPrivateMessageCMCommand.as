/**
 * Created by AlexanderSla on 11.11.2014.
 */
package com.chat.controller.commands.cm.message {
	import com.chat.controller.commands.cm.CMCommand;
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.data.СItemMessage;

	import flash.utils.clearTimeout;

	import org.igniterealtime.xiff.data.Message;

	public class SendPrivateMessageCMCommand extends CMCommand {

		override protected function executeIfNoErrors():void {

			var message:Message = new Message(directCommunicatorData.participant.escaped);

			message.type = Message.TYPE_CHAT;
			message.from = directCommunicatorData.chatUser.jid.escaped;
			message.body = params[0];
			message.state = Message.STATE_ACTIVE;

			var messageItem:СItemMessage = new СItemMessage(message);
			directCommunicatorData.push(messageItem);

			//save receipt
			message.receipt = Message.RECEIPT_REQUEST;
			model.receiptRequests[message.id] = messageItem;

			//send data
			controller.send(message);

			//clear receipt
			message.receipt = null;

			//clear composing timer
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
