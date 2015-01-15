/**
 * Created by kvint on 16.11.14.
 */
package com.chat.controller.commands {
	import com.chat.events.ChatEvent;
	import com.chat.model.data.citems.CTime;

	import flash.events.Event;

	import flash.events.IEventDispatcher;

	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.time.Time;
	import org.igniterealtime.xiff.util.DateTimeParser;

	public class TimeSyncCommand extends BaseChatCommand {

		[Inject]
		public var bus:IEventDispatcher;

		private var pingTime:int;

		override public function execute():void {
			trace("--------------------------------------------------");
			var iq:IQ = new IQ();
			iq.type = IQ.TYPE_GET;
			iq.addExtension(new Time());
			iq.callback = iqCallback;
			iq.errorCallback = iqErrorCallback;

			pingTime = getTimer();

			controller.send(iq);
		}

		private function iqCallback(iq:IQ):void {
			var time:Time = iq.getExtension(Time.ELEMENT_NAME) as Time;
			var date:Date = DateTimeParser.string2dateTime(time.utc);
			var localDate:Date = new Date();
			pingTime = getTimer() - pingTime;

			trace("ping", pingTime, 'ms');
			trace("offset", CTime.serverTimeOffset, 'ms');
			trace("prev", new Date(CTime.currentTime));
			trace("----------------");
			var actualTime:Number = date.time - pingTime;
			CTime.serverTimeOffset = actualTime - localDate.time;
			trace("server", date);
			trace("client", localDate);
			trace("result", new Date(CTime.currentTime));

			setTimeout(function():void{
				//run this command again
				bus.dispatchEvent(new Event(ChatEvent.SYNC_TIME));
			}, 3000);
		}
		private function iqErrorCallback(iq:IQ):void {
			throw new Error(iq.xml);
		}
	}
}
