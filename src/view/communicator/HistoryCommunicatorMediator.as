/**
 * Created by kvint on 02.11.14.
 */
package view.communicator {
	import controller.ChatController;

	import events.ChatEvent;

	import feathers.data.ListCollection;
	import feathers.events.CollectionEventType;

	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.events.MessageEvent;

	import starling.events.Event;

	public class HistoryCommunicatorMediator extends DefaultCommunicatorMediator {

		[Inject]
		public var chatController:ChatController;

		override public function initializeComplete():void {
			super.initializeComplete();
			historyView.list.itemRendererProperties.labelFunction = function(item:Message):String {
				return (item.receipt == null ? "" : item.from.node + ": ") + item.body;
			};
			communicatorData.addEventListener(MessageEvent.MESSAGE, onNewMessage);
			chatModel.addEventListener(ChatEvent.ON_MESSAGE_READ, onMessageRead);
			initHistory();
		}

		private function onMessageRead(event:ChatEvent):void {
			var itemIndex:int = historyView.list.dataProvider.getItemIndex(event.data);
			historyView.list.dataProvider.updateItemAt(itemIndex);
		}

		protected function onNewMessage(event:MessageEvent):void {
			var message:Message = event.data as Message;
			markMessageAsReceived(message);
			historyView.list.dataProvider.dispatchEventWith(Event.CHANGE);
			//addToHistory(message);
		}

		protected function markMessageAsReceived(message:Message):void {
			communicatorData.markAsRead(message);
			chatController.markMessageAsReceived(message);
		}

		protected function addToHistory(message:Message):void {
			var index:int = historyView.list.dataProvider.getItemIndex(message);
			historyView.list.dataProvider.updateItemAt(index);
		}
		protected function initHistory():void {
			var history:Array = communicatorData.history;
			historyView.list.dataProvider = new ListCollection(history);
			for each (var message:Message in history) {
				markMessageAsReceived(message);
			}
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
