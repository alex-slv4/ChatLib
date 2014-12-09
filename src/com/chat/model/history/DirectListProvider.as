/**
 * Created by kvint on 22.11.14.
 */
package com.chat.model.history {
	import com.chat.controller.IChatController;
	import com.chat.utils.OFSetLooper;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.archive.ChatStanza;
	import org.igniterealtime.xiff.data.archive.List;
	import org.igniterealtime.xiff.data.rsm.RSMSet;
	import org.igniterealtime.xiff.setmanagement.ISetLooper;

	public class DirectListProvider {

		[Inject]
		public var controller:IChatController;

		private var _participant:UnescapedJID;
		private var _list:List;
		private var _chatStepper:ISetLooper = new OFSetLooper(20);
		private var _end:Boolean;
		private var _callBack:Function;

		public function DirectListProvider(participant:UnescapedJID) {
			_participant = participant;
		}

		public function getNext(callBack:Function):void {
			if(_callBack != null) return;
			_callBack = callBack;
			if(_end) {
				_callBack(null);
				return;
			}
			loadNext();
		}

		private function loadNext():void {
			var previous:RSMSet = _chatStepper.getPrevious();
			if(previous){
				var listStanza:List = new List();
				listStanza.withJID = _participant.escaped;
				var listIQ:IQ = new IQ(null, IQ.TYPE_GET);
				listIQ.callback = listCallback;
				listIQ.errorCallback = listErrorCallback;
				listIQ.addExtension(listStanza);
				listStanza.addExtension(previous);
				controller.send(listIQ);
			}
		}

		private function listCallback(iq:IQ):void {
			_list = iq.getExtension(List.ELEMENT_NAME) as List;
			var rsmSet:RSMSet = _list.getExtension(RSMSet.ELEMENT_NAME) as RSMSet;
			_chatStepper.pin(rsmSet);
			if(rsmSet.first == null){
				loadNext();
				return;
			}

			if(rsmSet.firstIndex == 0){
				_end = true;
			}

			_callBack(_list.chats);
			_callBack = null;
		}

		private function listErrorCallback(iq:IQ):void {
			throw new Error("listErrorCallback");

		}
	}
}
