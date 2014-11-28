/**
 * Created by AlexanderSla on 28.11.2014.
 */
package tests {
	import com.chat.controller.IChatController;
	import com.chat.controller.commands.MessageCommand;
	import com.chat.controller.commands.cm.message.MarkAsReadCMCommand;
	import com.chat.controller.commands.cm.message.SendPrivateMessageCMCommand;
	import com.chat.events.CommunicatorCommandEvent;
	import com.chat.model.ChatModel;
	import com.chat.model.ChatUser;
	import com.chat.model.IChatModel;
	import com.chat.model.activity.Activities;
	import com.chat.model.activity.IActivities;
	import com.chat.model.activity.IActivitiesHandler;
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.communicators.factory.CommunicatorFactory;
	import com.chat.model.communicators.factory.ICommunicatorFactory;
	import com.chat.model.presences.IPresences;

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.events.MessageEvent;

	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandMap;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.impl.Context;

	public class ThreadingTest {

		private var injector:IInjector;
		private var model:IChatModel;
		private var controller:DumpController;
		private var bus:IEventDispatcher;

		[Before]
		public function setUp():void {
			var context:Context = new Context();
			bus = new EventDispatcher();
			injector = context.injector;
			var commandMap:IEventCommandMap = new EventCommandMap(context, bus);

			injector.map(IEventDispatcher).toValue(bus);
			injector.map(IInjector).toValue(injector);
			injector.map(IChatController).toSingleton(DumpController);
			injector.map(ICommunicatorFactory).toSingleton(CommunicatorFactory);
			var activities:Activities = new Activities();
			injector.map(IActivities).toValue(activities);
			injector.map(IActivitiesHandler).toValue(activities);
			injector.map(IPresences).toValue(null);
			injector.map(IChatModel).toSingleton(ChatModel);
			model = injector.getInstance(IChatModel);
			controller = injector.getInstance(IChatController);

			model.currentUser = new ChatUser(new UnescapedJID("bob@localhost"));

			commandMap.map(CommunicatorCommandEvent.PRIVATE_MESSAGE).toCommand(SendPrivateMessageCMCommand);
			commandMap.map(CommunicatorCommandEvent.MARK_AS_RECEIVED).toCommand(MarkAsReadCMCommand);
			commandMap.map(MessageEvent.MESSAGE).toCommand(MessageCommand);
		}

		[Test]
		public function testInit():void {
			assertNotNull(model);
			assertNotNull(model.communicators);
		}

		[Test]
		public function testNewMessage():void {
			var msg:Message = new Message();
			msg.type = Message.TYPE_CHAT;
			msg.from = new UnescapedJID("joe@localhost").escaped;
			msg.to  = model.currentUser.jid.escaped;
			var iCommunicator:DirectCommunicator = model.communicators.getFor(msg) as DirectCommunicator;

			iCommunicator.send("test message");

			var rest:Message = controller.lastStanza as Message;
			assertNotNull(rest);
			assertNotNull(rest.thread);
		}
		[Test]
		public function testReplyMessage():void {
			var messageFromJoe:Message = new Message();
			messageFromJoe.type = Message.TYPE_CHAT;
			messageFromJoe.from = new UnescapedJID("joe@localhost").escaped;
			messageFromJoe.to  = model.currentUser.jid.escaped;
			messageFromJoe.thread = model.threadGenerator.generateID();

			var messageEvent:MessageEvent = new MessageEvent();
			messageEvent.data = messageFromJoe;
			bus.dispatchEvent(messageEvent);
			messageFromJoe.thread = model.threadGenerator.generateID();
			bus.dispatchEvent(messageEvent);

			var iCommunicator:DirectCommunicator = model.communicators.getFor(messageFromJoe) as DirectCommunicator;

			iCommunicator.send("reply message");

			var rest:Message = controller.lastStanza as Message;
			assertEquals(messageFromJoe.thread, rest.thread);
		}
	}
}

import com.chat.controller.IChatController;

import org.igniterealtime.xiff.core.AbstractJID;
import org.igniterealtime.xiff.data.IXMPPStanza;

class DumpController implements IChatController {

	private var _lastStanza:IXMPPStanza;

	public function send(stanza:IXMPPStanza):void {
		_lastStanza = stanza;
	}

	public function connect(username:String, password:String):void {
	}

	public function disconnect():void {
	}

	public function addFriend(jid:AbstractJID):void {
	}

	public function joinRoom(room:String, password:String = null):void {
	}

	public function get lastStanza():IXMPPStanza {
		return _lastStanza;
	}
}
