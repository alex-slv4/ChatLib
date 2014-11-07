/**
 * Created by kvint on 02.11.14.
 */
package view.chat.tabs {
	import feathers.controls.Button;

	import utils.providers.IViewDataProvider;
	import utils.providers.ViewDataProvider;

	public class CommunicatorTabView extends Button {

		private var _provider:IViewDataProvider = new ViewDataProvider();

		public function CommunicatorTabView() {
			super();
		}

		public function get provider():IViewDataProvider {
			return _provider;
		}
	}
}
