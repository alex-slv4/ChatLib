/**
 * Created by kvint on 02.11.14.
 */
package model {
	public class BaseCommunicator implements ICommunicator {

		protected var _label:String = "";

		public function BaseCommunicator() {
		}

		public function get type():int {
			return 0;
		}
		public function get label():String {
			return _label;
		}
	}
}
