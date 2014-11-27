/**
 * Created by kvint on 01.11.14.
 */
package com.chat.config {
	import com.chat.Chat;
	import com.chat.IChat;
	import com.chat.controller.ChatController;
	import com.chat.controller.IChatController;
	import com.chat.controller.commands.PresenceCommand;
	import com.chat.controller.commands.SyncTimeWithServerCommand;
	import com.chat.controller.commands.cm.ClearCMCommand;
	import com.chat.controller.commands.cm.HelpCMCommand;
	import com.chat.controller.commands.cm.InfoCMCommand;
	import com.chat.controller.commands.cm.CloseCMCommand;
	import com.chat.controller.commands.cm.TraceCMCommand;
	import com.chat.controller.commands.cm.message.MarkAsReadCMCommand;
	import com.chat.controller.commands.MessageCommand;
	import com.chat.controller.commands.cm.message.RetrieveHistoryCMCommand;
	import com.chat.controller.commands.cm.message.SendMessageStateCMCommand;
	import com.chat.controller.commands.cm.message.SendPrivateMessageCMCommand;
	import com.chat.controller.commands.cm.muc.RoomCMCommand;
	import com.chat.controller.commands.cm.muc.RoomCreateCMCommand;
	import com.chat.controller.commands.cm.muc.RoomInfoCMCommand;
	import com.chat.controller.commands.cm.muc.RoomJoinCMCommand;
	import com.chat.controller.commands.cm.muc.RoomLeaveCMCommand;
	import com.chat.controller.commands.cm.muc.SendRoomMessageCMCommand;
	import com.chat.controller.commands.cm.roster.AddUserCMCommand;
	import com.chat.controller.commands.cm.roster.RemoveUserCMCommand;
	import com.chat.controller.commands.cm.roster.RosterCMCommand;
	import com.chat.controller.commands.cm.roster.RosterInfoCommand;
	import com.chat.events.ChatEvent;
	import com.chat.events.CommunicatorCommandEvent;
	import com.chat.model.ChatModel;
	import com.chat.model.IChatModel;
	import com.chat.model.activity.Activities;
	import com.chat.model.activity.IActivities;
	import com.chat.model.activity.IActivitiesHandler;
	import com.chat.model.communicators.factory.CommunicatorFactory;
	import com.chat.model.communicators.factory.ICommunicatorFactory;
	import com.chat.model.presences.IPresences;
	import com.chat.model.presences.IPresencesHandler;
	import com.chat.model.presences.Presences;

	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.Presence;
	import org.igniterealtime.xiff.events.MessageEvent;
	import org.igniterealtime.xiff.events.PresenceEvent;

	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;

	public class ChatConfig implements IConfig {

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
			injector.map(IChat).toSingleton(Chat);
			injector.map(IChatModel).toSingleton(ChatModel);
			injector.map(IChatController).toSingleton(ChatController);
			injector.map(ICommunicatorFactory).toSingleton(CommunicatorFactory);

			var presences:Presences = new Presences();
			injector.map(IPresences).toValue(presences);
			injector.map(IPresencesHandler).toValue(presences);
			var activity:Activities = new Activities();
			injector.map(IActivities).toValue(activity);
			injector.map(IActivitiesHandler).toValue(activity);
		}
		private function mapCommands():void {
			//App commands
			commandMap.map(ChatEvent.SYNC_TIME).toCommand(SyncTimeWithServerCommand);
			commandMap.map(MessageEvent.MESSAGE).toCommand(MessageCommand);
			commandMap.map(PresenceEvent.PRESENCE).toCommand(PresenceCommand);

			//Communicator commands
			commandMap.map(CommunicatorCommandEvent.HISTORY).toCommand(RetrieveHistoryCMCommand);
			commandMap.map(CommunicatorCommandEvent.PRIVATE_MESSAGE).toCommand(SendPrivateMessageCMCommand);
			commandMap.map(CommunicatorCommandEvent.TRACE).toCommand(TraceCMCommand);
			commandMap.map(CommunicatorCommandEvent.CLEAR).toCommand(ClearCMCommand);
			commandMap.map(CommunicatorCommandEvent.HELP).toCommand(HelpCMCommand);

			commandMap.map(CommunicatorCommandEvent.ROOM).toCommand(RoomCMCommand);
			commandMap.map(CommunicatorCommandEvent.ROOM_INFO).toCommand(RoomInfoCMCommand);
			commandMap.map(CommunicatorCommandEvent.ROOM_CREATE).toCommand(RoomCreateCMCommand);
			commandMap.map(CommunicatorCommandEvent.ROOM_MESSAGE).toCommand(SendRoomMessageCMCommand);
			commandMap.map(CommunicatorCommandEvent.ROOM_JOIN).toCommand(RoomJoinCMCommand);
			commandMap.map(CommunicatorCommandEvent.ROOM_LEAVE).toCommand(RoomLeaveCMCommand);

			commandMap.map(CommunicatorCommandEvent.ROSTER).toCommand(RosterCMCommand);
			commandMap.map(CommunicatorCommandEvent.ROSTER_ADD).toCommand(AddUserCMCommand);
			commandMap.map(CommunicatorCommandEvent.ROSTER_REMOVE).toCommand(RemoveUserCMCommand);
			commandMap.map(CommunicatorCommandEvent.ROSTER_INFO).toCommand(RosterInfoCommand);

			commandMap.map(CommunicatorCommandEvent.SEND_MESSAGE_STATE).toCommand(SendMessageStateCMCommand);
			commandMap.map(CommunicatorCommandEvent.MARK_AS_RECEIVED).toCommand(MarkAsReadCMCommand);
			commandMap.map(CommunicatorCommandEvent.INFO).toCommand(InfoCMCommand);
			commandMap.map(CommunicatorCommandEvent.CLOSE).toCommand(CloseCMCommand);
		}

		private function mapView():void {
//			mediatorMap.map(HistoryCommunicatorView).toMediator(HistoryCommunicatorMediator);
			//mediatorMap.map(TeamCommunicatorView).toMediator(TeamCommunicatorMediator);
			//mediatorMap.map(GlobalCommunicatorView).toMediator(GlobalCommunicatorMediator);

		}
	}
}
