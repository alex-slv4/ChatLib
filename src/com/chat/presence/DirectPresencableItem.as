/**
 * Created by kvint on 19.11.14.
 */
package com.chat.presence {
	public class DirectPresencableItem implements IPresencable{

		private var _state:String;

		public function DirectPresencableItem() {
		}

		public function get state():String {
			return _state;
		}

		public function set state(value:String):void {
			_state = value;
		}
	}
}
