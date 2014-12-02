/**
 * Created by kvint on 07.11.14.
 */
package com.chat.events {
	public class CommunicatorEvent extends DataEvent {

		public static const UNREAD_UPDATED:String = "onUnreadUpdated";
		public static const ITEM_ADDED:String = "onItemAdded";
		public static const ITEM_REMOVED:String = "onItemRemoved";
		public static const ITEM_UPDATED:String = "onItemUpdated";
		public static const CHANGED:String = "onChanged";

		public function CommunicatorEvent(type:String, data:Object) {
			super(type, data, false, false);
		}
	}
}
