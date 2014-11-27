/**
 * Created by kvint on 16.11.14.
 */
package com.chat.controller.commands {
	import com.chat.events.CommunicatorEvent;
	import com.chat.model.activity.IActivitiesHandler;
	import com.chat.model.communicators.ICommunicator;
	import com.chat.model.communicators.factory.ICommunicatorFactory;
	import com.chat.model.data.СItemMessage;

	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.events.MessageEvent;

	public class MessageCommand extends BaseChatCommand {

		[Inject]
		public var event:MessageEvent;

		[Inject]
		public var communicators:ICommunicatorFactory;

		[Inject]
		public var activities:IActivitiesHandler;

		override public function execute():void {

			var message:Message = event.data;

			if(message.type == null){
				trace("Message not handled");
				trace(message.xml);
				return;
			}

			activities.handleActivity(message);

			var communicator:ICommunicator = communicators.getFor(message) as ICommunicator;
			if (message.receipt == Message.RECEIPT_RECEIVED) { //It's ack ackMessage
				handleReceipt(message, communicator);
			}

			var itemMessage:СItemMessage = new СItemMessage(message);
			communicator.push(itemMessage);

			if (message.from.equals(model.currentUser.jid.escaped, true)) {
				//do nothing
			} else {
				communicator.unreadCount++;
			}
			communicator.active = true;
		}

		private function handleReceipt(message:Message, communicator:ICommunicator):void {
			var receiptMessageItem:СItemMessage = model.receiptRequests[message.receiptId];
			if (receiptMessageItem) {
				delete model.receiptRequests[message.receiptId];
				var message:Message = receiptMessageItem.data as Message;
				receiptMessageItem.isRead = true;
				message.receipt = null;
				communicator.dispatchEvent(new CommunicatorEvent(CommunicatorEvent.ITEM_UPDATED, receiptMessageItem));
			}
		}
	}
}
