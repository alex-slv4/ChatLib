/**
 * Created by kvint on 02.12.14.
 */
package com.chat.controller.commands {
	import com.chat.controller.IChatController;
	import com.chat.model.IChatModel;
	import com.chat.model.communicators.IConversationsCommunicator;
	import com.chat.model.data.CItemConversation;
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

		[Inject]
		public var conversations:IConversationsCommunicator;

		private var _chatStepper:ISetLooper = new OFSetLooper(4);

		public function execute():void {

			var previous:RSMSet = _chatStepper.previous;
			if(previous){
				var listStanza:List = new List();
				var listIQ:IQ = new IQ(null, IQ.TYPE_GET);
				listIQ.callback = listCallback;
				listIQ.errorCallback = listErrorCallback;
				listIQ.addExtension(listStanza);
				listStanza.addExtension(previous);

				controller.send(listIQ);
			}
			trace(new Error().getStackTrace());
		}

		private function listCallback(iq:IQ):void {
			var _list:List = iq.getExtension(List.ELEMENT_NAME) as List;
			var rsmSet:RSMSet = _list.getExtension(RSMSet.ELEMENT_NAME) as RSMSet;
			for (var i:int = 0; i < _list.chats.length; i++) {
				var chat:ChatStanza = _list.chats[i];
				var date:Date = DateTimeParser.string2dateTime(chat.start);
				var conversation:CItemConversation = new CItemConversation(chat.withJID, date.getTime());
				conversations.push(conversation);
			}

			_chatStepper.pin(rsmSet);
			execute();
		}
		private function listErrorCallback(iq:IQ):void {
			throw new Error("listErrorCallback");

		}
	}
}
