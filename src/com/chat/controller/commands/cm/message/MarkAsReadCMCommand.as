/**
 * Created by kvint on 16.11.14.
 */
package com.chat.controller.commands.cm.message {
	import com.chat.controller.commands.cm.CMCommand;
	import com.chat.model.communicators.ICommunicator;
	import com.chat.model.communicators.ICommunicatorBase;
	import com.chat.model.data.СItemMessage;

	import org.igniterealtime.xiff.data.Message;

	public class MarkAsReadCMCommand extends CMCommand {

		public function MarkAsReadCMCommand(communicator:ICommunicatorBase, params:Array) {
			super(communicator, params);
		}

		override protected function executeIfNoErrors():void {
			var message:Message = messageItem.data as Message;
			if(model.isMe(message.from)) {
				//do nothing
			}else{
				if(!messageItem.isRead){
					castedCommunicator.unreadCount--;
					messageItem.isRead = true;
				}
			}
			if(message.receipt == Message.RECEIPT_REQUEST){
				message.receipt = null;
				var ackMessage:Message = new Message();
				ackMessage.type = message.type;
				ackMessage.from = message.to;
				ackMessage.to = message.from;
				ackMessage.receipt = Message.RECEIPT_RECEIVED;
				ackMessage.receiptId = message.id;

				controller.send(ackMessage);
			}
		}
		public function get castedCommunicator():ICommunicator {
			return communicator as ICommunicator;
		}
		private function get messageItem():СItemMessage {
			return params[0];
		}

		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
