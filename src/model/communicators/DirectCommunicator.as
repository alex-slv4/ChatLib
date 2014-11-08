/**
 * Created by kvint on 02.11.14.
 */
package model.communicators {
	import events.CommunicatorEvent;

	import model.ChatUser;
	import model.data.ChatMessage;

	import org.igniterealtime.xiff.core.UnescapedJID;

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
		super.markAsRead(ackMessage);
		if(!ackMessage.to.equals(_chatUser.jid.escaped, true)){
			unreadCount--;
		}
		return false;
	}

	override public function add(data:Object):void {
		var message:ChatMessage = data as ChatMessage;
		if(message.to.equals(_chatUser.jid.escaped, true)){
			unreadCount++;
		}
		super.add(data);
	}

	public function get participant():UnescapedJID {
		return _participant;
	}
	}
}
