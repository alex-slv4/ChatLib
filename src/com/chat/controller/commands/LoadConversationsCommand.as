/**
 * Created by kvint on 02.12.14.
 */
package com.chat.controller.commands {
	import com.chat.controller.IChatController;
	import com.chat.model.IChatModel;
	import com.chat.model.communicators.IConversationsCommunicator;
	import com.chat.model.data.CItemConversation;
	import com.chat.utils.RSMStepper;

	import flash.globalization.DateTimeFormatter;
	import flash.globalization.DateTimeStyle;

	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.archive.ChatStanza;
	import org.igniterealtime.xiff.data.archive.List;
	import org.igniterealtime.xiff.data.rsm.RSMSet;
	import org.igniterealtime.xiff.util.DateTimeParser;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	public class LoadConversationsCommand implements ICommand {

		[Inject]
		public var model:IChatModel;

		[Inject]
		public var controller:IChatController;

		[Inject]
		public var conversations:IConversationsCommunicator;

		private var _chatStepper:RSMStepper = new RSMStepper(20);

		public function execute():void {
			var listStanza:List = new List();
			var listIQ:IQ = new IQ(null, IQ.TYPE_GET);
			listIQ.callback = listCallback;
			listIQ.errorCallback = listErrorCallback;
			listIQ.addExtension(listStanza);
			listStanza.addExtension(_chatStepper.getInitial());

			controller.send(listIQ);
		}

		private function listCallback(iq:IQ):void {
			var _list:List = iq.getExtension(List.ELEMENT_NAME) as List;
			var rsmSet:RSMSet = _list.getExtension(RSMSet.ELEMENT_NAME) as RSMSet;
			if(rsmSet.firstIndex == 0){
				//_end = true;
			}else{
				_chatStepper.current = rsmSet;
			}
			var filtered:Vector.<ChatStanza> = _list.chats.filter(chatStanzaComparator);
			for (var i:int = 0; i < filtered.length; i++) {
				var chat:ChatStanza = filtered[i];
				var conversation:CItemConversation = new CItemConversation(chat.withJID);
				conversations.push(conversation);
			}
		}

		/*private function printChat(element:ChatStanza, index:int, array:Vector.<ChatStanza>):void {
			var date1:Date = DateTimeParser.string2dateTime(element.start);
			var df:DateTimeFormatter = new DateTimeFormatter(flash.globalization.LocaleID.DEFAULT, DateTimeStyle.SHORT, DateTimeStyle.MEDIUM);
			trace(element.withJID.bareJID + " " + df.format(date1));//.date + "/" + date1.month + " " + date1.hours + ":" + date1.minutes);
		}*/
		private function chatStanzaComparator(element:ChatStanza, index:int, array:Vector.<ChatStanza>):Boolean {
			var newestItem:ChatStanza;
			for each (var item:ChatStanza in array) {
				if(item.withJID.equals(element.withJID, true)) {
					//check dates
					var date1:Date = DateTimeParser.string2dateTime(item.start);
					var date2:Date = DateTimeParser.string2dateTime(element.start);
					if(dateComparator(date1, date2) > 0){
						newestItem = item;
					}
				}
			}
			if(newestItem){
				return element == newestItem;
			}
			return true;
		}

		private function dateComparator(date1:Date, date2:Date):int {
			var date1Milliseconds:Number = date1.getTime();
			var date2Milliseconds:Number = date2.getTime();
			var diff:int = Math.round(date1Milliseconds - date2Milliseconds);
			return diff / Math.abs(diff);
		}
		private function listErrorCallback(iq:IQ):void {
			throw new Error("listErrorCallback");

		}
	}
}
