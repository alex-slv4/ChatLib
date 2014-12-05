/**
 * Created by kvint on 02.11.14.
 */
package com.chat.model.communicators {
	import com.chat.model.data.citems.ICItem;
	import com.chat.model.data.collections.ICItemCollection;

	import flash.events.IEventDispatcher;

	[Event(name="onUnreadUpdated", type="com.chat.events.CommunicatorEvent")]
	[Event(name="onItemAdded", type="com.chat.events.CommunicatorEvent")]
	[Event(name="onItemUpdated", type="com.chat.events.CommunicatorEvent")]
	[Event(name="onItemSent", type="com.chat.events.CommunicatorEvent")]
	[Event(name="onItemRequested", type="com.chat.events.CommunicatorEvent")]
	[Event(name="onChanged", type="com.chat.events.CommunicatorEvent")]

	public interface ICommunicatorBase extends IEventDispatcher {

		function get items():ICItemCollection;

		function read(data:ICItem):void;

		function clear():void;

		function destroy():void;

		function toString():String;
	}

}
