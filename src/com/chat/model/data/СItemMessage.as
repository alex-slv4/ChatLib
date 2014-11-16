/**
 * Created by kvint on 13.11.14.
 */
package com.chat.model.data {
	import org.igniterealtime.xiff.core.AbstractJID;
	import org.igniterealtime.xiff.data.Message;

	public class СItemMessage extends BaseCItem {

		private var _time:Number;

		public function СItemMessage(data:Message, time:Number = NaN) {
			super(data);
			_time = time;
		}

		override public function get time():Number {
			if(!isNaN(_time)) return _time;
			if(messageData.time != null) return messageData.time.time;
			return 0;
		}

		override public function get from():Object {
			if (data.from is AbstractJID){
				if(messageData.type == Message.TYPE_GROUPCHAT){
					return messageData.from.resource;
				}
				return (data.from as AbstractJID).node;
			}
			else if (data.from is String)
				return data.from;
			else
				return data.from;
		}

		private function get messageData():Message {
			return data as Message;
		}

		override public function get body():Object {
			return data.body;
		}

	}
}
