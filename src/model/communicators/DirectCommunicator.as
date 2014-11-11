/**
 * Created by kvint on 02.11.14.
 */
package model.communicators {
	import events.CommunicatorEvent;

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
		_label = _participant.node;
	}
	override public function get type():int {
		return CommunicatorType.DIRECT;
	}

	public function sendMessage(message:ChatMessage):void {
		dispatchEvent(new CommunicatorEvent(CommunicatorEvent.ITEM_SENT, message));
	}
	override public function markAsRead(ackMessage:ChatMessage):Boolean {
		var messageMarked:Boolean = super.markAsRead(ackMessage);
		if(messageMarked){
			unreadCount--;
		}
		return messageMarked;
	}

	override public function add(data:Object):void {
		if(data is Message){
			var message:Message = (data as Message);
			if(message.receipt){
				unreadCount++;
			}
		}
		super.add(data);
	}

	public function get participant():UnescapedJID {
		return _participant;
	}
	}
}
