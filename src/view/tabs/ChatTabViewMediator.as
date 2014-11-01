/**
 * Created by kvint on 02.11.14.
 */
package view.tabs {
	import model.ICommunicator;

	import robotlegs.extensions.starlingFeathers.impl.FeathersMediator;

	public class ChatTabViewMediator extends FeathersMediator {

		private var view:ChatTabView;

		public function ChatTabViewMediator() {
		}

		override public function initializeComplete():void {
			super.initializeComplete();
			view = viewComponent as ChatTabView;
			view.provider.subscribe(tabDataChanged);
		}

		private function updateViewData():void {
			view.label = data.label;
		}

		private function tabDataChanged():void {
			updateViewData();
		}
		public function get data():ICommunicator {
			return view.provider.data as ICommunicator;
		}


		override public function destroy():void {
			view.provider.unsubscribe(tabDataChanged);
			super.destroy();
		}
	}
}
