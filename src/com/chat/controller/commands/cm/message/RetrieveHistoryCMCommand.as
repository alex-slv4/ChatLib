/**
 * Created by kvint on 16.11.14.
 */
package com.chat.controller.commands.cm.message {
	import com.chat.controller.commands.cm.CMCommand;
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.communicators.ICommunicator;
	import com.chat.model.data.ICItem;
	import com.chat.model.history.ConversationsProvider;

	import flash.utils.setTimeout;

	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.archive.archive_internal;

	import robotlegs.bender.framework.api.IInjector;

	use namespace archive_internal;

	public class RetrieveHistoryCMCommand extends CMCommand {

		[Inject]
		public var injector:IInjector;

		override protected function executeIfNoErrors():void {
			directCommunicator.history.fetchNext(onHistoryLoaded);
		}

		private function onHistoryLoaded(items:Vector.<ICItem>):void {
			for (var i:int = 0; i < items.length; i++) {
				directCommunicator.push(items[i]);
			}
			setTimeout(directCommunicator.history.fetchNext, 10, arguments.callee);
		}

		private function get castedCommunicator():ICommunicator {
			return communicator as ICommunicator;
		}
		/*override protected function executeIfNoErrors():void {
			var listIQ:IQ = new IQ(null, IQ.TYPE_GET);
			listIQ.callback = iqCallback;
			listIQ.errorCallback = iqErrorCallback;

			var stanza:List = new List();
//			if (params.length > 0) {
//				var restrictions:RSMSet = new RSMSet();
//				restrictions.max = params[0];
//				restrictions.after = "176";
//			}
			var step:int = params.length > 0 ? params[0] : 1;
			stanza.addExtension(rsmStepper.getNext(step));
			stanza.withJID = directCommunicator.participant.escaped;
			listIQ.addExtension(stanza);
			controller.connection.send(listIQ);
		}
		private function iqCallback(iq:IQ):void {
			var historyList:List = iq.getExtension(List.ELEMENT_NAME) as List;
			rsmStepper.current = historyList.getExtension(RSMSet.ELEMENT_NAME) as RSMSet;
			for (var i:int = 0; i < historyList.chats.length; i++) {
				var chat:ChatStanza = historyList.chats[i];
				print(chat.start, chat.withJID);
			}
		}*/
		/*override protected function executeIfNoErrors():void {
			var retrieveIQ:IQ = new IQ(null, IQ.TYPE_GET);
			retrieveIQ.callback = iqCallback;
			retrieveIQ.errorCallback = iqErrorCallback;

			var stanza:Retrieve = new Retrieve();
			if (params.length > 0) {
				var restrictions:Set = new Set();
				restrictions.max = params[0];
				restrictions.before = "";
				stanza.addExtension(restrictions)
			}
			stanza.withJID = directCommunicator.participant.escaped;
//			var startDate:Date = new Date(model.currentTime);
//			startDate.date -= 1;
//			stanza.start = "2014-11-16T18:02:39.458Z"; //DateTimeParser.dateTime2string(startDate);
			retrieveIQ.addExtension(stanza);
			controller.connection.send(retrieveIQ);
		}

		private function iqCallback(iq:IQ):void {
			var archive_ns:Namespace = new Namespace(null, archive_internal);
			var chat:XML = iq.xml.archive_ns::chat[0];
			var chats:XMLList = chat.children();
			var withJID:EscapedJID = new EscapedJID(chat.attribute("with"));
			var startDate:Date = DateTimeParser.string2dateTime(chat.attribute("start"));
			for each (var tag:XML in chats) {

				if(!(tag.localName() == "from" || tag.localName() == "to")) continue;

				var message:Message = new Message();
				message.body = tag.body;
				message.from = tag.localName() == "from" ? withJID : directCommunicator.chatUser.jid.escaped;
				var secsOffset:int = tag.@secs;
				var time:Number = startDate.time + secsOffset;
				var itemMessage:СItemMessage = new СItemMessage(message, time);
				itemMessage.isRead = true;
				directCommunicator.push(itemMessage);
			}
		}*/
		private function iqErrorCallback(iq:IQ):void {
			error(iq.toString());
		}
		private function get directCommunicator():DirectCommunicator {
			return communicator as DirectCommunicator;
		}
	}
}
