/**
 * Created by kvint on 01.11.14.
 */
package com.chat.controller {
	import com.chat.events.ChatEvent;
	import com.chat.events.ChatModelEvent;
	import com.chat.model.ChatModel;
	import com.chat.model.ChatUser;
	import com.chat.model.communicators.ICommunicator;
	import com.chat.model.data.СItemMessage;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import org.igniterealtime.xiff.core.Browser;
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.Presence;
	import org.igniterealtime.xiff.data.archive.Retrieve;
	import org.igniterealtime.xiff.data.archive.archive_internal;
	import org.igniterealtime.xiff.data.disco.DiscoExtension;
	import org.igniterealtime.xiff.data.disco.DiscoFeature;
	import org.igniterealtime.xiff.data.disco.InfoDiscoExtension;
	import org.igniterealtime.xiff.data.time.Time;
	import org.igniterealtime.xiff.events.LoginEvent;
	import org.igniterealtime.xiff.events.MessageEvent;
	import org.igniterealtime.xiff.events.PresenceEvent;
	import org.igniterealtime.xiff.util.DateTimeParser;

	use namespace archive_internal;

	public class ChatController extends BaseChatController {

		[Inject]
		public var chatModel:ChatModel;

		[Inject]
		public var bus:IEventDispatcher;

		private var _browser:Browser;

		[PostConstruct]
		override public function init():void {
			super.init();

			chatModel.addEventListener(ChatModelEvent.COMMUNICATOR_ACTIVATED, communicatorEventHandler);
			chatModel.addEventListener(ChatModelEvent.COMMUNICATOR_ADDED, communicatorEventHandler);
			chatModel.addEventListener(ChatModelEvent.COMMUNICATOR_REMOVED, communicatorEventHandler);

			_browser = new Browser(connection);

		}

		override protected function setupConnection():void {
			super.setupConnection();
			_connection.enableExtensions(Retrieve);
			_connection.enableExtensions(Time);
		}

		override protected function setupCurrentUser():void {
			_currentUser = new ChatUser(_connection.jid);
			chatModel.currentUser = _currentUser;
		}

		private function communicatorEventHandler(event:ChatModelEvent):void {
			var communicator:ICommunicator = event.data as ICommunicator;
			switch (event.type){
				case ChatModelEvent.COMMUNICATOR_ADDED:
					break;
				case ChatModelEvent.COMMUNICATOR_REMOVED:
					break;
				case ChatModelEvent.COMMUNICATOR_ACTIVATED:
					chatModel.activeCommunicator = communicator;
					break;
			}
		}

		override protected function setupRoster():void {
			super.setupRoster();
			chatModel.roster = _roster;
		}

		public function sendRoomMessage(message:Message):void {
			connection.send(message);
		}

		override protected function onMessageCome(event:MessageEvent):void {
			var message:Message = event.data;
			if(message.type != null) {
				var communicator:ICommunicator = chatModel.provider.getCommunicator(message);
				if(message.body == null){
//					if(message.state) communicator.push(new CItemString(message.state));
				}else{
					communicator.push(new СItemMessage(message));
				}
			}
		}


		override protected function onPresence(event:PresenceEvent):void {
			var presence:Presence;
			for (var i:int = 0; i < event.data.length; i++) {
				presence = event.data[i] as Presence;
				if (presence.type == Presence.TYPE_SUBSCRIBE) {
					chatModel.roster.grantSubscription(presence.from.unescaped, false);
				}
			}
			super.onPresence(event);
		}

		override protected function onLogin(event:LoginEvent):void {
			super.onLogin(event);
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
			throw new Error("Server not configured");
		}

		public function test():void {

			var test:IQ = new IQ(null, IQ.TYPE_GET);
			test.callback = function (iq:IQ):void {
				var chatNS:Namespace = new Namespace(null, archive_internal);
				var chat:XML = iq.xml.chatNS::chat[0];
				var chats:XMLList = chat.children();
				var str:String = "";
				var startDate:Date = DateTimeParser.string2dateTime(chat.attribute("start"));
				for each (var tag:XML in chats) {
					if(tag.localName() == "from"){
						str += formatDate(startDate) + " " + chat.attribute("with") + ": " + tag.body;
					}else{
						str += formatDate(startDate) + " " + chatModel.currentUser.jid + ": " + tag.body;
					}
					str += "\n";
				}
				trace(str);
			}
			var stanza:Retrieve = new Retrieve();
			stanza.withJID = new EscapedJID("joe@localhost");
			test.addExtension(stanza);
			connection.send(test);
		}

		private function formatDate(startDate:Date):String {
			return startDate.toString();
		}

		public function activateCommunicator(communicator:ICommunicator):void {
			chatModel.dispatchEvent(new ChatModelEvent(ChatModelEvent.COMMUNICATOR_ACTIVATED, communicator));
		}
		public function destroy():void {
			//TODO: destroy
		}
	}
}
