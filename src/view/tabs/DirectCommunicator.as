/**
 * Created by kvint on 02.11.14.
 */
package view.tabs {
	import model.CommunicatorTypes;
	import model.DefaultCommunicator;

	import org.igniterealtime.xiff.core.AbstractJID;

	public class DirectCommunicator extends DefaultCommunicator {
		public function DirectCommunicator(user:AbstractJID) {
			_label = user.bareJID;
		}
		override public function get type():int {
			return CommunicatorTypes.DIRECT;
		}
	}
}
