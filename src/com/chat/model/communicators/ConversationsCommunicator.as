/**
 * Created by kvint on 02.12.14.
 */
package com.chat.model.communicators {
	import com.chat.events.CommunicatorEvent;
	import com.chat.events.CommunicatorFactoryEvent;
	import com.chat.model.data.citems.CItemConversation;
	import com.chat.model.data.citems.ICItem;
	import com.chat.model.data.citems.CItemMessage;
	import com.chat.model.history.IHistoryProvider;

	import org.igniterealtime.xiff.core.AbstractJID;
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.Message;

	public class ConversationsCommunicator extends DefaultCommunicator implements IConversationsCommunicator {

		[PostConstruct]
		private function init():void {
			communicators.addEventListener(CommunicatorFactoryEvent.COMMUNICATOR_ADDED, communicator_handler);
			communicators.addEventListener(CommunicatorFactoryEvent.COMMUNICATOR_DESTROYED, communicator_handler);
		}

		private function communicator_handler(event:CommunicatorFactoryEvent):void {
			var iCommunicator:ICommunicator = event.data as ICommunicator;
			switch (event.type){
				case CommunicatorFactoryEvent.COMMUNICATOR_ADDED:

					break;
				case CommunicatorFactoryEvent.COMMUNICATOR_DESTROYED:

					break;
			}
		}

		public function push(data:ICItem):void {

			if(data is CItemConversation){
				updateArrayWithConversation(data as CItemConversation);
				return;
			}
			var itemMessage:CItemMessage = data as CItemMessage;
			var from:EscapedJID = getParticipant(itemMessage.messageData);
			var conversation:CItemConversation;
			for (var i:int = 0; i < _items.length; i++) {
				conversation = _items.getItemAt(i) as CItemConversation;
				if(conversation.from.equals(from, true)){
					dispatchEvent(new CommunicatorEvent(CommunicatorEvent.ITEM_REMOVED, conversation));
					_items.remove(i);
					break;
				}

			}
			var newly:Boolean = false;
			if(conversation == null){
				var message:Message = itemMessage.messageData;
				var withJID:EscapedJID = getParticipant(message);
				conversation = new CItemConversation(withJID);
				newly = true;
			}
			conversation.lastMessage = itemMessage;
			_items.prepend(conversation);
			var eventName:String = newly ? CommunicatorEvent.ITEM_INSERTED : CommunicatorEvent.ITEM_UPDATED;
			dispatchEvent(new CommunicatorEvent(eventName, conversation));
			//updateUnreadCount();
		}

		private function updateArrayWithConversation(conversation:CItemConversation):void {
			var itemUpdated:Boolean = false;
			for(var i:int = 0; i < _items.length; i++) {
				var item:CItemConversation = _items.getItemAt(i) as CItemConversation;
				if(item == null) continue;
				if(item.from.equals(conversation.from, true)) {
					itemUpdated = true;
					dispatchEvent(new CommunicatorEvent(CommunicatorEvent.ITEM_REMOVED, item));
					_items.remove(i);
					break;
				}
			}
			_items.prepend(conversation);
			var eventName:String = itemUpdated ? CommunicatorEvent.ITEM_UPDATED : CommunicatorEvent.ITEM_INSERTED;
			dispatchEvent(new CommunicatorEvent(eventName, conversation));
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
			return null;
		}

		override public function destroy():void {
			communicators.removeEventListener(CommunicatorFactoryEvent.COMMUNICATOR_ADDED, communicator_handler);
			communicators.removeEventListener(CommunicatorFactoryEvent.COMMUNICATOR_DESTROYED, communicator_handler);
			super.destroy();
		}
	}
}
