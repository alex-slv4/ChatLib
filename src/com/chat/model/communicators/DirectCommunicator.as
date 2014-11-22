/**
 * Created by kvint on 02.11.14.
 */
package com.chat.model.communicators {
	import com.chat.events.CommunicatorCommandEvent;
	import com.chat.model.ChatUser;
	import com.chat.model.history.HistoryProvider;
	import com.chat.model.history.IHistoryProvider;
	import com.chat.model.data.ICItem;
	import com.chat.model.data.СItemMessage;

	import org.igniterealtime.xiff.core.UnescapedJID;

	public class DirectCommunicator extends WritableCommunicator implements ICommunicator {

		private var _chatUser:ChatUser;
		private var _participant:UnescapedJID;
		private var _history:HistoryProvider;

		public function DirectCommunicator(to:UnescapedJID, currentUser:ChatUser) {
			_participant = to;
			_chatUser = currentUser;
		}

		public function get type():int {
			return CommunicatorType.DIRECT;
		}

		override public function send(data:Object):int {
			var result:int = super.send(data);
			if (result == SUCCESS) {
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


		public function get name():String {
			return _participant.node;
		}


		override public function toString():String {
			return "[Direct " + _chatUser.jid.toString() + " / " + _participant + "]";
		}

		public function get history():IHistoryProvider {
			return _history ||= new HistoryProvider(this);
		}
		override public function destroy():void {
			_participant = null;
			_chatUser = null;
			super.destroy();
		}
	}
}
