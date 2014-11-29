/**
 * Created by kvint on 29.11.14.
 */
package com.chat.signals {
	import com.chat.model.communicators.IWritableCommunicator;

	import org.osflash.signals.Signal;

	public class CommunicatorSignal extends Signal {
		public function CommunicatorSignal() {
			super(String, IWritableCommunicator, Array);
		}
	}
}
