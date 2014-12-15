/**
 * Created by kvint on 16.11.14.
 */
package com.chat.controller.commands {
	import com.chat.model.data.citems.CTime;

	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.time.Time;
	import org.igniterealtime.xiff.util.DateTimeParser;

	public class TimeSyncCommand extends BaseChatCommand {

		override public function execute():void {
			var iq:IQ = new IQ();
			iq.type = IQ.TYPE_GET;
			iq.addExtension(new Time());
			iq.callback = iqCallback;
			iq.errorCallback = iqErrorCallback;

			controller.send(iq);
		}

		private function iqCallback(iq:IQ):void {
			var time:Time = iq.getExtension(Time.ELEMENT_NAME) as Time;
			var date:Date = DateTimeParser.string2dateTime(time.utc);
			var localDate:Date = new Date();
			CTime.serverTimeOffset = date.time - localDate.time;
		}
		private function iqErrorCallback(iq:IQ):void {
			throw new Error(iq.xml);
		}
	}
}
