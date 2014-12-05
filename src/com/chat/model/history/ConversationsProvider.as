/**
 * Created by kvint on 22.11.14.
 */
package com.chat.model.history {
	import com.chat.controller.IChatController;
	import com.chat.model.data.citems.CItemMessage;
	import com.chat.model.data.citems.ICItem;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.archive.ChatStanza;
	import org.igniterealtime.xiff.data.archive.Retrieve;
	import org.igniterealtime.xiff.data.rsm.RSMSet;
	import org.igniterealtime.xiff.setmanagement.ISetLooper;
	import org.igniterealtime.xiff.setmanagement.IndexedSetLooper;
	import org.igniterealtime.xiff.util.DateTimeParser;

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

		private var _cachedItems:Vector.<ICItem> = new <ICItem>[];

		/**
		 * please remove it when openfire will handle RSM like it should!
		 */
		private var _uglyOpenfireTrigger:Boolean;
		private var _minRequiredCount:int;

		public function ConversationsProvider(participant:UnescapedJID, me:UnescapedJID) {
			_me = me;
			_participant = new UnescapedJID(participant.bareJID);
		}


		public function fetchNext(minRequired:int, callBack:Function):void {
			if(_callBack != null) return;

			_minRequiredCount = minRequired;

			_callBack = callBack;

			if(resultsIsReady()){
				deliverResults();
				return;
			}

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
			var rsmSet:RSMSet = _conversationStepper.getPrevious();
			if(rsmSet){
				retrieveStanza.addExtension(rsmSet);
				retrieveStanza.withJID = _participant.escaped;
				retrieveStanza.start = _currentChat.start;

				var retrieveIQ:IQ = new IQ(null, IQ.TYPE_GET);
				retrieveIQ.callback = conversationCallback;
				retrieveIQ.errorCallback = conversationErrorCallback;
				retrieveIQ.addExtension(retrieveStanza);
				controller.send(retrieveIQ);
			}else{
				loadLastChat();
			}
		}

		private function conversationCallback(iq:IQ):void {
			var chat:ChatStanza = iq.getExtension(ChatStanza.ELEMENT_NAME) as ChatStanza;
			var rsmSet:RSMSet = chat.getExtension(RSMSet.ELEMENT_NAME) as RSMSet;

			if(_uglyOpenfireTrigger) {
				_uglyOpenfireTrigger = false;
				rsmSet.first = null;
				_conversationStepper.pin(rsmSet);
				loadNextConversations();
				return;
			}
			var ns:Namespace = new Namespace(null, chat.getNS());
			var results:Vector.<ICItem> = new <ICItem>[];
			var date:Date = DateTimeParser.string2dateTime(_currentChat.start);
			var startTime:Number = date.getTime();
			for each (var tag:XML in chat.xml.children()) {

				if(!(tag.localName() == "from" || tag.localName() == "to")) continue;

				var message:Message = new Message();
				message.body = tag.ns::body;
				message.from = tag.localName() == "from" ? _participant.escaped : _me.escaped;
				var secsOffset:int = tag.@secs;
				var time:Number = startTime + secsOffset * 1000;
				var itemMessage:CItemMessage = new CItemMessage(message, time);
				itemMessage.isRead = true;
				results.push(itemMessage);
			}

			_cachedItems = results.concat(_cachedItems);

			if(resultsIsReady()){
				deliverResults();
				return;
			}

			_conversationStepper.pin(rsmSet);
			loadNextConversations();
		}

		private function resultsIsReady():Boolean {
			return _cachedItems.length >= _minRequiredCount;
		}

		private function conversationErrorCallback(iq:IQ):void {
			throw iq.xml;
		}
		private function loadNextList():void {
			_listProvider.getNext(onListLoaded);
		}

		private function onListLoaded(chats:Vector.<ChatStanza>):void {
			_chats = chats;
			if(_chats.length == 0){
				deliverResults();
			}else{
				loadLastChat();
			}
		}

		private function deliverResults():void {
			var results:Vector.<ICItem> = _cachedItems.splice(-_minRequiredCount, _minRequiredCount);
			_callBack(results);
			_callBack = null;
		}

		private function loadLastChat():void {
			_conversationStepper.reset();

			if(_chats.length>0){
				_uglyOpenfireTrigger = true;
				_currentChat = _chats.pop();
				loadNextConversations()
			}else{
				loadNextList();
			}
		}

	}
}
