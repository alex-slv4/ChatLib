/**
 * Created by AlexanderSla on 05.11.2014.
 */
package com.chat.model.data {
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.Message;

	public class ChatMessage extends Message {

		private var _read:Boolean = false;

		public function ChatMessage(recipient:EscapedJID = null, msgID:String = null, msgBody:String = null, msgHTMLBody:String = null, msgType:String = null, msgSubject:String = null, chatState:String = null) {
			super(recipient, msgID, msgBody, msgHTMLBody, msgType, msgSubject, chatState);
		}

		public static function createFromBase(base:Message):ChatMessage{
			var msg:ChatMessage = new ChatMessage();
			msg.xml = base.xml;
			return msg;
		}

		public function get read():Boolean {
			return _read;
		}

		public function set read(value:Boolean):void {
			_read = value;
		}
	}
}
