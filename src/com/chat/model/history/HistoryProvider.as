/**
 * Created by kvint on 18.11.14.
 */
package com.chat.model.history {
	import com.chat.controller.IChatController;
	import com.chat.model.communicators.DirectCommunicator;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.archive.archive_internal;

	use namespace archive_internal;

	public class HistoryProvider implements IHistoryProvider{

		[Inject]
		public var controller:IChatController;
		private var _withJID:UnescapedJID;
		private var _communicator:DirectCommunicator;

		public function HistoryProvider(communicator:DirectCommunicator) {
			//FIXME: communicator here is just for output
			_communicator = communicator;
			_withJID = _communicator.participant;
		}


		public function fetchNext(callBack:Function):void {
		}

		/*public function getNext():void {
			if(	_list == null || !getNextConversations()){
				getNextChats();
			}
		}

		private function getNextConversations():Boolean {
			var nextConversations:RSMSet = _conversationStepper.next;
			if(nextConversations){
				loadConversations(nextConversations);
			}
			return nextConversations != null;
		}

		private function getNextChats():void {
			_chatIndex = 0;
			loadChats(_chatStepper.next);
		}

		private function loadConversations(rsm:RSMSet):void {
			if(_chatIndex >= _list.chats.length-1){
				//we need more chats
				getNextChats();
				return;
			}
			var retrieveStanza:Retrieve = new Retrieve();
			retrieveStanza.addExtension(rsm);
			retrieveStanza.withJID = _withJID.escaped;
			retrieveStanza.start = _list.chats[_chatIndex].start;

			var retrieveIQ:IQ = new IQ(null, IQ.TYPE_GET);
			retrieveIQ.callback = retrieveCallback;
			retrieveIQ.errorCallback = retrieveErrorCallback;
			retrieveIQ.addExtension(retrieveStanza);

			controller.connection.send(retrieveIQ);
		}

		private function loadChats(rsm:RSMSet):void {
			var listStanza:List = new List();
			listStanza.withJID = _withJID.escaped;
			listStanza.addExtension(rsm);

			var listIQ:IQ = new IQ(null, IQ.TYPE_GET);
			listIQ.callback = listCallback;
			listIQ.errorCallback = listErrorCallback;
			listIQ.addExtension(listStanza);

			controller.connection.send(listIQ);
		}

		private function listCallback(iq:IQ):void {
			_list = iq.getExtension(List.ELEMENT_NAME) as List;
			var rsmSet:RSMSet = _list.getExtension(RSMSet.ELEMENT_NAME) as RSMSet;
			_chatStepper.current = rsmSet;
			_communicator.push(new CItemString("Chats loaded " + rsmSet.toString()));
			getNext();
		}

		private function listErrorCallback(iq:IQ):void {
			iq;
		}

		private function retrieveCallback(iq:IQ):void {
			var chat:ChatStanza = iq.getExtension(ChatStanza.ELEMENT_NAME) as ChatStanza;
			var rsmSet:RSMSet = chat.getExtension(RSMSet.ELEMENT_NAME) as RSMSet;
			if(rsmSet){
				_communicator.push(new CItemString("Conversations loaded " + rsmSet.toString()));
			}
			_conversationStepper.current = rsmSet;
			if(rsmSet == null){
				_chatIndex++;
			}

			for each (var tag:XML in chat.xml.children()) {

				if(!(tag.localName() == "from" || tag.localName() == "to")) continue;

				var message:Message = new Message();
				message.body = tag.body;
				message.from = tag.localName() == "from" ? _withJID.escaped : _communicator.chatUser.jid.escaped;
				var secsOffset:int = tag.@secs;
				//var time:Number = startDate.time + secsOffset;
				var itemMessage:СItemMessage = new СItemMessage(message, secsOffset);
				itemMessage.isRead = true;
				//_communicator.push(itemMessage);
			}
		}

		private function retrieveErrorCallback(iq:IQ):void {
			iq;
		}*/
	}
}
