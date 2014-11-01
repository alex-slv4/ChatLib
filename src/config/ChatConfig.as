/**
 * Created by kvint on 01.11.14.
 */
package config {
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;

	import view.ChatView;
	import view.ChatMediator;

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
		}

		private function mapView():void
		{
			mediatorMap.map(ChatView).toMediator(ChatMediator);
		}
	}
}
