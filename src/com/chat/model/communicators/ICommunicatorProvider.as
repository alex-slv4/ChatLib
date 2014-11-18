/**
 * Created by kvint on 07.11.14.
 */
package com.chat.model.communicators {
	public interface ICommunicatorProvider {

		function destroyCommunicator(communicator:UIDCommunicator):void;

		function getCommunicator(data:Object)				:UIDCommunicator;

		function getAll()									:Vector.<ICommunicator>;
	}
}
