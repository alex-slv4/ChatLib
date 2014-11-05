/**
 * Created by kvint on 02.11.14.
 */
package model.communicators {
	public class GlobalCommunicator extends DefaultCommunicator {
		public function GlobalCommunicator() {
			_label = "Global";
		}

		override public function get type():int {
			return CommunicatorTypes.GLOBAL;
		}
	}
}
