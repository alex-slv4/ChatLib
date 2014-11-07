/**
 * Created by kvint on 07.11.14.
 */
package events {
	public class CommunicatorEvent extends DataEvent {

		public static const ITEM_ADDED:String = "onItemAdded";
		public static const ITEM_UPDATED:String = "onItemUpdated";

		public function CommunicatorEvent(type:String, data:Object) {
			super(type, data, false, false);
		}
	}
}
