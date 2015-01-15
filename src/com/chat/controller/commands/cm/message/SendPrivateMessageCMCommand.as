/**
 * Created by AlexanderSla on 11.11.2014.
 */
package com.chat.controller.commands.cm.message {
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.communicators.IConversationsCommunicator;
	import com.chat.model.data.citems.CMessage;
	import com.chat.model.data.citems.CTime;

	import org.igniterealtime.xiff.data.Message;

	public class SendPrivateMessageCMCommand extends SendMessageBaseCommand {

		override protected function executeIfNoErrors():void {

			var message:Message = new Message();

			message.type = Message.TYPE_CHAT;
			message.from = directCommunicatorData.chatUser.jid.escaped;
			message.to = directCommunicatorData.participant.escaped;
			message.body = params[0];
			message.state = Message.STATE_ACTIVE;

			var messageItem:CMessage = new CMessage(message, CTime.currentTime);
			directCommunicatorData.items.append(messageItem);

			//save receipt
			message.receipt = Message.RECEIPT_REQUEST;
			model.receiptRequests[message.id] = messageItem;

			send(message);

			//clear receipt
			message.receipt = null;

			//clear state timer
			SendMessageStateCMCommand.cancel();
		}

		private function get directCommunicatorData():DirectCommunicator {
			return communicator as DirectCommunicator;
		}
		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
