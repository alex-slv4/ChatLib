/**
 * Created by kvint on 07.11.14.
 */
package com.chat.model.communicators {
	public interface ICommunicatorProvider {

		function getCommunicator(data:Object)				:ICommunicator;

		function getAll()									:Vector.<ICommunicator>;
	}
}
