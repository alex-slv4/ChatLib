/**
 * Created by kvint on 02.11.14.
 */
package com.chat.events {
	public class CommunicatorFactoryEvent extends DataEvent {

		public static const COMMUNICATOR_ADDED:String = "onCommunicatorAdded";
		public static const COMMUNICATOR_ACTIVATED:String = "onCommunicatorActivated";
		public static const COMMUNICATOR_DEACTIVATED:String = "onCommunicatorDeactivated";
		public static const COMMUNICATOR_DESTROYED:String = "onCommunicatorDestroyed";

		public function CommunicatorFactoryEvent(type:String, data:Object) {
			super(type, data);
		}
	}
}
