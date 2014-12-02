/**
 * Created by kvint on 02.12.14.
 */
package com.chat.model.communicators {
	import com.chat.events.CommunicatorEvent;
	import com.chat.events.CommunicatorFactoryEvent;
	import com.chat.model.data.CItemConversation;
	import com.chat.model.data.ICItem;
	import com.chat.model.data.CItemMessage;
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

		override public function push(data:ICItem):void {
			var itemMessage:CItemMessage = data as CItemMessage;
			var from:EscapedJID = getParticipant(itemMessage.messageData);
			var conversation:CItemConversation;
			for (var i:int = 0; i < _items.length; i++) {
				conversation = _items[i] as CItemConversation;
				if(conversation.from.equals(from, false)){
					dispatchEvent(new CommunicatorEvent(CommunicatorEvent.ITEM_REMOVED, itemMessage));
					_items.splice(i, 1);
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
			_items.unshift(conversation);
			var eventName:String = newly ? CommunicatorEvent.ITEM_ADDED : CommunicatorEvent.ITEM_UPDATED;
			dispatchEvent(new CommunicatorEvent(eventName, conversation));
		}

		private function getParticipant(message:Message):EscapedJID {
			return model.isMe(message.from) ? message.to : message.from;
		}

		public function updateUnreadCount():void {
			var count:int = 0;

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
