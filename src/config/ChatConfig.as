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
//			mediatorMap.map(HistoryCommunicatorView).toMediator(HistoryCommunicatorMediator);
			//mediatorMap.map(TeamCommunicatorView).toMediator(TeamCommunicatorMediator);
			//mediatorMap.map(GlobalCommunicatorView).toMediator(GlobalCommunicatorMediator);

		}
	}
}
