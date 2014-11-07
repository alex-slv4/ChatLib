/**
 * Created by kvint on 02.11.14.
 */
package view.chat.tabs {
	import model.communicators.ICommunicator;

	import robotlegs.extensions.starlingFeathers.impl.FeathersMediator;

	public class CommunicatorTabMediator extends FeathersMediator {

		private var view:CommunicatorTabView;

		public function CommunicatorTabMediator() {
		}

		override public function initializeComplete():void {
			super.initializeComplete();
			view = viewComponent as CommunicatorTabView;
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
