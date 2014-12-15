/**
 * Created by AlexanderSla on 11.12.2014.
 */
package com.chat.model.data.citems {
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.communicators.ICommunicator;
	import com.chat.model.data.citems.CTime;

	import org.igniterealtime.xiff.core.AbstractJID;

	public class CConversation extends CTime implements ICConversation {

		private var _communicator:DirectCommunicator;

		public function CConversation(communicator:DirectCommunicator, startTime:Number = NaN) {
			super(communicator);
			_communicator = communicator;
			originTime = startTime;
		}

		public function get withJID():AbstractJID {
			return (communicator as DirectCommunicator).participant;
		}

		public function get communicator():ICommunicator {
			return _communicator;
		}
		public function get last():ICItem {
			if(communicator.items.length)
				return communicator.items.getItemAt(communicator.items.length-1);
			return new CItem("");
		}

		override public function get data():* {
			return _communicator;
		}
		override public function toString():String {
			return withJID.bareJID + " " + last.toString();
		}
	}
}
