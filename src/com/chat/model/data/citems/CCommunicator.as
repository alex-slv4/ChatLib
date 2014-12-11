/**
 * Created by kvint on 11.12.14.
 */
package com.chat.model.data.citems {

	import com.chat.model.communicators.ICommunicator;

	public class CCommunicator implements ICCommunicator {

		private var _communicator:ICommunicator;
		private var _startTime:Number;

		public function CCommunicator(communicator:ICommunicator, startTime:Number = NaN) {
			_communicator = communicator;
			_startTime = startTime;
		}

		public function get data():* {
			return _communicator;
		}

		public function get communicator():ICommunicator {
			return _communicator;
		}

		public function get lastMessage():ICMessage {
			return null;
		}

		public function get time():Number {
			return _startTime;
		}

		public function toString():String {
			return this.toString();
		}

	}
}
