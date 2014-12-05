/**
 * Created by kvint on 02.11.14.
 */
package com.chat.model.communicators {
	import com.chat.model.history.IHistoryProvider;

	public class TeamCommunicator extends DefaultCommunicator implements ICommunicator {
		public function TeamCommunicator() {
		}

		public function get type():int {
			return CommunicatorType.TEAM;
		}

		public function get name():String {
			return "Team";
		}

		public function get history():IHistoryProvider {
			return null;
		}
	}
}
