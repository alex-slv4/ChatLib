/**
 * Created by kvint on 01.11.14.
 */
package com.chat.controller {
	import com.chat.model.ChatUser;
	import com.chat.model.IChatModel;
	import com.chat.signals.CommunicatorSignal;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import org.igniterealtime.xiff.core.AbstractJID;
	import org.igniterealtime.xiff.data.IXMPPStanza;
	import org.igniterealtime.xiff.data.archive.ChatStanza;
	import org.igniterealtime.xiff.data.archive.List;
	import org.igniterealtime.xiff.data.archive.Retrieve;
	import org.igniterealtime.xiff.data.archive.archive_internal;
	import org.igniterealtime.xiff.data.rsm.RSMSet;
	import org.igniterealtime.xiff.data.time.Time;
	import org.igniterealtime.xiff.im.IRoster;
	import org.igniterealtime.xiff.im.Roster;
	import org.igniterealtime.xiff.util.JIDUtil;

	use namespace archive_internal;

	public class ChatController extends BaseChatController implements IChatController {

		[Inject]
		public var model:IChatModel;

		[Inject]
		public var bus:IEventDispatcher;

		[Inject]
		public var communicatorSignal:CommunicatorSignal;


		[PostConstruct]
		override public function init():void {
			super.init();
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

		override protected function dispatch(e:Event):void {
			bus.dispatchEvent(e);
		}

		public function addFriend(jid:AbstractJID):void {
			var jidStr:String = JIDUtil.unescape(jid).bareJID;
			communicatorSignal.dispatch("roster add", null, [jidStr]);
		}


		public function joinRoom(room:String, password:String = null):void {
			communicatorSignal.dispatch("room join", null, [room, password]);
		}

		public function destroy():void {
			//TODO: destroy
		}
	}
}
