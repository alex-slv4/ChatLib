/**
 * Created by kvint on 02.11.14.
 */
package com.chat.model.communicators {
	import com.chat.events.CommunicatorEvent;
	import com.chat.model.data.ICItem;

	public class LogCommunicator extends DefaultCommunicator implements UIDCommunicator {

		public function get type():int {
			return CommunicatorType.LOG;
		}

		public function add(data:ICItem):void {
			_items.push(data);
			dispatchEvent(new CommunicatorEvent(CommunicatorEvent.ITEM_ADDED, data));
		}

		public function get uid():String {
			return "";
		}

		public function get name():String {
			return "";
		}
	}
}
