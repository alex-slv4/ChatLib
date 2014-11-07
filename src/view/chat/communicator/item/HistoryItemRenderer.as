/**
 * Created by kvint on 02.11.14.
 */
package view.chat.communicator.item {
	import feathers.controls.renderers.DefaultListItemRenderer;

	public class HistoryItemRenderer extends DefaultListItemRenderer {
		public function HistoryItemRenderer() {
			super();
		}

		override protected function initialize():void {
			super.initialize();
			this.labelField = "body";
			this.labelFunction = function(item:Object):String {
				return item.body;
			}
		}
	}
}
