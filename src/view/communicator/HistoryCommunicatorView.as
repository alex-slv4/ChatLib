/**
 * Created by kvint on 02.11.14.
 */
package view.communicator {
	import feathers.controls.List;

	public class HistoryCommunicatorView extends DefaultCommunicatorView {

		private var _list:List = new List();

		public function HistoryCommunicatorView() {
			super();
		}
		public function get list():List {
			return _list;
		}
		override protected function initialize():void {
			super.initialize();
			addChild(list);
		}
	}
}
