/**
 * Created by kvint on 01.11.14.
 */
package com.chat.model {
import com.chat.model.communicators.ICommunicatorBase;
import com.chat.model.communicators.ICommunicatorProvider;

import flash.events.EventDispatcher;
import flash.utils.Dictionary;

	import org.igniterealtime.xiff.data.time.Time;

	import org.igniterealtime.xiff.im.Roster;

	import robotlegs.bender.framework.api.IInjector;

	[Event(name="onCommunicatorAdded", type="com.chat.events.ChatModelEvent")]
	[Event(name="onCommunicatorRemoved", type="com.chat.events.ChatModelEvent")]
	[Event(name="onCommunicatorActivated", type="com.chat.events.ChatModelEvent")]

	public class ChatModel extends EventDispatcher {

		[Inject]
		public var injector:IInjector;

		private var _currentUser:ChatUser;
		private var _roster:Roster;
		public var receiptRequests:Dictionary = new Dictionary();
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

		public function get provider():ICommunicatorProvider {
			return injector.getInstance(ICommunicatorProvider);
		}

		public function get serverTimeOffset():Number {
			return _serverTimeOffset;
		}

		public function set serverTimeOffset(value:Number):void {
			_serverTimeOffset = value;
		}
		public function get currentTime():Number {
			return new Date().time + serverTimeOffset;
		}
	}
}
