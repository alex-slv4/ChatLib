/**
 * Created by kvint on 02.11.14.
 */
package view.chat.communicator.types {
	import feathers.controls.TextInput;

import view.chat.communicator.types.HistoryCommunicatorView;

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
