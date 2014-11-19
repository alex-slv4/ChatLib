/**
 * Created by AlexanderSla on 19.11.2014.
 */
package com.chat.model.communicators.factory {
	import com.chat.model.ChatModel;
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.communicators.ICommunicator;

	import org.igniterealtime.xiff.data.im.RosterItemVO;

	public class RosterItemCreator implements ICreator {

		[Inject]
		public var model:ChatModel;

		private var _rosterItem:RosterItemVO;

		public function RosterItemCreator(item:RosterItemVO) {
			_rosterItem = item;
		}

		public function get uid():String {
			return _rosterItem.jid.toString();
		}

		public function create():ICommunicator {
			return new DirectCommunicator(_rosterItem.jid, model.currentUser);
		}
	}
}
