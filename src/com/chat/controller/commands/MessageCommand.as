/**
 * Created by kvint on 16.11.14.
 */
package com.chat.controller.commands {
	import com.chat.events.CommunicatorEvent;
	import com.chat.model.activity.IActivitiesHandler;
	import com.chat.model.communicators.ICommunicator;
	import com.chat.model.communicators.IConversationsCommunicator;
	import com.chat.model.communicators.IWritableCommunicator;
	import com.chat.model.communicators.factory.ICommunicatorFactory;
	import com.chat.model.data.CItemMessage;

	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.events.MessageEvent;

	public class MessageCommand extends BaseChatCommand {

		[Inject]
		public var event:MessageEvent;

		[Inject]
		public var communicators:ICommunicatorFactory;

		[Inject]
		public var activities:IActivitiesHandler;

		[Inject]
		public var conversations:IConversationsCommunicator;

		override public function execute():void {

			var message:Message = event.data;

			if(message.type == null){
				trace("Message not handled");
				trace(message.xml);
				return;
			}

			activities.handleActivity(message);

			var communicator:ICommunicator = communicators.getFor(message) as ICommunicator;

			handleReceipt(message, communicator);
			handleThread(message, communicator);


			if(message.body == null){
				trace("Message without body");
				trace(message.xml);
				return;
			}

			var itemMessage:CItemMessage = new CItemMessage(message);
			communicator.push(itemMessage);

			if (model.isMe(message.from)) {
				//do nothing
			} else {
				if(communicator.unreadCount == 0){
					conversations.unreadCount++;
				}
				communicator.unreadCount++;
			}
			conversations.push(itemMessage);
		}

		private function handleThread(message:Message, communicator:ICommunicator):void {
			if(communicator is IWritableCommunicator){
				var writable:IWritableCommunicator = communicator as IWritableCommunicator;
				if(message.thread != null && writable.thread != message.thread){
					writable.thread = message.thread
				}
			}
		}

		private function handleReceipt(message:Message, communicator:ICommunicator):void {
			if (message.receipt == Message.RECEIPT_RECEIVED) { //It's ack ackMessage
				var receiptMessageItem:CItemMessage = model.receiptRequests[message.receiptId];
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
}
