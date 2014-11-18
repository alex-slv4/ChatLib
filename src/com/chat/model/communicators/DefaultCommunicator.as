/**
 * Created by kvint on 02.11.14.
 */
package com.chat.model.communicators {
	import com.chat.controller.ChatController;
	import com.chat.events.CommunicatorCommandEvent;
	import com.chat.events.CommunicatorEvent;
	import com.chat.model.ChatModel;
	import com.chat.model.data.ICItem;
	import com.chat.model.data.СItemMessage;

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class DefaultCommunicator extends EventDispatcher implements ICommunicator {

		[Inject]
		public var model:ChatModel;

		[Inject]
		public var controller:ChatController;

		[Inject]
		public var bus:IEventDispatcher;


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
			return super.toString();
		}

		public function push(data:ICItem):void {
			_items.push(data);
			var messageItem:СItemMessage = data as СItemMessage;
			if(messageItem){
				dispatch(CommunicatorCommandEvent.ON_MESSAGE_RECEIVED, [messageItem]);
			}
			dispatchEvent(new CommunicatorEvent(CommunicatorEvent.ITEM_ADDED, data));
		}

		public function read(data:ICItem):void {
			var messageItem:СItemMessage = data as СItemMessage;
			if(messageItem){
				dispatch(CommunicatorCommandEvent.MARK_AS_RECEIVED, [messageItem]);
			}
		}
		public function dispatch(eventName:String, params:Array):void {
			bus.dispatchEvent(new CommunicatorCommandEvent(eventName, this, params));
		}
		public function destroy():void {
		}
	}
}
