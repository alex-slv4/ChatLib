/**
 * Created by AlexanderSla on 21.11.2014.
 */
package com.chat.model {
	import com.chat.model.activity.IActivities;
	import com.chat.model.communicators.factory.ICommunicatorFactory;
	import com.chat.model.presences.IPresences;

	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import org.igniterealtime.xiff.core.IXMPPConnection;
	import org.igniterealtime.xiff.im.IRoster;

	public interface IChatModel extends IEventDispatcher {

		function get currentUser():ChatUser;
		function set currentUser(value:ChatUser):void;

		function get roster():IRoster;
		function set roster(value:IRoster):void;

		function get serverTimeOffset():int;
		function set serverTimeOffset(value:int):void;

		function get communicators():ICommunicatorFactory;
		function get presences():IPresences;
		function get activities():IActivities;

		function get receiptRequests():Dictionary;

		function get connection():IXMPPConnection;
		function set connection(value:IXMPPConnection):void;

		function get conferenceServer():String;
	}
}
