/**
 * Created by kvint on 02.11.14.
 */
package view.communicator {
	import feathers.data.ListCollection;

	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.events.MessageEvent;

	public class HistoryCommunicatorMediator extends DefaultCommunicatorMediator {

		override public function initializeComplete():void {
			super.initializeComplete();
			historyView.list.itemRendererProperties.labelField = "body";
			historyView.list.itemRendererProperties.labelFunction = function(item:Object):String {
				return item.from.node + ": "+ item.body;
			};
			communicatorData.addEventListener(MessageEvent.MESSAGE, onNewMessage);
			initHistory();
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
			super.destroy();
		}
	}
}
