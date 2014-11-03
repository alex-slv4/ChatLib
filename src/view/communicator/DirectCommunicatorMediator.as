/**
 * Created by kvint on 02.11.14.
 */
package view.communicator {
	import events.ChatEvent;

	import model.communicators.DirectCommunicator;

	import org.igniterealtime.xiff.data.Message;

	public class DirectCommunicatorMediator extends WritableCommunicatorMediator{
		public function DirectCommunicatorMediator() {
		}

		protected function get directCommunicatorData():DirectCommunicator {
			return communicatorData as DirectCommunicator;
		}
		override protected function onSend():void {
			var message:Message = new Message(directCommunicatorData.user.escaped);
			message.type = Message.TYPE_CHAT;
			message.from = chatModel.currentUser.jid.escaped;
			message.body = writableView.input.text;
			chatModel.dispatchEvent(new ChatEvent(ChatEvent.SEND_MESSAGE, message));
			writableView.input.text = "";
			addToHistory(message);
		}
	}
}
