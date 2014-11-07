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

	import view.chat.ChatMediator;
	import view.chat.ChatView;
	import view.chat.communicator.types.DefaultCommunicatorMediator;
	import view.chat.communicator.types.DirectCommunicatorMediator;
	import view.chat.communicator.types.DirectCommunicatorView;
	import view.chat.communicator.ICommunicatorView;
	import view.chat.communicator.types.HistoryCommunicatorMediator;
	import view.chat.communicator.types.HistoryCommunicatorView;
	import view.chat.communicator.types.WritableCommunicatorMediator;
	import view.chat.roster.RosterMediator;
	import view.chat.roster.RosterView;
	import view.chat.tabs.CommunicatorTabView;
	import view.chat.tabs.CommunicatorTabMediator;
	import view.chat.tabs.CommunicatorsTabsMediator;
	import view.chat.tabs.CommunicatorsTabsView;

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
			injector.map(Chat).toSingleton(ChatClient);
			injector.map(ChatModel).toSingleton(ChatModel);
			injector.map(ChatController).toSingleton(ChatController);
			injector.map(ICommunicatorProvider).toSingleton(CommunicatorProvider);
		}

		private function mapView():void
		{
			mediatorMap.map(ChatView).toMediator(ChatMediator);
			mediatorMap.map(CommunicatorsTabsView).toMediator(CommunicatorsTabsMediator);
			mediatorMap.map(CommunicatorTabView).toMediator(CommunicatorTabMediator);
			mediatorMap.map(DirectCommunicatorView).toMediator(DirectCommunicatorMediator);
			mediatorMap.map(RosterView).toMediator(RosterMediator);
			//mediatorMap.map(HistoryCommunicatorView).toMediator(HistoryCommunicatorMediator);
			//mediatorMap.map(TeamCommunicatorView).toMediator(TeamCommunicatorMediator);
			//mediatorMap.map(GlobalCommunicatorView).toMediator(GlobalCommunicatorMediator);

		}
	}
}
