/**
 * Created by kvint on 02.11.14.
 */
package view.chat.communicator.types {
import view.chat.communicator.*;
	import flash.ui.Keyboard;

	import starling.events.KeyboardEvent;

import view.chat.communicator.types.HistoryCommunicatorMediator;

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
