/**
 * Created by kvint on 02.11.14.
 */
package com.chat.events {
	public class CommunicatorFactoryEvent extends DataEvent {

		//TODO: think about...
		public static const COMMUNICATOR_ACTIVATED:String = "onCommunicatorActivated";
		public static const COMMUNICATOR_DEACTIVATED:String = "onCommunicatorDeactivated";

		public function CommunicatorFactoryEvent(type:String, data:Object) {
			super(type, data);
		}
	}
}
