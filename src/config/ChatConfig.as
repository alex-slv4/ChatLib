/**
 * Created by kvint on 01.11.14.
 */
package config {
	import controller.ChatController;

	import model.ChatModel;

	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;

	import view.ChatView;
	import view.ChatMediator;
	import view.tabs.ChatTabView;
	import view.tabs.ChatTabViewMediator;
	import view.tabs.ChatTabsMediator;
	import view.tabs.ChatTabsView;

	public class ChatConfig implements IConfig {

		[Inject]
		public var context:IContext;

		[Inject]
		public var injector:IInjector;

		[Inject]
		public var mediatorMap:IMediatorMap;

		public function configure():void {
			mapMembership();
			mapView();
		}

		private function mapMembership():void {
			injector.map(IChatService).toSingleton(ChatService);
			injector.map(ChatModel).toSingleton(ChatModel);
			injector.map(ChatController).toSingleton(ChatController);
		}

		private function mapView():void
		{
			mediatorMap.map(ChatView).toMediator(ChatMediator);
			mediatorMap.map(ChatTabsView).toMediator(ChatTabsMediator);
			mediatorMap.map(ChatTabView).toMediator(ChatTabViewMediator);
		}
	}
}
