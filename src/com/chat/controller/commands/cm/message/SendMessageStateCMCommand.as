/**
 * Created by kvint on 15.11.14.
 */
package com.chat.controller.commands.cm.message {
	import com.chat.controller.commands.cm.CMCommand;
	import com.chat.events.CommunicatorFactoryEvent;
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.communicators.RoomCommunicator;
	import com.chat.model.communicators.WritableCommunicator;

	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import org.igniterealtime.xiff.data.Message;

	public class SendMessageStateCMCommand extends CMCommand {

		private static const PAUSED_DELAY:uint = 7000;

		public static var STATE_TIMER_ID:uint;

		override protected function executeIfNoErrors():void {
			var state:String = params[0];
			if(communicator) {
				sendState(state);
			}
		}

		override protected function tearDown():void {

		}

		private function sendState(state:String):void {

			clearTimeout(STATE_TIMER_ID);
			if(communicator == null) return;

			var message:Message = new Message();
			message.state = state;
			message.from = model.currentUser.jid.escaped;

			if(directCommunicator){
				message.to = directCommunicator.participant.escaped;
				message.type = Message.TYPE_CHAT;
			}else if (roomCommunicator && roomCommunicator.chatRoom.room.roomJID){
				message.to = roomCommunicator.chatRoom.room.roomJID.escaped;
				message.type = Message.TYPE_GROUPCHAT;
			}

			if(state == Message.STATE_COMPOSING) {
				STATE_TIMER_ID = setTimeout(function():void{
					if(writableCommunicator){
						writableCommunicator.state = Message.STATE_PAUSED;
					}
				}, PAUSED_DELAY);
			}
			controller.send(message);
		}

		private function get writableCommunicator():WritableCommunicator {
			return communicator as WritableCommunicator;
		}

		private function get roomCommunicator():RoomCommunicator {
			return communicator as RoomCommunicator;
		}

		private function get directCommunicator():DirectCommunicator {
			return communicator as DirectCommunicator;
		}

	}
}
