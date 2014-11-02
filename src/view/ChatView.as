/**
 * Created by kvint on 01.11.14.
 */
package view {

	import feathers.controls.LayoutGroup;

	import view.communicator.DefaultCommunicatorView;

	import view.communicator.ICommunicatorView;
	import view.tabs.ChatTabsView;

	public class ChatView extends LayoutGroup {

		private var _communicatorContainer	:LayoutGroup 		= new LayoutGroup();
		private var _communicatorView		:DefaultCommunicatorView;
		private var _tabsView				:ChatTabsView 		= new ChatTabsView();

		override protected function initialize():void {
			super.initialize();

			addChild(communicatorContainer);
			addChild(tabsView);
		}

		public function get tabsView():ChatTabsView {
			return _tabsView;
		}

		public function get communicatorView():ICommunicatorView {
			return _communicatorView;
		}

		public function set communicatorView(value:ICommunicatorView):void {
			if(_communicatorView){
				_communicatorView.removeFromParent();
			}
			_communicatorView = value as DefaultCommunicatorView;
			communicatorContainer.addChild(_communicatorView);
		}

		public function get communicatorContainer():LayoutGroup {
			return _communicatorContainer;
		}
	}
}
