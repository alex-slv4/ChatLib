/**
 * Created by kvint on 02.11.14.
 */
package model.communicators {
	import flash.events.IEventDispatcher;

	import model.data.ChatMessage;

	[Event(name="userRemoved", type="org.igniterealtime.xiff.events.RosterEvent")]

	public interface ICommunicator extends IEventDispatcher{

		function get type():int;
		function get label():String;
		function get history():Array;
		function get unreadCount():int;
		function markAsRead(message:ChatMessage):Boolean;
		function add(data:Object):void;

	}
}
