/**
 * Created by kvint on 01.11.14.
 */
package config {
	import controller.ChatController;
	import controller.commands.ClearCMCommand;
	import controller.commands.SendPrivateMessageCMCommand;
	import controller.commands.RoomCreateCMCommand;
	import controller.commands.TraceCMCommand;

	import events.CMEvent;

	import model.ChatModel;
	import model.communicators.CommunicatorProvider;
	import model.communicators.ICommunicatorProvider;

	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;

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

		[Inject]
		public var commandMap:IEventCommandMap;

		public function configure():void {
			mapMembership();
			mapView();
			mapCommands();
		}


		private function mapMembership():void {
			injector.map(Chat).toSingleton(ChatClient);
			injector.map(ChatModel).toSingleton(ChatModel);
			injector.map(ChatController).toSingleton(ChatController);
			injector.map(ICommunicatorProvider).toSingleton(CommunicatorProvider);
		}
		private function mapCommands():void {
			commandMap.map(CMEvent.MESSAGE).toCommand(SendPrivateMessageCMCommand);
			commandMap.map(CMEvent.TRACE).toCommand(TraceCMCommand);
			commandMap.map(CMEvent.CLEAR).toCommand(ClearCMCommand);
			commandMap.map(CMEvent.CREATE_ROOM).toCommand(RoomCreateCMCommand);
		}

		private function mapView():void {
//			mediatorMap.map(HistoryCommunicatorView).toMediator(HistoryCommunicatorMediator);
			//mediatorMap.map(TeamCommunicatorView).toMediator(TeamCommunicatorMediator);
			//mediatorMap.map(GlobalCommunicatorView).toMediator(GlobalCommunicatorMediator);

		}
	}
}
