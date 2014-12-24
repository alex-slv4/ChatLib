/**
 * Created by kvint on 22.11.14.
 */
package com.chat.model.history {
	import com.chat.controller.IChatController;
	import com.chat.events.CommunicatorEvent;
	import com.chat.model.IChatModel;
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.data.citems.CMessage;
	import com.chat.model.data.citems.CTitle;
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

		public static var BUFFER_SIZE:int = 10;

		[Inject]
		public var controller:IChatController;

		[Inject]
		public var model:IChatModel;

		[Inject]
		public var injector:IInjector;
		private var _listProvider:DirectListProvider;
		private var _me:UnescapedJID;
		private var _participant:UnescapedJID;
		private var _chats:Vector.<ChatStanza>;
		private var _conversationStepper:ISetLooper = new IndexedSetLooper();
		private var _currentChat:ChatStanza;

		private var _cachedItems:Vector.<ICItem> = new <ICItem>[];

		/**
		 * please remove it when openfire will handle RSM like it should!
		 */
		private var _uglyOpenfireTrigger:Boolean;
		private var _communicator:DirectCommunicator;
		private var _endReached:Boolean = false;
		private var _msgCount:int = 0;
		private var _busy:Boolean = false;

		public function ConversationsProvider(communicator:DirectCommunicator) {
			_communicator = communicator;
			_me = _communicator.chatUser.jid;
			_participant = new UnescapedJID(communicator.participant.bareJID);
		}


		public function fetch():void {

			if(_busy) return;

			if(resultsIsReady()){
				deliverResults();
				return;
			}

			_busy = true;

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
				var itemMessage:CMessage = new CMessage(message, time);
				itemMessage.isRead = true;
				results.push(itemMessage);
				_msgCount++;
			}
			_cachedItems = _cachedItems.concat(results.reverse());

			_conversationStepper.pin(rsmSet);

			if(resultsIsReady()){
				deliverResults();
				return;
			}

			loadNextConversations();
		}

		private function resultsIsReady():Boolean {
			return _msgCount >= BUFFER_SIZE || _endReached;
		}

		private function conversationErrorCallback(iq:IQ):void {
			throw iq.xml;
		}
		private function loadNextList():void {
			_listProvider.getNext(onListLoaded);
		}

		private function onListLoaded(chats:Vector.<ChatStanza>):void {
			_chats = chats;
			_endReached = _chats == null;

			if(_endReached){
				deliverResults();
				return;
			}

			if(_chats.length == 0){
				deliverResults();
			}else{
				loadLastChat();
			}
		}

		private function deliverResults():void {
			var i:int = 0;
			var idx:int = 0;
			var lastCommunicatorMessage:CMessage = getLastCommunicatorMessage();

			if(lastCommunicatorMessage){
				for(i = 0; i < _cachedItems.length; i++) {
					var icItem:ICItem = _cachedItems[i];
					if(icItem is CMessage){
						var msg:CMessage = icItem as CMessage;
						if(msg.time < lastCommunicatorMessage.time){
							idx = i;
							break;
						}
					}
				}
			}

			var results:Vector.<ICItem> = _cachedItems; //.splice(idx, BUFFER_SIZE);
			for(i = 0; i < results.length; i++) {
				var item:ICItem = results[i];
				_communicator.items.prepend(item);

				if(item is CMessage){
					_msgCount--;
				}
			}
			var fetchIndex:uint = results.length;
			_communicator.dispatchEvent(new CommunicatorEvent(CommunicatorEvent.HISTORY_FETCHED, fetchIndex));
			_cachedItems = new <ICItem>[];
			_busy = false;
		}

		private function getLastCommunicatorMessage():CMessage {
			for(var i:int = 0; i < _communicator.items.length; i++) {
				var object:ICItem = _communicator.items.getItemAt(i);
				if(object is CMessage) return object as CMessage;

			}
			return null;
		}

		private function loadLastChat():void {
			_conversationStepper.reset();

			if(_currentChat != null){
				var date:Date = DateTimeParser.string2dateTime(_currentChat.start);
				_cachedItems.push(new CTitle("New conversation", date.time));
			}

			if(_chats.length>0){
				_uglyOpenfireTrigger = true;
				_currentChat = _chats.pop();
				loadNextConversations();
			}else{
				_currentChat = null;
				loadNextList();
			}
		}

	}
}
