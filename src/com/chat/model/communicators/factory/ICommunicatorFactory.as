/**
 * Created by kvint on 07.11.14.
 */
package com.chat.model.communicators.factory {
	import com.chat.model.communicators.*;
	import com.chat.model.data.collections.ICItemCollection;

	import flash.events.IEventDispatcher;

	public interface ICommunicatorFactory extends IEventDispatcher{

		function dispose(communicator:ICommunicator):void;

		function getFor(data:Object)				:ICommunicator;

		function get conversations():IConversationsCommunicator;
	}
}
