/**
 * Created by kvint on 02.11.14.
 */
package view.communicator {
	import flash.ui.Keyboard;

	import starling.events.KeyboardEvent;

	public class WritableCommunicatorMediator extends HistoryCommunicatorMediator {
		override public function initializeComplete():void {
			super.initializeComplete();
			writableView.input.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		private function onKeyDown(event:KeyboardEvent):void {
			if(writableView.input.text.length){
				if(event.keyCode == Keyboard.ENTER){
					onSend();
				}
			}
		}

		protected function onSend():void {

		}

		protected function get writableView():WritableCommunicatorView {
			return view as WritableCommunicatorView;
		}
	}
}
