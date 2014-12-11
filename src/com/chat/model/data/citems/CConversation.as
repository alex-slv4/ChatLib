/**
 * Created by kvint on 02.12.14.
 */
package com.chat.model.data.citems {
	import org.igniterealtime.xiff.core.AbstractJID;

	public class CConversation extends BaseCItem {

		private var _lastMessage:CMessage;
		private var _withJID:AbstractJID;
		private var _startTime:Number;

		public function CConversation(withJID:AbstractJID, startTime:Number = NaN) {
			super(null);
			_withJID = withJID;
			_startTime = startTime;
		}

		override public function get from():Object {
			return _withJID;
		}

		public function get lastMessage():CMessage {
			return _lastMessage;
		}
		public function set lastMessage(value:CMessage):void {
			_lastMessage = value;
		}

		override public function get time():Number {
			return _lastMessage ? _lastMessage.time : _startTime;
		}

		override public function toString():String {
			return _withJID.bareJID;
		}
	}
}
