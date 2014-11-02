/**
 * Created by kvint on 02.11.14.
 */
package events {
	import flash.events.Event;

	public class DataEvent extends Event {

		protected var _data:Object;

		public function DataEvent(type:String, data:Object, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			_data = data;
		}
		public function get data():Object {
			return _data;
		}
	}
}
