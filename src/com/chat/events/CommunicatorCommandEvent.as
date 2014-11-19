/**
 * Created by AlexanderSla on 11.11.2014.
 */
package com.chat.events {
import com.chat.model.communicators.ICommunicatorBase;

import flash.events.Event;

public class CommunicatorCommandEvent extends Event {

		public static const HELP:String = "help";
		public static const INFO:String = "info";
		public static const PRIVATE_MESSAGE:String = "privateMessage";
		public static const TRACE:String = "trace";
		public static const CLEAR:String = "clear";
		public static const HISTORY:String = "retrieveHistory";

		public static const ROOM:String = "room";
		public static const ROOM_CREATE:String = "roomCreate";
		public static const ROOM_INFO:String = "roomInfo";
		public static const ROOM_JOIN:String = "roomJoin";
		public static const ROOM_LEAVE:String = "roomLeave";
		public static const ROOM_MESSAGE:String = "roomMessage";

		public static const ROSTER:String = "roster";
		public static const ROSTER_ADD:String = "rosterAdd";
		public static const ROSTER_INFO:String = "rosterInfo";
		public static const ROSTER_REMOVE:String = "rosterRemove";

		public static const SEND_MESSAGE_STATE:String = "sendMessageState";
		public static const MARK_AS_RECEIVED:String = "markMessageAsReceived";
		public static const ON_MESSAGE_RECEIVED:String = "onMessageReceived";
		public static const CLOSE:String = "close";

		private var _communicator:ICommunicatorBase;
		private var _params:Array;

		public function CommunicatorCommandEvent(type:String, communicator:ICommunicatorBase, params:Array) {
			super(type, false, false);
			_params = params;
			_communicator = communicator;
		}

		public function get communicator():ICommunicatorBase {
			return _communicator;
		}

		public function get params():Array {
			return _params;
		}
	}
}
