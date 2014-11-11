/**
 * Created by kvint on 02.11.14.
 */
package model.communicators {
	import events.CommunicatorEvent;

	import flash.events.EventDispatcher;

	import model.data.ChatMessage;

	public class DefaultCommunicator extends EventDispatcher implements ICommunicator {

		protected var _label:String;
		private var _count:int = 0;
		private var _history:Array = [];

		public function DefaultCommunicator() {
		}

		public function get type():int {
			return -1;
		}
		public function get label():String {
			return _label ? _label : toString();
		}

		public function add(data:Object):void {
			_history.push(data);
			dispatchEvent(new CommunicatorEvent(CommunicatorEvent.ITEM_ADDED, data));
		}

		public function markAsRead(ackMessage:ChatMessage):Boolean {
			if(ackMessage.receipt){
				dispatchEvent(new CommunicatorEvent(CommunicatorEvent.ITEM_RECEIPT_REPLIED, ackMessage));
				return true;
			}
			return false;
		}

		public function set unreadCount(value:int):void {
			_count = value;
			dispatchEvent(new CommunicatorEvent(CommunicatorEvent.UNREAD_UPDATED, _count));
		}

		public function get unreadCount():int {
			return _count;
		}

		public function get history():Array {
			return _history;
		}

		public function clear():void {
			_history = [];
			_count = 0;
			dispatchEvent(new CommunicatorEvent(CommunicatorEvent.REPLACED, this));
		}

		override public function toString():String {
			return "[DefaultCommunicator]";
		}
	}
}
