/**
 * Created by kvint on 02.11.14.
 */
package events {
	public class ChatModelEvent extends DataEvent {

		public static const COMMUNICATOR_ADDED:String = "onAdded";
		public static const COMMUNICATOR_ACTIVATED:String = "onActivate";

		public function ChatModelEvent(type:String, data:Object) {
			super(type, data);
		}
	}
}
