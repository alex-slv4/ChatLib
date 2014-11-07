/**
 * Created by kvint on 02.11.14.
 */
package view.chat.communicator.types {
import view.chat.communicator.*;
	import events.ChatEvent;

	import model.communicators.DirectCommunicator;
	import model.communicators.ICommunicator;
	import model.data.ChatMessage;

	import org.igniterealtime.xiff.data.Message;

	public class DirectCommunicatorMediator extends WritableCommunicatorMediator{
		public function DirectCommunicatorMediator() {
		}

		protected function get directCommunicatorData():DirectCommunicator {
			return communicatorData as DirectCommunicator;
		}
		override protected function onSend():void {
			var message:ChatMessage = new ChatMessage(directCommunicatorData.participant.escaped);
			message.type = Message.TYPE_CHAT;
			message.from = chatModel.currentUser.jid.escaped;
			message.body = writableView.input.text;
			var iCommunicator:DirectCommunicator = chatModel.provider.getCommunicator(message) as DirectCommunicator;
			iCommunicator.sendMessage(message);
			writableView.input.text = "";
		}
	}
}
