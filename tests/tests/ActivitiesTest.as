/**
 * Created by AlexanderSla on 27.11.2014.
 */
package tests {
	import com.chat.model.activity.Activities;
	import com.chat.model.config.ActivityStatuses;

	import org.flexunit.asserts.assertEquals;
	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.Message;

	public class ActivitiesTest {

		private var activities:Activities;
		private var bob:FakeActivity;
		private var joe:FakeActivity;

		[Before]
		public function setUp():void {
			activities = new Activities();

			bob = new FakeActivity("bob@localhost");
			joe = new FakeActivity("joe@localhost");
		}
		[Test]
		public function basicSubscribe():void {

			activities.subscribe(bob);
			assertEquals(bob.state, ActivityStatuses.UNKNOWN);
		}

		[Test]
		public function testSubscribeAfterHandle():void {

			var message:Message = createMSG();
			message.state = Message.STATE_ACTIVE;
			activities.handleActivity(message);
			activities.subscribe(bob);

			assertEquals(bob.state, ActivityStatuses.ACTIVE);
		}


		[Test]
		public function testStates():void {
			var message:Message = createMSG();
			activities.handleActivity(message);
			activities.subscribe(bob);


			assertEquals(bob.state, ActivityStatuses.UNKNOWN);
		}

		[Test]
		public function testActive():void {
			var message:Message = createMSG();
			message.state = Message.STATE_ACTIVE;
			activities.subscribe(bob);
			activities.handleActivity(message);


			assertEquals(bob.state, ActivityStatuses.ACTIVE);
		}

		[Test]
		public function testComposing():void {
			var message:Message = createMSG();
			message.state = Message.STATE_COMPOSING;
			activities.subscribe(bob);
			activities.handleActivity(message);


			assertEquals(bob.state, ActivityStatuses.COMPOSING);
		}


		[Test]
		public function testPaused():void {
			var message:Message = createMSG();
			message.state = Message.STATE_PAUSED;
			activities.subscribe(bob);
			activities.handleActivity(message);


			assertEquals(bob.state, ActivityStatuses.PAUSED);
		}


		[Test]
		public function testUnknown():void {
			var message:Message = createMSG();
			message.state = Message.STATE_GONE;
			activities.handleActivity(message);
			activities.subscribe(bob);


			assertEquals(bob.state, ActivityStatuses.UNKNOWN);
		}

		private function createMSG():Message {
			var message:Message = new Message();
			message.from = new UnescapedJID(bob.uid).escaped;
			return message;
		}
	}
}

import com.chat.model.activity.IActivityStatus;

class FakeActivity implements IActivityStatus {

	private var _uid:String;
	private var _state:int;

	public function FakeActivity(uid:String) {
		_uid = uid;
	}

	public function get uid():String {
		return _uid;
	}

	public function set state(value:int):void {
		_state = value;
	}

	public function get state():int {
		return _state;
	}
}