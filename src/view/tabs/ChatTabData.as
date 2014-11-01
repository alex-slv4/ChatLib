/**
 * Created by kvint on 02.11.14.
 */
package view.tabs {
	import model.ICommunicator;

	public class ChatTabData {

		private var _provider:ICommunicator;

		public function ChatTabData(provider:ICommunicator) {
			_provider = provider;
		}

		public function get provider():ICommunicator {
			return _provider;
		}

		public function set provider(value:ICommunicator):void {
			_provider = value;
		}
	}
}
