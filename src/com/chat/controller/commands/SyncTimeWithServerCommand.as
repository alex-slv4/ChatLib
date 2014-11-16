/**
 * Created by kvint on 16.11.14.
 */
package com.chat.controller.commands {
	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.time.Time;
	import org.igniterealtime.xiff.util.DateTimeParser;

	public class SyncTimeWithServerCommand extends BaseChatCommand {

		override public function execute():void {
			var iq:IQ = new IQ();
			iq.type = IQ.TYPE_GET;
			iq.addExtension(new Time());
			iq.callback = iqCallback;
			iq.errorCallback = iqErrorCallback;

			controller.connection.send(iq);
		}

		private function iqCallback(iq:IQ):void {
			var time:Time = iq.getExtension(Time.ELEMENT_NAME) as Time;
			var date:Date = DateTimeParser.string2dateTime(time.utc);
			var localDate:Date = new Date();
			model.serverTimeOffset = date.time - localDate.time;
		}
		private function iqErrorCallback(iq:IQ):void {
			throw new Error(iq.xml);
		}
	}
}
