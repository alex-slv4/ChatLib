/**
 * Created by kvint on 02.11.14.
 */
package view.communicator {
	import feathers.controls.TextInput;

	public class WritableCommunicatorView extends HistoryCommunicatorView {

		private var _input:TextInput = new TextInput();

		public function WritableCommunicatorView() {
			super();
		}
		override protected function initialize():void {
			super.initialize();
			addChild(input);
		}

		public function get input():TextInput {
			return _input;
		}
	}
}
