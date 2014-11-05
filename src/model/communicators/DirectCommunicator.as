/**
 * Created by kvint on 02.11.14.
 */
package model.communicators {
	import model.ChatModel;
	import model.ChatUser;
	import model.data.ChatMessage;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.Message;

	public class DirectCommunicator extends DefaultCommunicator {

		private var _chatUser:ChatUser;
		private var _participant:UnescapedJID;
		private var _count:int = 0;

		public function DirectCommunicator(participant:UnescapedJID, currentUser:ChatUser) {
			_participant = participant;
			_chatUser = currentUser;
			_label = participant.node;
		}
		override public function get type():int {
			return CommunicatorTypes.DIRECT;
		}

		override public function markAsRead(ackMessage:ChatMessage):Boolean {
			var markedMessage:Message;
			for (var i:int = 0; i < history.length; i++) {
				var message:Message = history[i];
				if(message.id == ackMessage.receiptId){
					markedMessage = message;
					_count--;
					break;
				}
			}
			return markedMessage != null;
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
