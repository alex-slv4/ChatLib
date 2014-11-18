/**
 * Created by kvint on 02.11.14.
 */
package com.chat.model.communicators {
	import com.chat.events.CommunicatorEvent;
	import com.chat.model.data.ICItem;

	public class TeamCommunicator extends DefaultCommunicator implements ICommunicator {
		public function TeamCommunicator() {
		}

		public function get type():int {
			return CommunicatorType.TEAM;
		}

		public function get uid():String {
			return "";
		}


		public function get name():String {
			return "Team";
		}

		public function add(data:ICItem):void {
			_items.push(data);
			dispatchEvent(new CommunicatorEvent(CommunicatorEvent.ITEM_ADDED, data));
		}
	}
}
