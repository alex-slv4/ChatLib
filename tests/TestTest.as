/**
 * Created by AlexanderSla on 17.11.2014.
 */
package {
	public class TestTest {
		public function TestTest() {
		}
		[Test]
		public function jidTest():void {

		}
		[Test(timeout=250)]
		public function anotherTest():void {
			trace("anotherTest")
		}
		[Test(timeout=250)]
		public function crashTest():void {

		}
	}
}
