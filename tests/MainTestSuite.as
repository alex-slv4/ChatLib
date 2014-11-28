/**
 * Created by AlexanderSla on 21.11.2014.
 */
package {
	import tests.ActivitiesTest;
	import tests.FabricTest;
	import tests.PresencesTest;
	import tests.ThreadingTest;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class MainTestSuite {
		public var fabricTest:FabricTest;
		public var presencesTest:PresencesTest;
		public var activityTest:ActivitiesTest;
		public var threadingTest:ThreadingTest;
	}
}
