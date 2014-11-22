/**
 * Created by kvint on 22.11.14.
 */
package com.chat.model.history {
	import com.chat.controller.ChatController;
	import com.chat.utils.RSMStepper;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.archive.ChatStanza;
	import org.igniterealtime.xiff.data.archive.List;
	import org.igniterealtime.xiff.data.rsm.RSMSet;

	public class DirectListProvider {

		[Inject]
		public var controller:ChatController;

		private var _participant:UnescapedJID;
		private var _chatIndex:int;
		private var _list:List;
		private var _chatStepper:RSMStepper = new RSMStepper(5);
		private var _end:Boolean;
		private var _callBack:Function;

		public function DirectListProvider(participant:UnescapedJID) {
			_participant = participant;
		}

		public function getNext(callBack:Function):void {
			if(_callBack != null) return;
			_callBack = callBack;
			if(_end) {
				_callBack(new <ChatStanza>[]);
				return;
			}
			if(_chatStepper.current == null){
				loadListSize();
			}else{
				loadNext();
			}
		}

		private function loadNext():void {
			var rsmSet:RSMSet = _chatStepper.previous;
			var listStanza:List = new List();
			listStanza.withJID = _participant.escaped;
			var listIQ:IQ = new IQ(null, IQ.TYPE_GET);
			listIQ.callback = listCallback;
			listIQ.errorCallback = listErrorCallback;
			listIQ.addExtension(listStanza);
			listStanza.addExtension(rsmSet);

			controller.connection.send(listIQ);
		}

		private function listCallback(iq:IQ):void {
			_list = iq.getExtension(List.ELEMENT_NAME) as List;
			var rsmSet:RSMSet = _list.getExtension(RSMSet.ELEMENT_NAME) as RSMSet;
			if(rsmSet.firstIndex == 0){
				_end = true;
			}else{
				_chatStepper.current = rsmSet;
			}
			_callBack(_list.chats);
			_callBack = null;
		}

		private function listErrorCallback(iq:IQ):void {
			throw new Error("listErrorCallback");

		}
		private function loadListSize():void {

			var rsmSet:RSMSet = _chatStepper.getInitial();
			var listStanza:List = new List();
			listStanza.withJID = _participant.escaped;
			var listIQ:IQ = new IQ(null, IQ.TYPE_GET);
			listIQ.callback = listSizeCallback;
			listIQ.errorCallback = listSizeErrorCallback;
			listIQ.addExtension(listStanza);
			listStanza.addExtension(rsmSet);

			controller.connection.send(listIQ);
		}

		private function listSizeCallback(iq:IQ):void {
			var list:List = iq.getExtension(List.ELEMENT_NAME) as List;
			var rsmSet:RSMSet = list.getExtension(RSMSet.ELEMENT_NAME) as RSMSet;
			_chatIndex = rsmSet.count;
			var initialSet:RSMSet = new RSMSet();
			initialSet.firstIndex = _chatIndex;
			_chatStepper.current = initialSet;
			loadNext();
		}

		private function listSizeErrorCallback(iq:IQ):void {
			throw new Error("listSizeErrorCallback");

		}
	}
}
