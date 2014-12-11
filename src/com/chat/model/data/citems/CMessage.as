/**
 * Created by kvint on 13.11.14.
 */
package com.chat.model.data.citems {
	import org.igniterealtime.xiff.core.AbstractJID;
	import org.igniterealtime.xiff.data.Message;

	public class CMessage implements ICMessage {

		private var _time:Number;
		private var _data:Message;
		private var _isRead:Boolean;

		public function CMessage(data:Message, time:Number = NaN) {
			super(data);
			_time = time;
			_data = data;
		}

		public function get body():Object {
			return _data.body;
		}

		public function get time():Number {
			if(!isNaN(_time)) return _time;
			if(_data.time != null) return _data.time.time;
			return new Date().time;
		}

		public function get from():Object {
			if (_data.from is AbstractJID){
				if(_data.type == Message.TYPE_GROUPCHAT){
					return _data.from.resource;
				}
				return (_data.from as AbstractJID).node;
			}
			else if (_data.from is String)
				return _data.from;
			else
				return _data.from;
		}

		public function get data():* {
			return _data;
		}

		public function get isRead():Boolean {
			return _isRead;
		}

		public function set isRead(value:Boolean):void {
			_isRead = value;
		}
	}
}
