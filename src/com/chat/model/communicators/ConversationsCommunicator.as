/**
 * Created by kvint on 02.12.14.
 */
package com.chat.model.communicators {
	import com.chat.model.data.citems.CConversation;
	import com.chat.model.data.citems.CMessage;
	import com.chat.model.data.citems.ICItem;
	import com.chat.model.history.IHistoryProvider;

	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.Message;

	public class ConversationsCommunicator extends DefaultCommunicator implements IConversationsCommunicator {

		public function updateWith(data:ICItem):void {

			if(data is CConversation){
				updateWithConversation(data as CConversation);
			}else if(data is CMessage){
				updateWithMessage(data as CMessage);
			}
		}

		private function updateWithMessage(itemMessage:CMessage):void {
			var from:EscapedJID = getParticipant(itemMessage.data);
			var conversation:CConversation;
			for(var i:int = 0; i < _items.length; i++) {
				conversation = _items.getItemAt(i) as CConversation;
				if(conversation.from.equals(from, true)) {
					_items.remove(i);
					break;
				}

			}
			if(conversation == null) {
				var message:Message = itemMessage.data;
				var withJID:EscapedJID = getParticipant(message);
				conversation = new CConversation(withJID);
			}
			conversation.lastMessage = itemMessage;
			_items.prepend(conversation);
			_items.touch(conversation);
		}

		private function updateWithConversation(conversation:CConversation):void {
			for(var i:int = 0; i < _items.length; i++) {
				var item:CConversation = _items.getItemAt(i) as CConversation;
				if(item == null) continue;
				if(item.from.equals(conversation.from, true)) {
					if(conversation.time >= item.time && conversation.lastMessage != null){
						_items.setItemAt(conversation, i);
					}
					return;
				}
				if(conversation.time >= item.time){
					_items.insert(i, conversation);
					return;
				}
			}
			_items.append(conversation);
		}
		private function getParticipant(message:Message):EscapedJID {
			return model.isMe(message.from) ? message.to : message.from;
		}

		public function updateUnreadCount():void {
			var count:int = Math.round(Math.random() * 100);

			this.unreadCount = count;
		}


		public function get history():IHistoryProvider {
			return null;
		}

		public function get type():int {
			return -1;
		}

		public function get name():String {
			return "Conversations";
		}

	}
}
