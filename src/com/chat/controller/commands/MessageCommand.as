/**
 * Created by kvint on 16.11.14.
 */
package com.chat.controller.commands {
	import com.chat.model.activity.IActivitiesHandler;
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.communicators.ICommunicator;
	import com.chat.model.communicators.IWritableCommunicator;
	import com.chat.model.communicators.RoomCommunicator;
	import com.chat.model.communicators.factory.ICommunicatorFactory;
	import com.chat.model.data.citems.CMessage;

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
				trace("ChatLib: Message without type not handled");
				return;
			}

			activities.handleActivity(message);

			var communicator:ICommunicator = communicators.getFor(message) as ICommunicator;

			handleReceipt(message, communicator);
			handleThread(message, communicator);

			if(message.body == null){
				trace("ChatLib: Message without body not handled");
				return;
			}

			var itemMessage:CMessage = new CMessage(message);

			calculateUnreadCount(communicator, itemMessage);

			communicator.items.append(itemMessage);
		}

		private function calculateUnreadCount(communicator:ICommunicator, itemMessage:CMessage):void {
			var message:Message = itemMessage.messageData;
			var inRoom:Boolean = (communicator is RoomCommunicator);
			var isOfflineRoomMessage:Boolean = inRoom && message.delayedDelivery != null;
			if(isOfflineRoomMessage) {
				itemMessage.isRead = true;
			}

			if(model.isMe(message.from)) {
				itemMessage.isRead = inRoom;
			} else {
				if(communicator.unreadCount == 0 && !inRoom) {
					model.conversations.unreadCount++;
				}
			}
			if(!itemMessage.isRead) {
				communicator.unreadCount++;
			}
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
				var receiptMessageItem:CMessage = model.receiptRequests[message.receiptId];
				if (receiptMessageItem) {
					delete model.receiptRequests[message.receiptId];
					var msg:Message = receiptMessageItem.messageData;
					receiptMessageItem.isRead = true;
					msg.receipt = null;
					communicator.items.touch(receiptMessageItem);
				}
			}
		}
	}
}
