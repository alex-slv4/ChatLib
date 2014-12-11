/**
 * Created by AlexanderSla on 11.12.2014.
 */
package com.chat.model.data.citems {
	import com.chat.model.communicators.DirectCommunicator;

	import org.igniterealtime.xiff.core.AbstractJID;

	public class CConversation extends CCommunicator implements ICConversation {
		public function CConversation(communicator:DirectCommunicator, startTime:Number = NaN) {
			super(communicator, startTime);
		}

		public function get withJID():AbstractJID {
			return (communicator as DirectCommunicator).participant;
		}

		override public function toString():String {
			return withJID.bareJID + " " + last.toString();
		}

		public function get last():ICItem {
			if(communicator.items.length)
				return communicator.items.getItemAt(communicator.items.length-1);
			return new CString("");
		}
	}
}
