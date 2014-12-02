/**
 * Created by kvint on 02.12.14.
 */
package com.chat.model.data {
	import org.igniterealtime.xiff.core.AbstractJID;

	public class CItemConversation extends BaseCItem {

		private var _lastMessage:CItemMessage;
		private var _withJID:AbstractJID;

		public function CItemConversation(withJID:AbstractJID) {
			super(null);
			_withJID = withJID;
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
	}
}
