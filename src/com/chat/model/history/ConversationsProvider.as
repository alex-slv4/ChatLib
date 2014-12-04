/**
 * Created by kvint on 22.11.14.
 */
package com.chat.model.history {
	import com.chat.controller.IChatController;
	import com.chat.model.data.CItemMessage;
	import com.chat.model.data.ICItem;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.archive.ChatStanza;
	import org.igniterealtime.xiff.data.archive.Retrieve;
	import org.igniterealtime.xiff.data.rsm.RSMSet;
	import org.igniterealtime.xiff.setmanagement.ISetLooper;
	import org.igniterealtime.xiff.setmanagement.IndexedSetLooper;
	import org.igniterealtime.xiff.setmanagement.SetLooper;

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
		private var _conversationStepper:ISetLooper = new IndexedSetLooper();
		private var _currentChat:ChatStanza;
		private var _callBack:Function;

		public function ConversationsProvider(participant:UnescapedJID, me:UnescapedJID) {
			_me = me;
			_conversationStepper.bufferSize = 1;
			_participant = new UnescapedJID(participant.bareJID);
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
			var rsmSet:RSMSet = _conversationStepper.previous;
			if(rsmSet){
				retrieveStanza.addExtension(rsmSet);
				retrieveStanza.withJID = _participant.escaped;
				retrieveStanza.start = _currentChat.start;

				var retrieveIQ:IQ = new IQ(null, IQ.TYPE_GET);
				retrieveIQ.callback = conversationCallback;
				retrieveIQ.errorCallback = conversationErrorCallback;
				retrieveIQ.addExtension(retrieveStanza);
				//trace("send");
				trace("send", rsmSet.index);
				controller.send(retrieveIQ);
			}else{
				loadLastChat();
			}
		}

		private function conversationCallback(iq:IQ):void {
			var chat:ChatStanza = iq.getExtension(ChatStanza.ELEMENT_NAME) as ChatStanza;
			var rsmSet:RSMSet = chat.getExtension(RSMSet.ELEMENT_NAME) as RSMSet;

			trace("come", rsmSet.count);
			_conversationStepper.pin(rsmSet);
			if(rsmSet.first == null){
				loadNextConversations();
				return;
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
				var itemMessage:CItemMessage = new CItemMessage(message, secsOffset);
				itemMessage.isRead = true;
				items.push(itemMessage);
			}
			_callBack(items);
			_callBack = null;
		}

		private function conversationErrorCallback(iq:IQ):void {
			throw iq.xml;
		}
		private function loadNextList():void {
			_listProvider.getNext(onListLoaded);
		}

		private function onListLoaded(chats:Vector.<ChatStanza>):void {
			_chats = chats;
			loadLastChat();
		}

		private function loadLastChat():void {
			_conversationStepper.reset();
			if(_chats.length>0){
				trace("loadLastChat");
				_currentChat = _chats.pop();
				loadNextConversations()
			}else{
				loadNextList();
			}
		}

	}
}
