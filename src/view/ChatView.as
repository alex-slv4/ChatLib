/**
 * Created by kvint on 01.11.14.
 */
package view {

	import feathers.controls.LayoutGroup;
	import view.communicator.CommunicatorView;
	import view.tabs.ChatTabsView;

	public class ChatView extends LayoutGroup {

		private var _communicatorView		:CommunicatorView;
		private var _tabsView				:ChatTabsView 		= new ChatTabsView();

		override protected function initialize():void {
			super.initialize();

			addChild(tabsView);
		}

		public function get tabsView():ChatTabsView {
			return _tabsView;
		}

		public function get communicatorView():CommunicatorView {
			return _communicatorView;
		}

		public function set communicatorView(value:CommunicatorView):void {
			if(_communicatorView){
				removeChild(_communicatorView);
			}
			_communicatorView = value;
			addChild(_communicatorView);
		}
	}
}
