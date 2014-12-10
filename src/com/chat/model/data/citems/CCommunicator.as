/**
 * Created by kvint on 11.12.14.
 */
package com.chat.model.data.citems {
	import com.chat.model.communicators.ICommunicator;

	public class CCommunicator implements ICCommunicator {

		private var _communicator:ICommunicator;

		public function CCommunicator(communicator:ICommunicator) {
			_communicator = communicator;
		}

		public function get data():* {
			return _communicator;
		}

		public function get communicator():ICommunicator {
			return _communicator;
		}

		public function toString():String {
			return this.toString();
		}
	}
}
