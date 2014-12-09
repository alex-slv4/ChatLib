/**
 * Created by kvint on 02.12.14.
 */
package com.chat.model.communicators {
	import com.chat.model.data.citems.CItemConversation;
	import com.chat.model.data.citems.CItemMessage;
	import com.chat.model.data.citems.ICItem;
	import com.chat.model.history.IHistoryProvider;

	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.Message;

	public class ConversationsCommunicator extends DefaultCommunicator implements IConversationsCommunicator {

		public function updateWith(data:ICItem):void {

			if(data is CItemConversation){
				updateWithConversation(data as CItemConversation);
			}else if(data is CItemMessage){
				updateWithMessage(data as CItemMessage);
			}
		}

		private function updateWithMessage(itemMessage:CItemMessage):void {
			var from:EscapedJID = getParticipant(itemMessage.messageData);
			var conversation:CItemConversation;
			for(var i:int = 0; i < _items.length; i++) {
				conversation = _items.getItemAt(i) as CItemConversation;
				if(conversation.from.equals(from, true)) {
					_items.remove(i);
					break;
				}

			}
			if(conversation == null) {
				var message:Message = itemMessage.messageData;
				var withJID:EscapedJID = getParticipant(message);
				conversation = new CItemConversation(withJID);
			}
			conversation.lastMessage = itemMessage;
			_items.prepend(conversation);
			_items.touch(conversation);
		}

		private function updateWithConversation(conversation:CItemConversation):void {
			for(var i:int = 0; i < _items.length; i++) {
				var item:CItemConversation = _items.getItemAt(i) as CItemConversation;
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
