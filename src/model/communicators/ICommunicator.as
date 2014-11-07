/**
 * Created by kvint on 02.11.14.
 */
package model.communicators {
	import flash.events.IEventDispatcher;

	import model.data.ChatMessage;

	//TODO: add events
	public interface ICommunicator extends IEventDispatcher{

		function get type():int;
		function get label():String;
		function get history():Array;
		function set unreadCount(value:int):void;
		function get unreadCount():int;
		function markAsRead(ackMessage:ChatMessage):Boolean;
		function add(data:Object):void;

	}
}
