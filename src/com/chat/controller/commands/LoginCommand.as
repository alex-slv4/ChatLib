/**
 * Created by kvint on 27.11.14.
 */
package com.chat.controller.commands {
	import com.chat.events.ChatEvent;

	import flash.events.Event;

	import flash.events.IEventDispatcher;
	import flash.utils.setInterval;

	import org.igniterealtime.xiff.core.Browser;
	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.disco.DiscoExtension;
	import org.igniterealtime.xiff.data.disco.DiscoFeature;
	import org.igniterealtime.xiff.data.disco.InfoDiscoExtension;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	public class LoginCommand extends BaseChatCommand implements ICommand{

		[Inject]
		public var bus:IEventDispatcher;
		private var _browser:Browser;

		override public function execute():void {
			model.currentUser.loadVCard(model.connection);
			bus.dispatchEvent(new Event(ChatEvent.SYNC_TIME));
			//bus.dispatchEvent(new Event(ChatEvent.LOAD_CONVERSATIONS));
			//_browser = new Browser(model.connection);
			//_browser.getServiceInfo(null, onServerInfo);
		}
		private function onServerInfo(iq:IQ):void {
			var extension1:InfoDiscoExtension = iq.getExtension(DiscoExtension.ELEMENT_NAME) as InfoDiscoExtension;
			for (var i:int = 0; i < extension1.features.length; i++) {
				var feature:DiscoFeature = extension1.features[i];
				if (feature.varName == "urn:xmpp:archive:auto") {
					return;
				}
			}
			//TODO: add normal reaction
//			throw new Error("Server not configured");
		}
	}
}
