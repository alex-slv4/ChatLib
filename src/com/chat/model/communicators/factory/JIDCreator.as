/**
 * Created by AlexanderSla on 11.12.2014.
 */
package com.chat.model.communicators.factory {
	import com.chat.model.IChatModel;
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.communicators.ICommunicator;

	import org.igniterealtime.xiff.core.AbstractJID;
	import org.igniterealtime.xiff.util.JIDUtil;

	public class JIDCreator implements ICreator {

		[Inject]
		public var model:IChatModel;

		private var _jid:AbstractJID;

		public function JIDCreator(jid:AbstractJID) {
			_jid = jid;
		}

		public function get uid():String {
			return _jid.bareJID;
		}

		public function create():ICommunicator {
			return new DirectCommunicator(JIDUtil.unescape(_jid), model.currentUser);
		}
	}
}
