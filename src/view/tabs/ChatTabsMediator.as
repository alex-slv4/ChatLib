/**
 * Created by kvint on 01.11.14.
 */
package view.tabs {
	import events.ChatEvent;

	import feathers.data.ListCollection;

	import model.BaseCommunicator;

	import model.ChatModel;
	import model.ICommunicator;

	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.events.MessageEvent;

	import robotlegs.extensions.starlingFeathers.impl.FeathersMediator;

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
			chatModel.addEventListener(MessageEvent.MESSAGE, onNewMessage);
			chatModel.addEventListener(ChatEvent.NEW_CONVERSATION, onNewConversation);
		}

		private function onNewConversation(event:ChatEvent):void {
			var message:Message = event.data as Message;
			view.dataProvider.addItem(message.from.bareJID);
		}

		private function onNewMessage(event:MessageEvent):void {

		}
	}
}
