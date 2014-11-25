/**
 * Created by AlexanderSla on 25.11.2014.
 */
package com.chat.controller.commands {
	import com.chat.model.presences.IPresencesHandler;

	import org.igniterealtime.xiff.data.IPresence;
	import org.igniterealtime.xiff.data.IXMPPStanza;
	import org.igniterealtime.xiff.data.Presence;

	import org.igniterealtime.xiff.events.PresenceEvent;

	public class PresenceCommand extends BaseChatCommand {

		[Inject]
		public var presences:IPresencesHandler;

		[Inject]
		public var event:PresenceEvent;

		override public function execute():void {
			var presence:IPresence;
			for (var i:int = 0; i < event.data.length; i++) {
				presence = event.data[i] as IPresence;
				if (presence.type == Presence.TYPE_SUBSCRIBE) {
					model.roster.grantSubscription(presence.from.unescaped, false);
				}

				if (presence.type == Presence.TYPE_PROBE) {
					var reply:IXMPPStanza = new Presence();
					controller.send(reply);
				}

				presences.handlePresence(presence);
			}
		}
	}
}
