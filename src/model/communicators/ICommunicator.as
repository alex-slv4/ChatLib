/**
 * Created by kvint on 02.11.14.
 */
package model.communicators {
	import controller.ChatController;

	import flash.events.IEventDispatcher;

	import model.data.ChatMessage;

	[Event(name="onUnreadUpdated", type="events.CommunicatorEvent")]
	[Event(name="onItemAdded", type="events.CommunicatorEvent")]
	[Event(name="onItemUpdated", type="events.CommunicatorEvent")]
	[Event(name="onItemSent", type="events.CommunicatorEvent")]

	public interface ICommunicator extends IEventDispatcher {

		function get type():int;

		function get label():String;

		function get history():Array;

		function set unreadCount(value:int):void;

		function get unreadCount():int;

		function get chatController():ChatController;

		function markAsRead(ackMessage:ChatMessage):Boolean;

		function add(data:Object):void;

		function activate():void;
	}
}
