/**
 * Created by AlexanderSla on 21.11.2014.
 */
package com.chat.model {
	import com.chat.model.communicators.factory.ICommunicatorFactory;
	import com.chat.model.presences.IPresences;

	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import org.igniterealtime.xiff.im.Roster;

	public interface IChatModel extends IEventDispatcher {

		function get currentUser():ChatUser;
		function set currentUser(value:ChatUser):void;

		function get roster():Roster;
		function set roster(value:Roster):void;

		function get serverTimeOffset():int;
		function set serverTimeOffset(value:int):void;

		function get communicators():ICommunicatorFactory;
		function get presences():IPresences;

		function get receiptRequests():Dictionary;
	}
}
