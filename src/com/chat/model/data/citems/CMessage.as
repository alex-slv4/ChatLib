/**
 * Created by kvint on 13.11.14.
 */
package com.chat.model.data.citems {
	import org.igniterealtime.xiff.core.AbstractJID;
	import org.igniterealtime.xiff.data.Message;

	public class CMessage extends CTime implements ICMessage, ICTime {

		private var _messageData:Message;
		private var _isRead:Boolean;

		public function CMessage(data:Message, time:Number = NaN) {
			super(data);
			this.originTime = isNaN(time) ? new Date().time : time;
			this.time = time;
			_messageData = data;
		}

		public function get body():Object {
			return messageData.body;
		}

		override public function get time():Number {
			if(isNaN(_originTime)){
				if(messageData.time != null) return convertTimeFromDate(messageData.time);
				return currentTime;
			}
			return super.time;
		}

		public function get from():Object {
			if (messageData.from is AbstractJID){
				if(messageData.type == Message.TYPE_GROUPCHAT){
					return messageData.from.resource;
				}
				return (messageData.from as AbstractJID).node;
			}
			else if (messageData.from is String)
				return messageData.from;
			else
				return messageData.from;
		}

		public function get isRead():Boolean {
			return _isRead;
		}

		public function set isRead(value:Boolean):void {
			_isRead = value;
		}

		override public function toString():String {
			return String(body);
		}

		public function get messageData():Message {
			return _messageData;
		}

		override public function get data():* {
			//Please use messageData instead
			return null;
		}
	}
}
