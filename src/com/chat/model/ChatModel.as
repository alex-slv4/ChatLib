/**
 * Created by kvint on 01.11.14.
 */
package com.chat.model {
import com.chat.model.communicators.ICommunicator;
import com.chat.model.communicators.ICommunicatorProvider;

import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import org.igniterealtime.xiff.im.Roster;

	[Event(name="onCommunicatorAdded", type="com.chat.events.ChatModelEvent")]
	[Event(name="onCommunicatorRemoved", type="com.chat.events.ChatModelEvent")]
	[Event(name="onCommunicatorActivated", type="com.chat.events.ChatModelEvent")]

	public class ChatModel extends EventDispatcher {

		[Inject]
		public var provider:ICommunicatorProvider;

		private var _currentUser:ChatUser;
		private var _roster:Roster;
		public var receiptRequests:Dictionary = new Dictionary();
		private var _activeCommunicator:ICommunicator;

		[PostConstruct]
		public function init():void {
			provider.chatModel = this;
		}

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

		public function get activeCommunicator():ICommunicator {
			return _activeCommunicator;
		}

		public function set activeCommunicator(value:ICommunicator):void {
			_activeCommunicator = value;
		}
	}
}
