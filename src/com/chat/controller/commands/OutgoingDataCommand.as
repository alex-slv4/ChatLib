/**
 * Created by kvint on 04.12.14.
 */
package com.chat.controller.commands {
	import org.as3commons.logging.api.getLogger;
	import org.igniterealtime.xiff.events.OutgoingDataEvent;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	public class OutgoingDataCommand implements ICommand {

		[Inject]
		public var event:OutgoingDataEvent;

		public function execute():void {
			getLogger().debug(event.data);
			//trace("Outgoing");
			//trace(event.data);
		}
	}
}
