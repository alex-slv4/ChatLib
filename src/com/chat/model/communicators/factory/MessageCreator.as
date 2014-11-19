/**
 * Created by kvint on 19.11.14.
 */
package com.chat.model.communicators.factory {
	import com.chat.model.ChatModel;
	import com.chat.model.ChatRoom;
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.communicators.ICommunicator;
	import com.chat.model.communicators.RoomCommunicator;

	import org.igniterealtime.xiff.core.UnescapedJID;

	import org.igniterealtime.xiff.data.Message;

	public class MessageCreator implements ICreator {

		[Inject]
		public var model:ChatModel;

		private var _msg:Message;
		private var _from:UnescapedJID;

		public function MessageCreator(msg:Message) {
			_msg = msg;
			var isCurrentUserMessage:Boolean = _msg.from.equals(model.currentUser.jid.escaped, true);
			_from = isCurrentUserMessage ? _msg.to.unescaped : _msg.from.unescaped;
		}

		public function get uid():String {
			return _from ? _from.toString() : null;
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
			chatRoom.join(_from);
			return new RoomCommunicator(chatRoom)
		}

		private function createDirect():ICommunicator {
			return new DirectCommunicator(_from, model.currentUser);
		}
	}
}
