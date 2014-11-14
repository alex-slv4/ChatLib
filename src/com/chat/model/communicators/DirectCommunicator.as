/**
 * Created by kvint on 02.11.14.
 */
package com.chat.model.communicators {
	import com.chat.events.CommunicatorCommandEvent;
	import com.chat.events.CommunicatorEvent;
	import com.chat.model.ChatUser;
	import com.chat.model.data.ChatMessage;
	import com.chat.model.data.ICItem;
	import com.chat.model.data.MessageItem;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.Message;

	public class DirectCommunicator extends WritableCommunicator {

		private var _chatUser:ChatUser;
		private var _participant:UnescapedJID;

		public function DirectCommunicator(to:UnescapedJID, currentUser:ChatUser) {
			_participant = to;
			_chatUser = currentUser;
			_label = _participant.node;
		}

		override public function get type():int {
			return CommunicatorType.DIRECT;
		}

		override public function markAsRead(ackMessage:ICItem):Boolean {
			var messageMarked:Boolean = super.markAsRead(ackMessage);
			if(messageMarked) {
				unreadCount--;
			}
			return messageMarked;
		}

		override public function send(data:Object):int {
			var result:int = super.send(data);
			/*if(data is Message) {
				var message:Message = (data as Message);
				if(message.receipt) {
					unreadCount++;
				}
			}*/
			if(result == SUCCESS){
				dispatch(CommunicatorCommandEvent.PRIVATE_MESSAGE, [data]);
			}
			return result;
		}

		public function get participant():UnescapedJID {
			return _participant;
		}

		public function get chatUser():ChatUser {
			return _chatUser;
		}

	}
}
