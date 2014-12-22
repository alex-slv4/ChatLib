/**
 * Created by kvint on 02.12.14.
 */
package com.chat.controller.commands {
	import com.chat.controller.IChatController;
	import com.chat.model.IChatModel;
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.communicators.ICommunicator;
	import com.chat.model.data.citems.CConversation;
	import com.chat.model.data.citems.ICConversation;
	import com.chat.utils.OFSetLooper;

	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.archive.ChatStanza;
	import org.igniterealtime.xiff.data.archive.List;
	import org.igniterealtime.xiff.data.rsm.RSMSet;
	import org.igniterealtime.xiff.setmanagement.ISetLooper;
	import org.igniterealtime.xiff.util.DateTimeParser;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	public class LoadConversationsCommand implements ICommand {

		[Inject]
		public var model:IChatModel;

		[Inject]
		public var controller:IChatController;

		private var _chatStepper:ISetLooper = new OFSetLooper(50);
		private static var CONVERSATIONS_LOADED:Boolean = false;

		public function execute():void {
			if(CONVERSATIONS_LOADED) return;
			var previous:RSMSet = _chatStepper.getPrevious();
			if(previous){
				var listStanza:List = new List();
				var listIQ:IQ = new IQ(null, IQ.TYPE_GET);
				listIQ.callback = listCallback;
				listIQ.errorCallback = listErrorCallback;
				listIQ.addExtension(listStanza);
				listStanza.addExtension(previous);

				controller.send(listIQ);
			}else{
				CONVERSATIONS_LOADED = true;
				model.conversations.fetchLasts();
			}
		}

		private function listCallback(iq:IQ):void {
			var _list:List = iq.getExtension(List.ELEMENT_NAME) as List;
			var rsmSet:RSMSet = _list.getExtension(RSMSet.ELEMENT_NAME) as RSMSet;
			for (var i:int = 0; i < _list.chats.length; i++) {
				var chat:ChatStanza = _list.chats[i];
				var communicator:ICommunicator = model.communicators.getFor(chat.withJID);
				if(!(communicator is DirectCommunicator)) continue;

				var date:Date = DateTimeParser.string2dateTime(chat.start);
				var conversation:ICConversation = new CConversation(communicator as DirectCommunicator, date.getTime());
				model.conversations.updateWith(conversation);
			}

			_chatStepper.pin(rsmSet);
			execute();
		}
		private function listErrorCallback(iq:IQ):void {
			throw new Error("listErrorCallback");

		}
	}
}
