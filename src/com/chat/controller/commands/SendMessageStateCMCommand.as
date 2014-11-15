/**
 * Created by kvint on 15.11.14.
 */
package com.chat.controller.commands {
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.communicators.RoomCommunicator;

	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import org.igniterealtime.xiff.data.Message;

	public class SendMessageStateCMCommand extends CMCommand {

		private static const COMPOSING_DELAY:uint = 2500;
		private static const PAUSED_DELAY:uint = 10000;

		public static var STATE_TIMER_ID:uint;

		override protected function executeIfNoErrors():void {
			var state:String = params[0];
			switch (state){

				case Message.STATE_COMPOSING:
					//send composing and start timer
					clearTimeout(STATE_TIMER_ID);
					sendState(Message.STATE_COMPOSING);
					STATE_TIMER_ID = setTimeout(sendState, PAUSED_DELAY, Message.STATE_PAUSED);
					break;

				case Message.STATE_PAUSED:
					//send paused and start timer
					clearTimeout(STATE_TIMER_ID);
					STATE_TIMER_ID = setTimeout(sendState, PAUSED_DELAY, Message.STATE_PAUSED);
					break;

				case Message.STATE_ACTIVE:
					//send active
					sendState(Message.STATE_ACTIVE);
				case Message.STATE_GONE:
					//send gone
					sendState(Message.STATE_GONE);
				case Message.STATE_INACTIVE:
				default:
					//send inactive
					sendState(Message.STATE_INACTIVE);
			}
		}

		private function sendState(state:String):void {
			var message:Message = new Message();
			message.state = state;
			message.from = model.currentUser.jid.escaped;

			if(directCommunicator){
				message.to = directCommunicator.participant.escaped;
				message.type = Message.TYPE_CHAT;
			}else if (roomCommunicator){
				message.to = roomCommunicator.chatRoom.room.roomJID.escaped;
				message.type = Message.TYPE_GROUPCHAT;
			}

			clearTimeout(STATE_TIMER_ID);
			if(state == Message.STATE_COMPOSING){
				STATE_TIMER_ID = setTimeout(sendState, COMPOSING_DELAY, Message.STATE_PAUSED);
			}else if(state == Message.STATE_PAUSED){
				STATE_TIMER_ID = setTimeout(sendState, PAUSED_DELAY, Message.STATE_ACTIVE);
			}
			controller.connection.send(message);
		}

		private function get roomCommunicator():RoomCommunicator {
			return communicator as RoomCommunicator;
		}

		private function get directCommunicator():DirectCommunicator {
			return communicator as DirectCommunicator;
		}
	}
}
