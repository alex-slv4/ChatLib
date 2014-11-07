/**
 * Created by kvint on 02.11.14.
 */
package model.communicators {
	import controller.ChatController;

	import model.ChatUser;
	import model.data.ChatMessage;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.Message;

	public class DirectCommunicator extends DefaultCommunicator {

		private var _chatUser:ChatUser;
		private var _participant:UnescapedJID;

		public function DirectCommunicator(to:UnescapedJID, currentUser:ChatUser) {
			_participant = to;
			_chatUser = currentUser;
			_label = to.bareJID;
		}
		override public function get type():int {
			return CommunicatorType.DIRECT;
		}

		public function sendMessage(message:Message):void {
			controller.ChatController
		}
		override public function markAsRead(ackMessage:ChatMessage):Boolean {
			var messageMarked:Boolean = super.markAsRead(ackMessage);
			if(messageMarked){
				_count--;
			}
			return messageMarked;
		}

		override public function add(data:Object):void {
			var message:ChatMessage = data as ChatMessage;
			if(message.to.equals(_chatUser.jid.escaped, true)){
				_count++;
			}
			super.add(data);
		}

		public function get participant():UnescapedJID {
			return _participant;
		}
	}
}
