/**
 * Created by kvint on 02.11.14.
 */
package model.communicators {
	import model.CommunicatorTypes;

	import org.igniterealtime.xiff.core.UnescapedJID;

	public class DirectCommunicator extends DefaultCommunicator {

		private var _user:UnescapedJID;

		public function DirectCommunicator(user:UnescapedJID) {
			_user = user;
			_label = user.bareJID;
		}
		override public function get type():int {
			return CommunicatorTypes.DIRECT;
		}

		public function get user():UnescapedJID {
			return _user;
		}
	}
}
