/**
 * Created by kvint on 02.11.14.
 */
package com.chat.events {
	import flash.events.Event;

	public class DataEvent extends Event {

		public static const LAST_CHANGED:String = "onLastChanged";

		protected var _data:Object;

		public function DataEvent(type:String, data:Object, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			_data = data;
		}
		public function get data():Object {
			return _data;
		}

		override public function clone():Event {
			return new DataEvent(type, data, bubbles, cancelable);
		}
	}
}
