/**
 * Created by kvint on 16.11.14.
 */
package com.chat.controller.commands {
	import com.chat.events.CommunicatorEvent;
	import com.chat.model.data.MessageItem;

	import org.igniterealtime.xiff.data.Message;

	public class OnNewMessageCMCommand extends CMCommand {

		override protected function executeIfNoErrors():void {
			var message:Message = messageItem.data as Message;

			if (message.receipt == Message.RECEIPT_RECEIVED) { //It's ack ackMessage
				handleReceipt(message);
			}

			if (message.from.equals(model.currentUser.jid.escaped, true)) {
				//do nothing
			} else {
				communicator.unreadCount++;
			}
		}

		private function handleReceipt(message:Message):void {
			var receiptMessageItem:MessageItem = model.receiptRequests[message.receiptId];
			if (receiptMessageItem) {
				delete model.receiptRequests[message.receiptId];
				var message:Message = receiptMessageItem.data as Message;
				receiptMessageItem.isRead = true;
				message.receipt = null;
				communicator.dispatchEvent(new CommunicatorEvent(CommunicatorEvent.ITEM_UPDATED, receiptMessageItem));
			}
		}

		private function get messageItem():MessageItem {
			return params[0] as MessageItem;
		}

		override public function get requiredParamsCount():int {
			return 1;
		}
	}
}
