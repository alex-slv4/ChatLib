/**
 * Created by kvint on 02.11.14.
 */
package com.chat.model.communicators {
	import com.chat.model.data.citems.ICItem;
	import com.chat.model.data.collections.ICItemCollection;

	import flash.events.IEventDispatcher;

	public interface ICommunicatorBase extends IEventDispatcher {

		function get items():ICItemCollection;

		function read(data:ICItem):void;

		function clear():void;

		function destroy():void;

		function toString():String;
	}

}
