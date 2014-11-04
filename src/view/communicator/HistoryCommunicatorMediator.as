/**
 * Created by kvint on 02.11.14.
 */
package view.communicator {
	import events.ChatEvent;

	import feathers.data.ListCollection;

	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.events.MessageEvent;

	public class HistoryCommunicatorMediator extends DefaultCommunicatorMediator {

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
			addToHistory(event.data as Message);
		}

		protected function addToHistory(message:Message):void {
			historyView.list.dataProvider.addItem(message);
		}
		protected function initHistory():void {
			historyView.list.dataProvider = new ListCollection(communicatorData.history.concat());
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
