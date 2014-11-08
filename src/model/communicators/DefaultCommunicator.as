/**
 * Created by kvint on 02.11.14.
 */
package model.communicators {
import controller.ChatController;

import events.CommunicatorEvent;

import flash.events.EventDispatcher;

import model.data.ChatMessage;

public class DefaultCommunicator extends EventDispatcher implements ICommunicator {

		protected var _label:String;
		protected var _count:int = 0;
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
			var markedMessage:ChatMessage;
			for (var i:int = 0; i < history.length; i++) {
				var message:ChatMessage = history[i];
				if(message.id == ackMessage.receiptId){
					markedMessage = message;
					break;
				}
			}
			if(markedMessage){
				chatController.markMessageAsReceived(markedMessage);
				return false;
			}
			return true;
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

		override public function toString():String {
			return "[DefaultCommunicator]";
		}

		public function activate():void {
			chatController.activateCommunicator(this);
		}

		public function get chatController():ChatController
		{
			return ChatClient.instance.controller;
		}
	}
}
