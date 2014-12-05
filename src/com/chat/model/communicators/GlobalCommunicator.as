/**
 * Created by kvint on 02.11.14.
 */
package com.chat.model.communicators {
	import com.chat.events.CommunicatorEvent;
	import com.chat.model.history.IHistoryProvider;
	import com.chat.model.data.citems.ICItem;

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

		public function get history():IHistoryProvider {
			return null;
		}
	}
}
