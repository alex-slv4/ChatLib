/**
 * Created by kvint on 02.12.14.
 */
package com.chat.model.data.citems {
	import com.chat.model.data.*;
	import org.igniterealtime.xiff.core.AbstractJID;

	public class CItemConversation extends BaseCItem {

		private var _lastMessage:CItemMessage;
		private var _withJID:AbstractJID;
		private var _startTime:Number;

		public function CItemConversation(withJID:AbstractJID, startTime:Number = NaN) {
			super(null);
			_withJID = withJID;
			_startTime = startTime;
		}

		override public function get from():Object {
			return _withJID;
		}

		public function get lastMessage():CItemMessage {
			return _lastMessage;
		}
		public function set lastMessage(value:CItemMessage):void {
			_lastMessage = value;
		}

		override public function get time():Number {
			return _lastMessage ? _lastMessage.time : _startTime;
		}
	}
}
