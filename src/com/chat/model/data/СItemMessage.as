/**
 * Created by kvint on 13.11.14.
 */
package com.chat.model.data {
	import org.igniterealtime.xiff.core.AbstractJID;
	import org.igniterealtime.xiff.data.Message;

	public class СItemMessage extends BaseCItem {

		public function СItemMessage(data:Message) {
			super(data);
		}

		override public function get time():Number {
			return 0;
		}

		override public function get from():Object {
			if (data.from is AbstractJID)
				return (data.from as AbstractJID).node;
			else if (data.from is String)
				return data.from;
			else
				return data.from;
		}

		override public function get body():Object {
			return data.body;
		}

	}
}
