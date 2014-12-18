/**
 * Created by kvint on 19.11.14.
 */
package com.chat.model.communicators.factory.communicators {
	import com.chat.model.ChatRoom;
	import com.chat.model.communicators.ICommunicator;
	import com.chat.model.communicators.RoomCommunicator;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.Message;

	import robotlegs.bender.framework.api.IInjector;

	public class MessageCreator extends DefaultCommunicatorCreator{

		[Inject]
		public var injector:IInjector;

		private var _msg:Message;

		public function MessageCreator(msg:Message, uid:String) {
			super (msg, uid);
			_msg = msg;
		}

		override public function create():ICommunicator {
			switch (_msg.type){
				case Message.TYPE_GROUPCHAT:
					return createRoom();
			}
			return super.create();
		}

		private function createRoom():ICommunicator {
			var chatRoom:ChatRoom = new ChatRoom();
			injector.injectInto(chatRoom);
			var roomJID:UnescapedJID = new UnescapedJID(from.bareJID);
			chatRoom.join(roomJID);
			return new RoomCommunicator(chatRoom)
		}

		public function get from():UnescapedJID {
			return new UnescapedJID(uid);
		}
	}
}
