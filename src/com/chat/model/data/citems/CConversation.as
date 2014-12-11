/**
 * Created by AlexanderSla on 11.12.2014.
 */
package com.chat.model.data.citems {
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.communicators.ICommunicator;

	import org.igniterealtime.xiff.core.AbstractJID;

	public class CConversation implements ICConversation {

		private var _communicator:DirectCommunicator;
		private var _startTime:Number;

		public function CConversation(communicator:DirectCommunicator, startTime:Number = NaN) {
			_communicator = communicator;
			_startTime = startTime;
		}

		public function get withJID():AbstractJID {
			return (communicator as DirectCommunicator).participant;
		}

		public function toString():String {
			return withJID.bareJID + " " + last.toString();
		}
		public function get communicator():ICommunicator {
			return _communicator;
		}
		public function get last():ICItem {
			if(communicator.items.length)
				return communicator.items.getItemAt(communicator.items.length-1);
			return new CItem("");
		}

		public function get time():Number {
			return _startTime;
		}

		public function get data():* {
			return _communicator;
		}
	}
}
