/**
 * Created by kvint on 01.11.14.
 */
package view.tabs {
	import events.ChatEvent;
	import events.CommunicatorEvent;

	import feathers.data.ListCollection;

	import model.ChatModel;
	import model.communicators.DirectCommunicator;
	import model.communicators.GlobalCommunicator;
	import model.communicators.ICommunicator;
	import model.communicators.LogCommunicator;
	import model.communicators.TeamCommunicator;

	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.events.MessageEvent;

	import robotlegs.extensions.starlingFeathers.impl.FeathersMediator;

	import starling.events.Event;

	public class ChatTabsMediator extends FeathersMediator {

		private var view:ChatTabsView;

		[Inject]
		public var chatModel:ChatModel;

		override public function initializeComplete():void {
			super.initializeComplete();
			view = viewComponent as ChatTabsView;

			view.tabFactory = function():ChatTabView{
				return new ChatTabView();
			};

			view.tabInitializer = function(tab:ChatTabView, data:ICommunicator):ChatTabView{
				tab.provider.data = data;
				tab.label = data.label; //FIXME: feathers bug?
			};

			view.dataProvider = new ListCollection([
				new LogCommunicator(),
				new GlobalCommunicator(),
				new TeamCommunicator(),
			]);
			mapStarlingEvent(view, Event.CHANGE, onTabSelected);
			chatModel.addEventListener(MessageEvent.MESSAGE, onNewMessage);
			chatModel.addEventListener(ChatEvent.NEW_CONVERSATION, onNewConversation);
			onTabSelected();
		}

		private function onTabSelected():void {
			var communicator:ICommunicator = view.selectedItem as ICommunicator;
			chatModel.dispatchEvent(new CommunicatorEvent(CommunicatorEvent.CHANGE, communicator));
		}

		private function onNewConversation(event:ChatEvent):void {
			view.dataProvider.addItem(event.data);
		}

		private function onNewMessage(event:MessageEvent):void {

		}
	}
}
