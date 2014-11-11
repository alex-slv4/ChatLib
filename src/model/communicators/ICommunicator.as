/**
 * Created by kvint on 02.11.14.
 */
package model.communicators {
	import flash.events.IEventDispatcher;

	import model.data.ChatMessage;

	[Event(name="onUnreadUpdated", type="events.CommunicatorEvent")]
	[Event(name="onItemAdded", type="events.CommunicatorEvent")]
	[Event(name="onItemUpdated", type="events.CommunicatorEvent")]
	[Event(name="onItemSent", type="events.CommunicatorEvent")]
	[Event(name="onItemRequested", type="events.CommunicatorEvent")]
	[Event(name="onReplaced", type="events.CommunicatorEvent")]

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
