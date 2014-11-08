/**
 * Created by kvint on 02.11.14.
 */
package events {
	public class ChatModelEvent extends DataEvent {

		public static const COMMUNICATOR_ADDED:String = "onCommunicatorAdded";
		public static const COMMUNICATOR_ACTIVATED:String = "onCommunicatorActivated";
		public static const COMMUNICATOR_REMOVED:String = "onCommunicatorRemoved";

		public function ChatModelEvent(type:String, data:Object) {
			super(type, data);
		}
	}
}
