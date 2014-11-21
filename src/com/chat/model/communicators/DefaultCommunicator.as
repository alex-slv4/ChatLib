/**
 * Created by kvint on 02.11.14.
 */
package com.chat.model.communicators {
	import com.chat.controller.ChatController;
	import com.chat.events.CommunicatorFactoryEvent;
	import com.chat.events.CommunicatorCommandEvent;
	import com.chat.events.CommunicatorEvent;
	import com.chat.model.ChatModel;
	import com.chat.model.IChatModel;
	import com.chat.model.communicators.factory.ICommunicatorFactory;
	import com.chat.model.data.ICItem;
	import com.chat.model.data.СItemMessage;

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

import org.as3commons.lang.Assert;

	public class DefaultCommunicator extends EventDispatcher implements ICommunicatorBase {

		[Inject]
		public var model:IChatModel;

		[Inject]
		public var controller:ChatController;

		[Inject]
		public var communicators:ICommunicatorFactory;

		[Inject]
		public var bus:IEventDispatcher;


		private var _uid:String;
		private var _count:int = 0;
		protected var _items:Vector.<ICItem> = new <ICItem>[];
		private var _active:Boolean;

		public function DefaultCommunicator() {
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
			dispatchEvent(new CommunicatorEvent(CommunicatorEvent.CHANGED, this));
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
		public function get active():Boolean {
			return _active;
		}

		public function set active(value:Boolean):void {
			if(value != _active){
				_active = value;
				var eventName:String = _active ? CommunicatorFactoryEvent.COMMUNICATOR_ACTIVATED : CommunicatorFactoryEvent.COMMUNICATOR_DEACTIVATED;
				communicators.dispatchEvent(new CommunicatorFactoryEvent(eventName, this));
			}
		}
		public function get uid():String {
			return _uid;
		}

		public function set uid(value:String):void {
			_uid = value;
		}

		public function destroy():void {
			active = false;
			clear();
			bus = null;
			model = null;
			controller = null;
			_uid = null;
			_items = null;
		}
	}
}
