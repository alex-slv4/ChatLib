/**
 * Created by kvint on 01.11.14.
 */
package view.tabs {
	import events.ChatEvent;
	import events.ChatModelEvent;

	import feathers.data.ListCollection;

	import model.ChatModel;
	import model.communicators.GlobalCommunicator;
	import model.communicators.ICommunicator;
	import model.communicators.LogCommunicator;
	import model.communicators.TeamCommunicator;

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
			chatModel.addEventListener(ChatModelEvent.COMMUNICATOR_ADDED, onCommunicatorAdded);
			onTabSelected();
		}

		private function onTabSelected():void {
			var communicator:ICommunicator = view.selectedItem as ICommunicator;
			chatModel.dispatchEvent(new ChatModelEvent(ChatModelEvent.COMMUNICATOR_ACTIVATED, communicator));
		}

		private function onCommunicatorAdded(event:ChatModelEvent):void {
			view.dataProvider.addItem(event.data);
		}

		override public function destroy():void {
			chatModel.removeEventListener(ChatModelEvent.COMMUNICATOR_ADDED, onCommunicatorAdded);//TODO: remove events
			super.destroy();
		}
	}
}
