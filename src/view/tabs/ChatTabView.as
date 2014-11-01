/**
 * Created by kvint on 02.11.14.
 */
package view.tabs {
	import feathers.controls.Button;

	import utils.providers.IViewDataProvider;
	import utils.providers.ViewDataProvider;

	public class ChatTabView extends Button {

		private var _provider:IViewDataProvider = new ViewDataProvider();

		public function ChatTabView() {
			super();
		}

		public function get provider():IViewDataProvider {
			return _provider;
		}
	}
}
