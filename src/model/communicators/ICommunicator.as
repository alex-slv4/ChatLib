/**
 * Created by kvint on 02.11.14.
 */
package model.communicators {
	import flash.events.IEventDispatcher;

	public interface ICommunicator extends IEventDispatcher{

		function get type():int;
		function get label():String;
		function get history():Array;
		function add(data:Object):void;

	}
}
