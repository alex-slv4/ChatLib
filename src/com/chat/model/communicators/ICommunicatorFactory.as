/**
 * Created by kvint on 07.11.14.
 */
package com.chat.model.communicators {
	import flash.events.IEventDispatcher;

	public interface ICommunicatorFactory extends IEventDispatcher{

		function dispose(communicator:ICommunicator):void;

		function getFor(data:Object)				:ICommunicator;

		function getAll()									:Vector.<ICommunicator>;
	}
}
