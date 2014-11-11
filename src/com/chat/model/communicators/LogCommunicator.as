/**
 * Created by kvint on 02.11.14.
 */
package com.chat.model.communicators {
	public class LogCommunicator extends DefaultCommunicator {
		public function LogCommunicator() {
			_label = "Log";
		}
		override public function get type():int {
			return CommunicatorType.LOG;
		}
	}
}
