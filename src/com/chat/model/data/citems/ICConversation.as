/**
 * Created by AlexanderSla on 11.12.2014.
 */
package com.chat.model.data.citems {
	import com.chat.model.communicators.ICommunicator;

	import flash.events.IEventDispatcher;

	import org.igniterealtime.xiff.core.AbstractJID;

	public interface ICConversation extends ICTime, IEventDispatcher {

		function get communicator():ICommunicator;

		function get withJID():AbstractJID;

		function get last():ICItem;

		function set originTime(value:Number):void;

		function get originTime():Number;

		function destroy():void;
	}
}
