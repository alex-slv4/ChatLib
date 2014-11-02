/**
 * Created by kvint on 02.11.14.
 */
package model {
	import view.communicator.CommunicatorView;

	public class DefaultCommunicator implements ICommunicator {

		protected var _label:String;

		public function DefaultCommunicator() {
		}

		public function get type():int {
			return 0;
		}
		public function get label():String {
			return _label ? _label : toString();
		}

		public function toString():String {
			return "[DefaultCommunicator]";
		}
	}
}
