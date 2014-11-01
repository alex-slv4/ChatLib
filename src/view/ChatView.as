/**
 * Created by kvint on 01.11.14.
 */
package view {

	import feathers.controls.LayoutGroup;
	import view.communicator.CommunicatorView;
	import view.tabs.ChatTabsView;

	public class ChatView extends LayoutGroup {

		private var _communicatorView		:CommunicatorView 	= new CommunicatorView();
		private var _tabsView				:ChatTabsView 		= new ChatTabsView();

		override protected function initialize():void {
			super.initialize();

			addChild(communicatorView);
			addChild(tabsView);
		}

		public function get tabsView():ChatTabsView {
			return _tabsView;
		}

		public function get communicatorView():LayoutGroup {
			return _communicatorView;
		}
	}
}
