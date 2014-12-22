/**
 * Created by kvint on 02.12.14.
 */
package com.chat.model.communicators {
	import com.chat.model.data.citems.ICConversation;
	import com.chat.model.history.IHistoryProvider;

	public class ConversationsCommunicator extends DefaultCommunicator implements IConversationsCommunicator {

		public function updateWith(conversation:ICConversation):void {
			var idx:int = -1;
			for(var i:int = 0; i < _items.length; i++) {
				var item:ICConversation = _items.getItemAt(i) as ICConversation;
				if(item.communicator == conversation.communicator) {
					if(conversation.originTime >= item.originTime){
						item.originTime = conversation.originTime;
						_items.touch(i);
					}
					return;
				}
				if(conversation.originTime >= item.originTime){
					idx = i;
				}
			}
			if(idx != -1){
				_items.insert(idx, conversation);
			}else{
				_items.append(conversation);
			}
		}

		public function updateUnreadCount():void {
			var count:int = 0;
			for(var i:int = 0; i < _items.length; i++) {
				var item:ICConversation = _items.getItemAt(i) as ICConversation;
				var hasUnread:Boolean = item.communicator.unreadCount > 0;
				count += hasUnread ? 1 : 0;
			}
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

		public function fetchLasts():void {
			for(var i:int = 0; i < _items.length; i++) {
				var item:ICConversation = _items.getItemAt(i) as ICConversation;
				item.communicator.history.fetch();
			}
		}
	}
}
