/**
 * Created by kvint on 02.11.14.
 */
package com.chat.model.communicators {
	import com.chat.controller.ChatController;
	import com.chat.events.CommunicatorEvent;
	import com.chat.model.ChatModel;
	import com.chat.model.data.ICItem;

	import flash.events.EventDispatcher;

	public class DefaultCommunicator extends EventDispatcher implements ICommunicator {

		[Inject]
		public var model:ChatModel;

		[Inject]
		public var controller:ChatController;

		protected var _label:String;
		private var _count:int = 0;
		protected var _items:Vector.<ICItem> = new <ICItem>[];

		public function DefaultCommunicator() {
		}

		public function get type():int {
			return -1;
		}
		public function get label():String {
			return _label ? _label : toString();
		}

		public function markAsRead(ackMessage:ICItem):Boolean {
			/*if(ackMessage.receipt){
				dispatchEvent(new CommunicatorEvent(CommunicatorEvent.ITEM_RECEIPT_REPLIED, ackMessage));
				return true;
			}*/
			return false;
		}

		public function set unreadCount(value:int):void {
			_count = value;
			dispatchEvent(new CommunicatorEvent(CommunicatorEvent.UNREAD_UPDATED, _count));
		}

		public function get unreadCount():int {
			return _count;
		}

		public function get items():Vector.<ICItem> {
			return _items;
		}

		public function clear():void {
			_items = new <ICItem>[];
			_count = 0;
			dispatchEvent(new CommunicatorEvent(CommunicatorEvent.REPLACED, this));
		}

		override public function toString():String {
			return "[DefaultCommunicator]";
		}

		public function push(data:ICItem):void {
			_items.push(data);
			dispatchEvent(new CommunicatorEvent(CommunicatorEvent.ITEM_ADDED, data));
		}

		public function destroy():void {

		}
	}
}
