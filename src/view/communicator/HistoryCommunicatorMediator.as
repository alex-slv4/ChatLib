/**
 * Created by kvint on 02.11.14.
 */
package view.communicator {
	import controller.ChatController;

	import events.ChatEvent;

	import feathers.data.ListCollection;
	import feathers.events.CollectionEventType;

	import flash.utils.setTimeout;

	import model.data.ChatMessage;

	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.events.MessageEvent;

	import starling.events.Event;

	import utils.MessageUtils;

	public class HistoryCommunicatorMediator extends DefaultCommunicatorMediator {

		[Inject]
		public var chatController:ChatController;

		override public function initializeComplete():void {
			super.initializeComplete();
			historyView.list.itemRendererProperties.labelFunction = function(item:ChatMessage):String {
				var str:String = "";
				if(!item.read){
					str += "! "
				}
				str += item.from.node + ": " + item.body;
				return str;
			};
			communicatorData.addEventListener(MessageEvent.MESSAGE, onNewMessage);
			chatModel.addEventListener(ChatEvent.ON_MESSAGE_READ, onMessageRead);
			initHistory();
		}
		protected function initHistory():void {
			var history:Array = communicatorData.history.concat();
			for (var i:int = 0; i < history.length; i++) {
				var message:ChatMessage = history[i];
				markMessageAsReceived(message);
			}
			historyView.list.dataProvider = new ListCollection(history);
		}

		private function onMessageRead(event:ChatEvent):void {
			var itemIndex:int = historyView.list.dataProvider.getItemIndex(event.data);
			historyView.list.dataProvider.updateItemAt(itemIndex);
		}

		protected function onNewMessage(event:MessageEvent):void {
			var message:ChatMessage = event.data as ChatMessage;
			markMessageAsReceived(message);
			addToHistory(message);
		}

		protected function markMessageAsReceived(message:ChatMessage):void {
			chatController.markMessageAsReceived(message);
			communicatorData.markAsRead(message);
		}

		protected function addToHistory(message:Message):void {
			historyView.list.dataProvider.addItem(message);
		}
		protected function get historyView():HistoryCommunicatorView{
			return view as HistoryCommunicatorView;
		}

		override public function destroy():void {
			communicatorData.removeEventListener(MessageEvent.MESSAGE, onNewMessage);
			chatModel.removeEventListener(ChatEvent.ON_MESSAGE_READ, onMessageRead);
			super.destroy();
		}
	}
}
