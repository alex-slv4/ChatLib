package com.chat.controller {
import com.chat.model.ChatUser;
import com.hurlant.crypto.tls.TLSConfig;
import com.hurlant.crypto.tls.TLSEngine;

import flash.events.EventDispatcher;
import flash.events.TimerEvent;
import flash.system.Security;
import flash.utils.Timer;

import org.igniterealtime.xiff.auth.External;
import org.igniterealtime.xiff.auth.Plain;
import org.igniterealtime.xiff.collections.ArrayCollection;
import org.igniterealtime.xiff.collections.events.CollectionEvent;
import org.igniterealtime.xiff.conference.InviteListener;
	import org.igniterealtime.xiff.core.IXMPPConnection;
	import org.igniterealtime.xiff.core.InBandRegistrator;
import org.igniterealtime.xiff.core.UnescapedJID;
import org.igniterealtime.xiff.core.XMPPTLSConnection;
import org.igniterealtime.xiff.data.Message;
import org.igniterealtime.xiff.data.Presence;
import org.igniterealtime.xiff.data.im.RosterItemVO;
import org.igniterealtime.xiff.events.ConnectionSuccessEvent;
import org.igniterealtime.xiff.events.DisconnectionEvent;
import org.igniterealtime.xiff.events.IncomingDataEvent;
import org.igniterealtime.xiff.events.InviteEvent;
import org.igniterealtime.xiff.events.LoginEvent;
import org.igniterealtime.xiff.events.MessageEvent;
import org.igniterealtime.xiff.events.OutgoingDataEvent;
import org.igniterealtime.xiff.events.PresenceEvent;
import org.igniterealtime.xiff.events.RegistrationFieldsEvent;
import org.igniterealtime.xiff.events.RegistrationSuccessEvent;
import org.igniterealtime.xiff.events.RosterEvent;
import org.igniterealtime.xiff.events.XIFFErrorEvent;
	import org.igniterealtime.xiff.im.IRoster;
	import org.igniterealtime.xiff.im.Roster;
import org.igniterealtime.xiff.util.Zlib;

public class BaseChatController extends EventDispatcher {
		private const KEEP_ALIVE_TIME:int = 30000;
		[Bindable]
		public static var serverName:String = "localhost";
		[Bindable]
		public static var serverPort:int = 5222;
		[Bindable]
		public static var compress:Boolean = false;
		[Bindable]
		public static var useTls:Boolean = false;
		[Bindable]
		public static var facebookAppId:String = "FACEBOOK_APP_ID";

		public static function isValidJID(jid:UnescapedJID):Boolean {
			var value:Boolean = false;
			var pattern:RegExp = /(\w|[_.\-])+@(localhost$|((\w|-)+\.)+\w{2,4}$){1}/;
			var result:Object = pattern.exec(jid.toString());

			if (result) {
				value = true;
			}
			return value;
		}

		public function init():void {
			setupConnection();
			setupInviteListener();
			setupInBandRegistrator();
			setupRoster();
			setupChat();
			setupCurrentUser();
			registerSASLMechanisms();
			setupTimer();
		}

		protected var registerUser:Boolean;
		protected var registrationData:Object;
		protected var keepAliveTimer:Timer;

		protected var _connection:XMPPTLSConnection;

		public function get connection():XMPPTLSConnection {
			return _connection;
		}

		protected var _inviteListener:InviteListener;

		public function get inviteListener():InviteListener {
			return _inviteListener;
		}

		protected var _inbandRegister:InBandRegistrator;

		public function get inbandRegister():InBandRegistrator {
			return _inbandRegister;
		}

		public function get roster():IRoster {
			return null;
		}

		protected var _chatUserRoster:ArrayCollection;

		public function get chatUserRoster():ArrayCollection {
			return _chatUserRoster;
		}

		public function connect(username:String, password:String):void {
			var domainIndex:int = username.lastIndexOf( "@" );
			var _username:String = domainIndex > -1 ? username.substring( 0, domainIndex ) : username;
			var domain:String = domainIndex > -1 ? username.substring( domainIndex + 1 ) : null;
			Security.loadPolicyFile("xmlsocket://" + BaseChatController.serverName + ":" + BaseChatController.serverPort);
			registerUser = false;
			connection.tls = BaseChatController.useTls;
			connection.username = _username;
			connection.password = password;
			connection.domain = domain;
			connection.server = BaseChatController.serverName;
			connection.port = BaseChatController.serverPort;
			connection.connect();
		}

		public function disconnect():void {
			connection.disconnect();
			roster.removeAll();
			setupCurrentUser();
		}

		public function updatePresence(show:String, status:String):void {
			roster.setPresence(show, status, 0);
		}

		public function register(username:String, password:String):void {
			registerUser = true;

			connection.username = null;
			connection.password = null;

			connection.server = serverName;
			connection.connect();

			registrationData = {};
			registrationData.username = username;
			registrationData.password = password;
		}

		public function updateGroup(rosterItem:RosterItemVO, groupName:String):void {
			roster.updateContactGroups(rosterItem, [ groupName ]);
		}

		protected function setupConnection():void {
			_connection = new XMPPTLSConnection();
			connection.compressor = new Zlib();
			var config:TLSConfig = new TLSConfig(TLSEngine.CLIENT);
			config.ignoreCommonNameMismatch = true;
			connection.config = config;
			addConnectionListeners();
		}

		protected function addConnectionListeners():void {
			connection.addEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS, onConnectSuccess);
			connection.addEventListener(DisconnectionEvent.DISCONNECT, onDisconnect);
			connection.addEventListener(LoginEvent.LOGIN, onLogin);
			connection.addEventListener(XIFFErrorEvent.XIFF_ERROR, onXIFFError);
			connection.addEventListener(OutgoingDataEvent.OUTGOING_DATA, onOutgoingData);
			connection.addEventListener(IncomingDataEvent.INCOMING_DATA, onIncomingData);
			connection.addEventListener(PresenceEvent.PRESENCE, onPresence);
			connection.addEventListener(MessageEvent.MESSAGE, onMessageCome);
		}

		protected function removeConnectionListeners():void {
			connection.removeEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS, onConnectSuccess);
			connection.removeEventListener(DisconnectionEvent.DISCONNECT, onDisconnect);
			connection.removeEventListener(LoginEvent.LOGIN, onLogin);
			connection.removeEventListener(XIFFErrorEvent.XIFF_ERROR, onXIFFError);
			connection.removeEventListener(OutgoingDataEvent.OUTGOING_DATA, onOutgoingData);
			connection.removeEventListener(IncomingDataEvent.INCOMING_DATA, onIncomingData);
			connection.removeEventListener(PresenceEvent.PRESENCE, onPresence);
			connection.removeEventListener(MessageEvent.MESSAGE, onMessageCome);
		}

		protected function setupInviteListener():void {
			_inviteListener = new InviteListener();
			_inviteListener.addEventListener(InviteEvent.INVITED, onInvited);
			_inviteListener.connection = this.connection;
		}

		protected function setupInBandRegistrator():void {
			_inbandRegister = new InBandRegistrator();
			_inbandRegister.addEventListener(RegistrationFieldsEvent.REG_FIELDS, onRegistrationFields);
			_inbandRegister.addEventListener(RegistrationSuccessEvent.REGISTRATION_SUCCESS, onRegistrationSuccess);
			_inbandRegister.connection = this.connection;
		}

		protected function setupRoster():void {
			roster.addEventListener(RosterEvent.ROSTER_LOADED, onRosterLoaded);
			roster.addEventListener(RosterEvent.SUBSCRIPTION_DENIAL, onSubscriptionDenial);
			roster.addEventListener(RosterEvent.SUBSCRIPTION_REQUEST, onSubscriptionRequest);
			roster.addEventListener(RosterEvent.SUBSCRIPTION_REVOCATION, onSubscriptionRevocation);
			roster.addEventListener(RosterEvent.USER_ADDED, onUserAdded);
			roster.addEventListener(RosterEvent.USER_AVAILABLE, onUserAvailable);
			roster.addEventListener(RosterEvent.USER_PRESENCE_UPDATED, onUserPresenceUpdated);
			roster.addEventListener(RosterEvent.USER_REMOVED, onUserRemoved);
			roster.addEventListener(RosterEvent.USER_SUBSCRIPTION_UPDATED, onUserSubscriptionUpdated);
			roster.addEventListener(RosterEvent.USER_UNAVAILABLE, onUserUnavailable);
			roster.addEventListener(CollectionEvent.COLLECTION_CHANGE, onRosterChange);
			roster.connection = this.connection;

			_chatUserRoster = new ArrayCollection();
		}

		protected function setupChat():void {
		}

		protected function setupCurrentUser():void {
		}

		protected function registerSASLMechanisms():void {
			// By default only ANONYMOUS and DIGEST-MD5 enabled.
			connection.enableSASLMechanism(External.MECHANISM, External);
			connection.enableSASLMechanism(Plain.MECHANISM, Plain);
			//_connection.enableSASLMechanism( XGoogleToken.MECHANISM, XGoogleToken );
		}

		protected function setupTimer():void {
			keepAliveTimer = new Timer(KEEP_ALIVE_TIME);
			keepAliveTimer.addEventListener(TimerEvent.TIMER, onKeepAliveTimer);
		}

		protected function cleanup():void {
			removeConnectionListeners();
			setupCurrentUser();
			_chatUserRoster.removeAll();
			keepAliveTimer.stop();
		}

		protected function updateChatUserRoster():void {
			var users:Array = [];
			for (var i:int = 0; i < roster.length; i++) {
				var rosterItem:RosterItemVO = roster.getItemAt(i);
				var chatUser:ChatUser = new ChatUser(rosterItem.jid);
				chatUser.rosterItem = rosterItem;
				chatUser.loadVCard(connection);
				users.push(chatUser);
			}
			_chatUserRoster.source = users;
		}


		protected function onConnectSuccess(event:ConnectionSuccessEvent):void {
			if (registerUser) {
				_inbandRegister.sendRegistrationFields(registrationData, null);
			}

			dispatchEvent(event);
		}

		protected function onDisconnect(event:DisconnectionEvent):void {
			cleanup();
			setupConnection();
			roster.connection = this.connection;

			dispatchEvent(event);
		}

		protected function onLogin(event:LoginEvent):void {
			setupCurrentUser();
			keepAliveTimer.start();
			dispatchEvent(event);
		}

		protected function onXIFFError(event:XIFFErrorEvent):void {
			dispatchEvent(event);
		}

		protected function onOutgoingData(event:OutgoingDataEvent):void {
			trace("sent\n", event.data)
			dispatchEvent(event);
		}

		protected function onIncomingData(event:IncomingDataEvent):void {
			trace("come\n", event.data)
			dispatchEvent(event);
		}

		protected function onRegistrationFields(event:RegistrationFieldsEvent):void {
			dispatchEvent(event);
		}

		protected function onRegistrationSuccess(event:RegistrationSuccessEvent):void {
			connection.disconnect();
			dispatchEvent(event);
		}

		protected function onPresence(event:PresenceEvent):void {
			var presence:Presence = event.data[ 0 ] as Presence;

			if (presence.type == Presence.TYPE_ERROR) {
				var xiffErrorEvent:XIFFErrorEvent = new XIFFErrorEvent();
				xiffErrorEvent.errorCode = presence.errorCode;
				xiffErrorEvent.errorCondition = presence.errorCondition;
				xiffErrorEvent.errorMessage = presence.errorMessage;
				xiffErrorEvent.errorType = presence.errorType;
				onXIFFError(xiffErrorEvent);
			}
			else {
				dispatchEvent(event);
			}
		}

		protected function onMessageCome(event:MessageEvent):void {
			var message:Message = event.data as Message;

			if (message.type == Message.TYPE_ERROR) {
				var xiffErrorEvent:XIFFErrorEvent = new XIFFErrorEvent();
				xiffErrorEvent.errorCode = message.errorCode;
				xiffErrorEvent.errorCondition = message.errorCondition;
				xiffErrorEvent.errorMessage = message.errorMessage;
				xiffErrorEvent.errorType = message.errorType;
				onXIFFError(xiffErrorEvent);
			}
			else {
				dispatchEvent(event);
			}
		}

		protected function onInvited(event:InviteEvent):void {
			dispatchEvent(event);
		}

		protected function onRosterLoaded(event:RosterEvent):void {
			updateChatUserRoster();

			dispatchEvent(event);
		}

		protected function onSubscriptionDenial(event:RosterEvent):void {
			dispatchEvent(event);
		}

		protected function onSubscriptionRequest(event:RosterEvent):void {
			if (roster.contains(RosterItemVO.get(event.jid, false))) {
				roster.grantSubscription(event.jid, true);
			}

			dispatchEvent(event);
		}

		protected function onSubscriptionRevocation(event:RosterEvent):void {
			dispatchEvent(event);
		}

		protected function onUserAdded(event:RosterEvent):void {
			dispatchEvent(event);
		}

		protected function onUserAvailable(event:RosterEvent):void {
			dispatchEvent(event);
		}

		protected function onUserPresenceUpdated(event:RosterEvent):void {
			dispatchEvent(event);
		}

		protected function onUserRemoved(event:RosterEvent):void {
			dispatchEvent(event);
		}

		protected function onUserSubscriptionUpdated(event:RosterEvent):void {
			dispatchEvent(event);
		}

		protected function onUserUnavailable(event:RosterEvent):void {
			dispatchEvent(event);
		}

		protected function onRosterChange(event:CollectionEvent):void {
			updateChatUserRoster();
		}

		protected function onKeepAliveTimer(event:TimerEvent):void {
			if (connection.loggedIn) {
				connection.sendKeepAlive();
			}
		}

	}
}