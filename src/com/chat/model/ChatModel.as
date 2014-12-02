/**
 * Created by kvint on 01.11.14.
 */
package com.chat.model {
	import com.chat.model.activity.IActivities;
	import com.chat.model.communicators.IConversationsCommunicator;
	import com.chat.model.communicators.factory.ICommunicatorFactory;
	import com.chat.model.presences.IPresences;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	import org.igniterealtime.xiff.core.AbstractJID;
	import org.igniterealtime.xiff.core.IXMPPConnection;
	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.id.IIDGenerator;
	import org.igniterealtime.xiff.data.id.RandomGenerator;
	import org.igniterealtime.xiff.im.IRoster;
	import org.igniterealtime.xiff.util.JIDUtil;

	import robotlegs.bender.framework.api.IInjector;

	public class ChatModel extends EventDispatcher implements IChatModel {

		[Inject]
		public var injector:IInjector;

		private var _connection:IXMPPConnection;
		private var _conversations:IConversationsCommunicator;
		private var _currentUser:ChatUser;
		private var _roster:IRoster;
		private var _receiptRequests:Dictionary = new Dictionary();
		private var _serverTimeOffset:Number;
		private var _communicators:ICommunicatorFactory;
		private var _presences:IPresences;
		private var _activities:IActivities;
		private var _threadGenerator:IIDGenerator;

		public function get currentUser():ChatUser {
			return _currentUser;
		}

		public function set currentUser(value:ChatUser):void {
			_currentUser = value;
		}

		public function get roster():IRoster {
			return _roster;
		}

		public function set roster(value:IRoster):void {
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

		[Inject]
		public function set communicators(value:ICommunicatorFactory):void {
			_communicators = value;
		}
		[Inject]
		public function set presences(value:IPresences):void {
			_presences = value;
		}
		[Inject]
		public function set activities(value:IActivities):void {
			_activities = value;
		}
		public function get communicators():ICommunicatorFactory {
			return _communicators ||= injector.instantiateUnmapped(IConversationsCommunicator);
		}
		public function get presences():IPresences {
			return _presences;
		}
		public function get activities():IActivities {
			return _activities;
		}
		public function get conversations():IConversationsCommunicator {
			return _conversations;
		}
		public function get threadGenerator():IIDGenerator {
			if(_threadGenerator == null) {
				_threadGenerator = new RandomGenerator();
			}
			return _threadGenerator;
		}

		public function get receiptRequests():Dictionary {
			return _receiptRequests;
		}

		public function get connection():IXMPPConnection {
			return _connection;
		}

		public function set connection(value:IXMPPConnection):void {
			_connection = value;
		}

		public function get conferenceServer():String {
			return "conference." + _connection.domain;
		}

		public function isMe(jid:AbstractJID):Boolean {
			var unescapedJID:UnescapedJID = JIDUtil.unescape(jid);
			return currentUser.jid.equals(unescapedJID, false);
		}

	}
}
