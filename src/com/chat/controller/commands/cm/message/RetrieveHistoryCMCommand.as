/**
 * Created by kvint on 16.11.14.
 */
package com.chat.controller.commands.cm.message {
	import com.chat.controller.commands.cm.CMCommand;
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.data.СItemMessage;

	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.archive.RetrieveStanza;
	import org.igniterealtime.xiff.data.archive.archive_internal;
	import org.igniterealtime.xiff.util.DateTimeParser;

	use namespace archive_internal;

	public class RetrieveHistoryCMCommand extends CMCommand {

		override protected function executeIfNoErrors():void {
			var test:IQ = new IQ(null, IQ.TYPE_GET);
			test.callback = function (iq:IQ):void {
				var chatNS:Namespace = new Namespace(null, archive_internal);
				var chat:XML = iq.xml.chatNS::chat[0];
				var chats:XMLList = chat.children();
				var withJID:EscapedJID = new EscapedJID(chat.attribute("with"));
				var str:String = "";
				var startDate:Date = DateTimeParser.string2dateTime(chat.attribute("start"));
				for each (var tag:XML in chats) {
					var message:Message = new Message();
					message.body = tag.body;
					message.from = tag.localName() == "from" ? withJID : directCommunicator.chatUser.jid.escaped;
					var secsOffset:int = tag.@secs;
					var time:Number = startDate.time + secsOffset;
					var itemMessage:СItemMessage = new СItemMessage(message, time);
					itemMessage.isRead = true;
					directCommunicator.push(itemMessage);
				}
				trace(str);
			}
			var stanza:RetrieveStanza = new RetrieveStanza();
			stanza.withJID = directCommunicator.participant.escaped;
			test.addExtension(stanza);
			controller.connection.send(test);
		}

		private function get directCommunicator():DirectCommunicator {
			return communicator as DirectCommunicator;
		}
	}
}
