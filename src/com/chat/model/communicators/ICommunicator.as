/**
 * Created by kvint on 02.11.14.
 */
package com.chat.model.communicators {
import com.chat.model.data.ChatMessage;

import flash.events.IEventDispatcher;

[Event(name="onUnreadUpdated", type="com.chat.events.CommunicatorEvent")]
	[Event(name="onItemAdded", type="com.chat.events.CommunicatorEvent")]
	[Event(name="onItemUpdated", type="com.chat.events.CommunicatorEvent")]
	[Event(name="onItemSent", type="com.chat.events.CommunicatorEvent")]
	[Event(name="onItemRequested", type="com.chat.events.CommunicatorEvent")]
	[Event(name="onReplaced", type="com.chat.events.CommunicatorEvent")]

	public interface ICommunicator extends IEventDispatcher {

		function get type():int;

		function get label():String;

		function get history():Array;

		function set unreadCount(value:int):void;

		function get unreadCount():int;

		function markAsRead(ackMessage:ChatMessage):Boolean;

		function add(data:Object):void;

		function clear():void;

		function destroy():void;
	}
}
