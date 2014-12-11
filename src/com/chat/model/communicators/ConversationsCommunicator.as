/**
 * Created by kvint on 02.12.14.
 */
package com.chat.model.communicators {
	import com.chat.model.data.citems.ICConversation;
	import com.chat.model.history.IHistoryProvider;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.util.JIDUtil;

	public class ConversationsCommunicator extends DefaultCommunicator implements IConversationsCommunicator {

		public function updateWith(conversation:ICConversation):void {

			var fromJID:UnescapedJID = JIDUtil.unescape(conversation.withJID);
			for(var i:int = 0; i < _items.length; i++) {
				var item:ICConversation = _items.getItemAt(i) as ICConversation;
				if(item == null) continue;
				var withJID:UnescapedJID = JIDUtil.unescape(item.withJID);
				if(withJID.equals(fromJID, true)) {
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
