/**
 * Created by kvint on 01.11.14.
 */
package view {

	import feathers.controls.LayoutGroup;
	import feathers.core.FeathersControl;

	import view.communicator.CommunicatorView;
	import view.tabs.ChatTabsView;

	public class ChatView extends LayoutGroup {

		private var _communicatorContainer	:LayoutGroup 		= new LayoutGroup();
		private var _communicatorView		:CommunicatorView;
		private var _tabsView				:ChatTabsView 		= new ChatTabsView();

		override protected function initialize():void {
			super.initialize();

			addChild(communicatorContainer);
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
				_communicatorView.removeFromParent();
			}
			_communicatorView = value;
			communicatorContainer.addChild(_communicatorView);
		}

		public function get communicatorContainer():LayoutGroup {
			return _communicatorContainer;
		}
	}
}
