/**
 * Created by kvint on 19.11.14.
 */
package tests {
	import com.chat.Chat;
	import com.chat.IChat;
	import com.chat.controller.ChatController;
	import com.chat.controller.IChatController;
	import com.chat.events.CommunicatorFactoryEvent;
	import com.chat.model.ChatModel;
	import com.chat.model.ChatUser;
	import com.chat.model.IChatModel;
	import com.chat.model.activity.IActivities;
	import com.chat.model.communicators.ICommunicator;
	import com.chat.model.communicators.RoomCommunicator;
	import com.chat.model.communicators.factory.CommunicatorFactory;
	import com.chat.model.communicators.factory.ICommunicatorFactory;
	import com.chat.model.presences.IPresences;
	import com.chat.model.presences.IPresencesHandler;
	import com.chat.model.presences.Presences;

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.Message;
	import org.swiftsuspenders.Injector;

	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.impl.RobotlegsInjector;

	public class FabricTest {

		public var injector:Injector;
		private var chat:IChat;
		private var msg1:Message;
		private var msg2:Message;

		[Before]
		public function setUp():void {
			var bus:IEventDispatcher = new EventDispatcher();
			injector = new RobotlegsInjector();
			injector.map(IInjector).toValue(injector);

			injector.map(IChat).toSingleton(Chat);
			injector.map(IChatModel).toSingleton(ChatModel);
			injector.map(IChatController).toSingleton(ChatController);


			injector.map(ICommunicatorFactory).toSingleton(CommunicatorFactory);
			injector.map(IEventDispatcher).toValue(bus);
			var presences:Presences = new Presences();
			injector.map(IPresences).toValue(presences);
			injector.map(IPresencesHandler).toValue(presences);
			injector.map(IActivities).toValue(null);

			chat = injector.getInstance(IChat);
			chat.model.currentUser = new ChatUser(new UnescapedJID("bob@localhost"));


			msg1 = new Message();
			msg1.type = Message.TYPE_CHAT;
			msg1.from = chat.model.currentUser.jid.escaped;
			msg1.to = new UnescapedJID("joe@localhost").escaped;
			msg2 = new Message();
			msg2.type = Message.TYPE_CHAT;
			msg2.from = new UnescapedJID("joe@localhost").escaped;
			msg2.to  = chat.model.currentUser.jid.escaped;
		}

		[Test]
		public function testInjections():void {
			assertNotNull(chat.model);
			assertNotNull(chat.model.currentUser);
		}

		[Test]
		public function testFactory():void {
			assertNull(chat.model.communicators.getFor(null));
			assertNotNull(chat.model.communicators.items);
			assertEquals(chat.model.communicators.items.length, 0);
			
			var msg:Message = new Message();
			assertNull(chat.model.communicators.getFor(123));
			assertNull(chat.model.communicators.getFor({}));
			assertNull(chat.model.communicators.getFor(null));
			assertNull(chat.model.communicators.getFor(msg));
		}

		[Test]
		public function testRoomCreation():void {
			var msg:Message = new Message();
			msg.type = Message.TYPE_GROUPCHAT;
			msg.to = chat.model.currentUser.jid.escaped;
			msg.from = new UnescapedJID("joe@localhost").escaped;
			assertTrue(chat.model.communicators.getFor(msg) is RoomCommunicator);
		}

		[After]
		public function tearDown():void {
		}

	}
}
