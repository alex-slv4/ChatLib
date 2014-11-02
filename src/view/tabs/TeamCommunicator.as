/**
 * Created by kvint on 02.11.14.
 */
package view.tabs {
	import model.CommunicatorTypes;
	import model.DefaultCommunicator;

	public class TeamCommunicator extends DefaultCommunicator {
		public function TeamCommunicator() {
			_label = "Team";
		}

		override public function get type():int {
			return CommunicatorTypes.TEAM;
		}
	}
}
