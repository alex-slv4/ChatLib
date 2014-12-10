/**
 * Created by kvint on 11.12.14.
 */
package com.chat.model.data.citems {
	import com.chat.model.communicators.ICommunicator;

	public class CItemCommunicator implements ICItem {

		private var _communicator:ICommunicator;

		public function CItemCommunicator(communicator:ICommunicator) {
			_communicator = communicator;
		}

		public function get data():Object {
			return null;
		}

		public function get time():Number {
			return 0;
		}

		public function get from():Object {
			return null;
		}

		public function get body():Object {
			return null;
		}

		public function get isRead():Boolean {
			return false;
		}

		public function set isRead(value:Boolean):void {
		}

		public function get communicator():ICommunicator {
			return _communicator;
		}
	}
}
