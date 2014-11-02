/**
 * Created by kvint on 02.11.14.
 */
package events {
	public class CommunicatorEvent extends DataEvent {

		public static const CHANGE:String = "onChange";

		public function CommunicatorEvent(type:String, data:Object) {
			super(type, data);
		}
	}
}
