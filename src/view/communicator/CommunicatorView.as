/**
 * Created by kvint on 01.11.14.
 */
package view.communicator {
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.TextInput;

	public class CommunicatorView extends LayoutGroup implements ICommunicatorView {

		private var _list:List = new List();
		private var _input:TextInput = new TextInput();


		override protected function initialize():void {
			super.initialize();
			addChild(list);
			addChild(input);
		}

		public function get list():List {
			return _list;
		}

		public function get input():TextInput {
			return _input;
		}
	}
}
