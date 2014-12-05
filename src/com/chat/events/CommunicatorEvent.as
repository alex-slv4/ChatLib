/**
 * Created by kvint on 07.11.14.
 */
package com.chat.events {
	public class CommunicatorEvent extends DataEvent {

		public static const UNREAD_UPDATED:String = "onUnreadUpdated";

		public function CommunicatorEvent(type:String, data:Object) {
			super(type, data, false, false);
		}
	}
}
