/**
 * Created by kvint on 19.11.14.
 */
package com.chat.model.communicators.factory {
	import com.chat.model.ChatRoom;
	import com.chat.model.IChatModel;
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.communicators.ICommunicator;
	import com.chat.model.communicators.RoomCommunicator;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.Message;

	import robotlegs.bender.framework.api.IInjector;

	public class MessageCreator implements ICreator {

		[Inject]
		public var model:IChatModel;

		[Inject]
		public var injector:IInjector;

		private var _msg:Message;

		public function MessageCreator(msg:Message) {
			_msg = msg;
		}

		public function get uid():String {
			return from ? from.bareJID.toString() : null;
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
			injector.injectInto(chatRoom);
			chatRoom.join(from);
			return new RoomCommunicator(chatRoom)
		}

		private function createDirect():ICommunicator {
			return new DirectCommunicator(from, model.currentUser);
		}

		public function get from():UnescapedJID {
			if(_msg == null) return null;
			if(_msg.from == null) return null;
			if(_msg.to == null) return null;
			var isCurrentUserMessage:Boolean = model.isMe(_msg.from);
			return isCurrentUserMessage ? _msg.to.unescaped : _msg.from.unescaped;
		}
	}
}
