/**
 * Created by kvint on 19.11.14.
 */
package com.chat.model.communicators.factory {
	import com.chat.model.communicators.ICommunicator;

	import org.igniterealtime.xiff.data.Message;

	public class MessageCreator implements ICreator {

		private var _msg:Message;

		public function MessageCreator(msg:Message) {
			_msg = msg;
		}

		public function get key():String {
			var a:Array = [_msg.from.bareJID, _msg.to.bareJID].sort();
			return a.join("-")
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
			
		}

		private function createDirect():ICommunicator {
			
		}
	}
}
