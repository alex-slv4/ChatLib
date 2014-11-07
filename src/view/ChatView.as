/**
 * Created by kvint on 01.11.14.
 */
package view {

import feathers.controls.LayoutGroup;

import view.CommunicatorContainerView;

import view.tabs.CommunicatorsTabsView;

public class ChatView extends LayoutGroup {

		private var _containerView	:CommunicatorContainerView 	= new CommunicatorContainerView();
		private var _tabsView		:CommunicatorsTabsView 		= new CommunicatorsTabsView();

		override protected function initialize():void
		{
			addChild(containerView);
			addChild(tabsView);
		}

		public function get containerView():CommunicatorContainerView
		{
			return _containerView;
		}

		public function get tabsView():CommunicatorsTabsView
		{
			return _tabsView;
		}
	}
}
