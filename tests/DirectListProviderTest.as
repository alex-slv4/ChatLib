/**
 * Created by kvint on 22.11.14.
 */
package {
	import com.chat.Chat;
	import com.chat.IChat;
	import com.chat.controller.ChatController;
	import com.chat.model.ChatModel;
	import com.chat.model.IChatModel;
	import com.chat.model.communicators.factory.CommunicatorFactory;
	import com.chat.model.communicators.factory.ICommunicatorFactory;
	import com.chat.model.history.DirectListProvider;
	import com.chat.model.presences.IPresences;
	import com.chat.model.presences.IPresencesHandler;
	import com.chat.model.presences.Presences;

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.async.Async;
	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.events.LoginEvent;

	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.impl.RobotlegsInjector;

	public class DirectListProviderTest {

		private var injector:RobotlegsInjector;
		private var directlist:DirectListProvider;

		[Before]
		public function setUp():void {
			var bus:IEventDispatcher = new EventDispatcher();
			injector = new RobotlegsInjector();
			injector.map(IInjector).toValue(injector);

			injector.map(IChat).toSingleton(Chat);
			injector.map(IChatModel).toSingleton(ChatModel);
			injector.map(ChatController).toSingleton(ChatController);


			injector.map(ICommunicatorFactory).toSingleton(CommunicatorFactory);
			injector.map(IEventDispatcher).toValue(bus);
			var presences:Presences = new Presences();
			injector.map(IPresences).toValue(presences);
			injector.map(IPresencesHandler).toValue(presences);
			var jid1:UnescapedJID = new UnescapedJID("external@localhost");
			var jid2:UnescapedJID = new UnescapedJID("bob@localhost");
			directlist = new DirectListProvider(jid1, jid2);
			injector.injectInto(directlist);
		}


		[Test(order=1)]
		public function testCreation():void {
			assertNotNull(directlist);
		}

		[Test(order=2,async)]
		public function testConnect():void {
			directlist.controller.addEventListener(LoginEvent.LOGIN, Async.asyncHandler(this, function(event:LoginEvent, data:Object):void{
				//connection success
			}, 3000));
			directlist.controller.connect("bob@localhost", "2gret37nidro");
		}

		[Test(order=3,async)]
		public function testRetrieve():void {
			directlist.getNext();
		}
	}
}
