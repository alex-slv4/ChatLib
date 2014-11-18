/**
 * Created by kvint on 02.11.14.
 */
package com.chat.model.communicators {
	import com.chat.model.data.ICItem;

	import flash.events.IEventDispatcher;

	[Event(name="onUnreadUpdated", type="com.chat.events.CommunicatorEvent")]
	[Event(name="onItemAdded", type="com.chat.events.CommunicatorEvent")]
	[Event(name="onItemUpdated", type="com.chat.events.CommunicatorEvent")]
	[Event(name="onItemSent", type="com.chat.events.CommunicatorEvent")]
	[Event(name="onItemRequested", type="com.chat.events.CommunicatorEvent")]
	[Event(name="onChanged", type="com.chat.events.CommunicatorEvent")]

	public interface ICommunicator extends IEventDispatcher {

		function set unreadCount(value:int):void;

		function get unreadCount():int;

		function set active(value:Boolean):void;

		function get active():Boolean;

		function get items():Vector.<ICItem>;

		function read(data:ICItem):void;

		function push(data:ICItem):void;

		function clear():void;

		function destroy():void;

	}

}
