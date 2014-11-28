/**
 * Created by AlexanderSla on 28.11.2014.
 */
package com.chat.controller.commands.cm.message {
	import com.chat.controller.commands.cm.CMCommand;
	import com.chat.model.communicators.IWritableCommunicator;

	import org.igniterealtime.xiff.data.Message;

	public class SendMessageBaseCommand extends CMCommand {

		protected function send(message:Message):void {
			//append thread
			appendThread(message);

			//send data
			controller.send(message);
		}

		protected function appendThread(message:Message):void {
			if(communicator is IWritableCommunicator) {
				var writable:IWritableCommunicator = communicator as IWritableCommunicator;
				if(writable.thread == null) {
					writable.thread = model.threadGenerator.generateID();
				}
				message.thread = writable.thread;
			}
		}
	}
}
