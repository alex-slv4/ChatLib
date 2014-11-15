/**
 * Created by kvint on 16.11.14.
 */
package com.chat.controller.commands {
	import com.chat.model.data.MessageItem;

	import org.igniterealtime.xiff.data.Message;

	public class MarkAsReadCMCommand extends CMCommand {


		override protected function executeIfNoErrors():void {
			var message:Message = messageItem.data as Message;
			if(message.from.equals(model.currentUser.jid.escaped, true)) {
				//do nothing
			}else{
				if(!messageItem.isRead){
					communicator.unreadCount--;
					messageItem.isRead = true;
				}
			}
			if(message.receipt == Message.RECEIPT_REQUEST){
				message.receipt = null;
				var ackMessage:Message = new Message();
				ackMessage.from = message.to;
				ackMessage.to = message.from;
				ackMessage.receipt = Message.RECEIPT_RECEIVED;
				ackMessage.receiptId = message.id;

				controller.connection.send(ackMessage);
			}
		}

		private function get messageItem():MessageItem {
			return params[0];
		}

		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
