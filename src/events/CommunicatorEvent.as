/**
 * Created by kvint on 07.11.14.
 */
package events {
	public class CommunicatorEvent extends DataEvent {

		public static const UNREAD_UPDATED:String = "onUnreadUpdated";
		public static const ITEM_ADDED:String = "onItemAdded";
		public static const ITEM_RECEIPT_REPLIED:String = "onItemReceiptReplied";
		public static const ITEM_SENT:String = "onItemSent";
		public static const ITEM_UPDATED:String = "onItemUpdated";

		public function CommunicatorEvent(type:String, data:Object) {
			super(type, data, false, false);
		}
	}
}
