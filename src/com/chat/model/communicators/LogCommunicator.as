/**
 * Created by kvint on 02.11.14.
 */
package com.chat.model.communicators {
	import com.chat.model.history.IHistoryProvider;

	public class LogCommunicator extends DefaultCommunicator implements ICommunicator {

		public function get type():int {
			return CommunicatorType.LOG;
		}

		public function get name():String {
			return "";
		}

		public function get history():IHistoryProvider {
			return null;
		}
	}
}
