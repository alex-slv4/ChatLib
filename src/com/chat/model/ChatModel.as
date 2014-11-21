/**
 * Created by kvint on 01.11.14.
 */
package com.chat.model {
	import com.chat.model.communicators.factory.ICommunicatorFactory;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	import org.igniterealtime.xiff.im.Roster;

	import robotlegs.bender.framework.api.IInjector;

	public class ChatModel extends EventDispatcher implements IChatModel {

		[Inject]
		public var injector:IInjector;

		[Inject]
		public var _communicators:ICommunicatorFactory;

		private var _currentUser:ChatUser;
		private var _roster:Roster;
		private var _receiptRequests:Dictionary = new Dictionary();
		private var _serverTimeOffset:Number;

		public function get currentUser():ChatUser {
			return _currentUser;
		}

		public function set currentUser(value:ChatUser):void {
			_currentUser = value;
		}

		public function get roster():Roster {
			return _roster;
		}

		public function set roster(value:Roster):void {
			_roster = value;
		}

		public function get serverTimeOffset():int {
			return _serverTimeOffset;
		}

		public function set serverTimeOffset(value:int):void {
			_serverTimeOffset = value;
		}
		public function get currentTime():Number {
			return new Date().time + serverTimeOffset;
		}

		public function get communicators():ICommunicatorFactory {
			return _communicators;
		}

		public function get receiptRequests():Dictionary {
			return _receiptRequests;
		}
	}
}
