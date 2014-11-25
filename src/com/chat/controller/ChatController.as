/**
 * Created by kvint on 01.11.14.
 */
package com.chat.controller {
	import com.chat.events.ChatEvent;
	import com.chat.model.ChatUser;
	import com.chat.model.IChatModel;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import org.igniterealtime.xiff.core.Browser;
	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.IXMPPStanza;
	import org.igniterealtime.xiff.data.archive.ChatStanza;
	import org.igniterealtime.xiff.data.archive.List;
	import org.igniterealtime.xiff.data.archive.Retrieve;
	import org.igniterealtime.xiff.data.archive.archive_internal;
	import org.igniterealtime.xiff.data.disco.DiscoExtension;
	import org.igniterealtime.xiff.data.disco.DiscoFeature;
	import org.igniterealtime.xiff.data.disco.InfoDiscoExtension;
	import org.igniterealtime.xiff.data.rsm.RSMSet;
	import org.igniterealtime.xiff.data.time.Time;
	import org.igniterealtime.xiff.events.LoginEvent;
	import org.igniterealtime.xiff.im.IRoster;
	import org.igniterealtime.xiff.im.Roster;

	use namespace archive_internal;

	public class ChatController extends BaseChatController implements IChatController {

		[Inject]
		public var model:IChatModel;

		[Inject]
		public var bus:IEventDispatcher;


		private var _browser:Browser;

		[PostConstruct]
		override public function init():void {
			super.init();

			_browser = new Browser(connection);

		}

		override protected function setupConnection():void {
			super.setupConnection();
			model.connection = this.connection;
			connection.enableExtensions(Retrieve);
			connection.enableExtensions(Time);
			connection.enableExtensions(RSMSet);
			connection.enableExtensions(List);
			connection.enableExtensions(ChatStanza);
		}

		override protected function setupCurrentUser():void {
			model.currentUser = new ChatUser(_connection.jid);
		}

		override protected function setupRoster():void {
			model.roster = new Roster();
			super.setupRoster();
		}

		override public function get roster():IRoster {
			return model.roster;
		}

		public function send(stanza:IXMPPStanza):void {
			connection.send(stanza);
		}

		override protected function onLogin(event:LoginEvent):void {
			super.onLogin(event);
			model.currentUser.loadVCard(_connection);
			bus.dispatchEvent(new Event(ChatEvent.SYNC_TIME));
			_browser.getServiceInfo(null, onServerInfo);
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

		override protected function dispatch(e:Event):void {
			bus.dispatchEvent(e);
		}

		public function destroy():void {
			//TODO: destroy
		}
	}
}
