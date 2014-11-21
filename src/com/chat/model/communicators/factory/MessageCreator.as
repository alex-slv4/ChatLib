/**
 * Created by kvint on 19.11.14.
 */
package com.chat.model.communicators.factory {
	import com.chat.model.ChatModel;
	import com.chat.model.ChatRoom;
	import com.chat.model.IChatModel;
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.communicators.ICommunicator;
	import com.chat.model.communicators.RoomCommunicator;

	import org.igniterealtime.xiff.core.UnescapedJID;

	import org.igniterealtime.xiff.data.Message;

	public class MessageCreator implements ICreator {

		[Inject]
		public var model:IChatModel;

		private var _msg:Message;

		public function MessageCreator(msg:Message) {
			_msg = msg;
		}

		public function get uid():String {
			return from ? from.toString() : null;
		}

		public function create():ICommunicator {
			switch (_msg.type){
				case Message.TYPE_CHAT:
					return createDirect();
				case Message.TYPE_GROUPCHAT:
					return createRoom();
			}
			return null;
		}

		private function createRoom():ICommunicator {
			var chatRoom:ChatRoom = new ChatRoom();
			chatRoom.join(from);
			return new RoomCommunicator(chatRoom)
		}

		private function createDirect():ICommunicator {
			return new DirectCommunicator(from, model.currentUser);
		}

		public function get from():UnescapedJID {
			if(_msg == null) return null;
			if(_msg.from == null) return null;
			var isCurrentUserMessage:Boolean = _msg.from.equals(model.currentUser.jid.escaped, true);
			return isCurrentUserMessage ? _msg.to.unescaped : _msg.from.unescaped;
		}
	}
}
