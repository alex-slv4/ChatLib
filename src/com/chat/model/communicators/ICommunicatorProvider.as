/**
 * Created by kvint on 07.11.14.
 */
package com.chat.model.communicators {
	public interface ICommunicatorProvider {

		function dispose(communicator:ICommunicator):void;

		function getFor(data:Object)				:ICommunicator;

		function getAll()									:Vector.<ICommunicator>;
	}
}
