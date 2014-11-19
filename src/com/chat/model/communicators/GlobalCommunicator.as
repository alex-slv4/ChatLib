/**
 * Created by kvint on 02.11.14.
 */
package com.chat.model.communicators {
	import com.chat.events.CommunicatorEvent;
	import com.chat.model.data.ICItem;

	public class GlobalCommunicator extends DefaultCommunicator implements ICommunicator{

		public function get type():int {
			return CommunicatorType.GLOBAL;
		}


		public function get name():String {
			return "";
		}

		public function add(data:ICItem):void {
			_items.push(data);
			dispatchEvent(new CommunicatorEvent(CommunicatorEvent.ITEM_ADDED, data));
		}
	}
}
