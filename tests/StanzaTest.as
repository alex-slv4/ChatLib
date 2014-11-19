/**
 * Created by kvint on 17.11.14.
 */
package {

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNull;
	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.rsm.RSMSet;

	public class StanzaTest {

		private var _rsm:RSMSet;

		[Before]
		public function setUp():void {
			_rsm = new RSMSet();
		}

		[Test]
		public function testFieldNull():void {

			_rsm.xml = <set xmlns="http://jabber.org/protocol/rsm">
				<first>179</first>
				<count>11</count>
			</set>;
			assertNull(_rsm.last);
			assertEquals(_rsm.firstIndex, 0);
			//TODO: return null somehow
			assertEquals(_rsm.index, 0);
			assertEquals(_rsm.count, 11);
			assertEquals(_rsm.first, "179");

			_rsm.first = null;

			assertNull(_rsm.first);
		}

		[Test]
		public function testMessage():void {
			var msg:Message = new Message();
			assertNull(msg.from);
			assertNull(msg.body);
			assertNull(msg.to);
		}
	}
}
