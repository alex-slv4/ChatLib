/**
 * Created by AlexanderSla on 11.11.2014.
 */
package model.communicators {
	public class RoomCommunicator extends DefaultCommunicator {

		private var _name:String;

		public function RoomCommunicator(name:String) {
			_name = name;
		}
	}
}
