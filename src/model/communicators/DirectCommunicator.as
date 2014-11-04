/**
 * Created by kvint on 02.11.14.
 */
package model.communicators {
	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.Message;

	public class DirectCommunicator extends DefaultCommunicator {

		private var _user:UnescapedJID;

		public function DirectCommunicator(user:UnescapedJID) {
			_user = user;
			_label = user.node;
		}
		override public function get type():int {
			return CommunicatorTypes.DIRECT;
		}

		override public function markAsRead(ackMessage:Message):Boolean {
			var markedMessage:Message;
			for each (var message:Message in history) {
				if(message.id == ackMessage.receiptId){
					markedMessage = message;
					break;
				}
			}
			if(markedMessage) markedMessage.receipt = null;
			return markedMessage != null;
		}

		public function get user():UnescapedJID {
			return _user;
		}
	}
}
