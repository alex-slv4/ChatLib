/**
 * Created by AlexanderSla on 11.11.2014.
 */
package com.chat.controller.commands.cm.message {
	import com.chat.controller.commands.cm.CMCommand;
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.communicators.IWritableCommunicator;
	import com.chat.model.data.СItemMessage;

	import flash.utils.clearTimeout;

	import org.igniterealtime.xiff.data.Message;

	public class SendPrivateMessageCMCommand extends CMCommand {

		override protected function executeIfNoErrors():void {

			var message:Message = new Message();

			message.type = Message.TYPE_CHAT;
			message.from = directCommunicatorData.chatUser.jid.escaped;
			message.to = directCommunicatorData.participant.escaped;
			message.body = params[0];
			message.state = Message.STATE_ACTIVE;

			var messageItem:СItemMessage = new СItemMessage(message);
			directCommunicatorData.push(messageItem);

			//save receipt
			message.receipt = Message.RECEIPT_REQUEST;
			model.receiptRequests[message.id] = messageItem;

			//append thread
			appendThread(message);

			//send data
			controller.send(message);

			//clear receipt
			message.receipt = null;

			//clear composing timer
			clearTimeout(SendMessageStateCMCommand.STATE_TIMER_ID);
		}

		private function appendThread(message:Message):void {
			if(communicator is IWritableCommunicator){
				var writable:IWritableCommunicator = communicator as IWritableCommunicator;
				if(writable.thread == null) {
					writable.thread = model.threadGenerator.generateID();
				}
				message.thread = writable.thread;
			}
		}

		private function get directCommunicatorData():DirectCommunicator {
			return communicator as DirectCommunicator;
		}
		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
