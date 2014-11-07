/**
 * Created by kvint on 01.11.14.
 */
package config {
	import controller.ChatController;

	import model.ChatModel;
	import model.communicators.CommunicatorProvider;
	import model.communicators.ICommunicatorProvider;

	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;

	import view.ChatMediator;
	import view.ChatView;
	import view.communicator.DefaultCommunicatorMediator;
	import view.communicator.DirectCommunicatorMediator;
	import view.communicator.DirectCommunicatorView;
	import view.communicator.ICommunicatorView;
	import view.communicator.HistoryCommunicatorMediator;
	import view.communicator.HistoryCommunicatorView;
	import view.communicator.WritableCommunicatorMediator;
	import view.roster.RosterMediator;
	import view.roster.RosterView;
	import view.tabs.ChatTabView;
	import view.tabs.ChatTabMediator;
	import view.tabs.ChatTabsMediator;
	import view.tabs.communicatorsTabsView;

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
			injector.map(ICommunicatorProvider).toSingleton(CommunicatorProvider);
		}

		private function mapView():void
		{
			mediatorMap.map(ChatView).toMediator(ChatMediator);
			mediatorMap.map(communicatorsTabsView).toMediator(ChatTabsMediator);
			mediatorMap.map(ChatTabView).toMediator(ChatTabMediator);
			mediatorMap.map(DirectCommunicatorView).toMediator(DirectCommunicatorMediator);
			mediatorMap.map(RosterView).toMediator(RosterMediator);
			//mediatorMap.map(HistoryCommunicatorView).toMediator(HistoryCommunicatorMediator);
			//mediatorMap.map(TeamCommunicatorView).toMediator(TeamCommunicatorMediator);
			//mediatorMap.map(GlobalCommunicatorView).toMediator(GlobalCommunicatorMediator);

		}
	}
}
