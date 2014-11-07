/**
 * Created by AlexanderSla on 03.11.2014.
 */
package view.chat.roster {
	import feathers.controls.List;
	import feathers.core.FeathersControl;

	public class RosterView extends FeathersControl{

		private var _list:List = new List();

		override protected function initialize():void
		{
			addChild(list);
		}

		public function get list():List {
			return _list;
		}
	}
}
