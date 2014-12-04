/**
 * Created by kvint on 04.12.14.
 */
package com.chat.controller.commands {
	import org.igniterealtime.xiff.events.IncomingDataEvent;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	public class IncomingDataCommand implements ICommand {

		[Inject]
		public var event:IncomingDataEvent;

		public function execute():void {
			trace("Incoming");
			trace(event.data);
		}
	}
}
