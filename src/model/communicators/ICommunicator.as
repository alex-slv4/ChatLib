/**
 * Created by kvint on 02.11.14.
 */
package model.communicators {
	import flash.events.IEventDispatcher;

	import org.igniterealtime.xiff.data.Message;

	public interface ICommunicator extends IEventDispatcher{

		function get type():int;
		function get label():String;
		function get history():Array;
		function markAsRead(message:Message):Boolean;
		function add(data:Object):void;

	}
}
