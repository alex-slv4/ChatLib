/**
 * Created by kvint on 22.11.14.
 */
package com.chat.model.history {
	import com.chat.controller.IChatController;
	import com.chat.model.data.ICItem;
	import com.chat.model.data.СItemMessage;
	import com.chat.utils.RSMStepper;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.archive.ChatStanza;
	import org.igniterealtime.xiff.data.archive.Retrieve;
	import org.igniterealtime.xiff.data.rsm.RSMSet;

	import robotlegs.bender.framework.api.IInjector;

	public class ConversationsProvider implements IHistoryProvider {

		[Inject]
		public var controller:IChatController;

		[Inject]
		public var injector:IInjector;
		private var _listProvider:DirectListProvider;
		private var _me:UnescapedJID;
		private var _participant:UnescapedJID;
		private var _chats:Vector.<ChatStanza>;
		private var _conversationStepper:RSMStepper = new RSMStepper(50);
		private var _currentChat:ChatStanza;
		private var _currentConversationIndex:int;
		private var _callBack:Function;

		public function ConversationsProvider(participant:UnescapedJID, me:UnescapedJID) {
			_me = me;
			_participant = participant;
		}


		public function fetchNext(callBack:Function):void {
			if(_callBack != null) return;

			_callBack = callBack;

			if(_listProvider == null){
				_listProvider = new DirectListProvider(_participant);
				injector.injectInto(_listProvider);
				loadNextList();
				return;
			}
			if(_currentChat){
				loadNextConversations();
			}else{
				loadLastChat();
			}
		}

		private function loadNextConversations():void {

			var retrieveStanza:Retrieve = new Retrieve();
			var previous:RSMSet = _conversationStepper.previous;
			retrieveStanza.addExtension(previous);
			retrieveStanza.withJID = _participant.escaped;
			retrieveStanza.start = _currentChat.start;

			var retrieveIQ:IQ = new IQ(null, IQ.TYPE_GET);
			retrieveIQ.callback = conversationCallback;
			retrieveIQ.errorCallback = conversationErrorCallback;
			retrieveIQ.addExtension(retrieveStanza);

			controller.send(retrieveIQ);
		}

		private function conversationCallback(iq:IQ):void {
			var chat:ChatStanza = iq.getExtension(ChatStanza.ELEMENT_NAME) as ChatStanza;
			var rsmSet:RSMSet = chat.getExtension(RSMSet.ELEMENT_NAME) as RSMSet;

			if(rsmSet.firstIndex == 0){
				_currentChat = null;
			}else{
				_conversationStepper.current = rsmSet;
			}
			var ns:Namespace = new Namespace(null, chat.getNS());
			var items:Vector.<ICItem> = new <ICItem>[];
			for each (var tag:XML in chat.xml.children()) {

				if(!(tag.localName() == "from" || tag.localName() == "to")) continue;

				var message:Message = new Message();
				message.body = tag.ns::body;
				message.from = tag.localName() == "from" ? _participant.escaped : _me.escaped;
				var secsOffset:int = tag.@secs;
				//var time:Number = startDate.time + secsOffset;
				var itemMessage:СItemMessage = new СItemMessage(message, secsOffset);
				itemMessage.isRead = true;
				items.push(itemMessage);
			}
			_callBack(items);
			_callBack = null;
		}

		private function conversationErrorCallback(iq:IQ):void {

		}
		private function loadNextList():void {
			_listProvider.getNext(onListLoaded);
		}

		private function onListLoaded(chats:Vector.<ChatStanza>):void {
			_chats = chats;
			if(_chats.length>0){
				loadLastChat();
			}else{
				_chats;
			}
		}

		private function loadLastChat():void {
			if(_chats.length>0){
				_currentChat = _chats.pop();
				loadConversationSize();
			}else{
				loadNextList();
			}
		}

		private function loadConversationSize():void {
			var rsm:RSMSet = _conversationStepper.getInitial();
			var retrieveStanza:Retrieve = new Retrieve();
			retrieveStanza.addExtension(rsm);
			retrieveStanza.start = _currentChat.start;
			retrieveStanza.withJID = _participant.escaped;

			var retrieveIQ:IQ = new IQ(null, IQ.TYPE_GET);
			retrieveIQ.callback = conversationSizeCallback;
			retrieveIQ.errorCallback = conversationSizeErrorCallback;
			retrieveIQ.addExtension(retrieveStanza);

			controller.send(retrieveIQ);
		}

		public function conversationSizeCallback(iq:IQ):void {
			var conversation:ChatStanza = iq.getExtension(ChatStanza.ELEMENT_NAME) as ChatStanza;
			var rsmSet:RSMSet = conversation.getExtension(RSMSet.ELEMENT_NAME) as RSMSet;
			_currentConversationIndex = rsmSet.count;
			var initialSet:RSMSet = new RSMSet();
			initialSet.firstIndex = _currentConversationIndex;
			_conversationStepper.current = initialSet;
			loadNextConversations();
		}


		public function conversationSizeErrorCallback(iq:IQ):void {
			throw new Error("conversationSizeErrorCallback");
		}
	}
}
