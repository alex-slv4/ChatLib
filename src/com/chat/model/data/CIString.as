/**
 * Created by kvint on 13.11.14.
 */
package com.chat.model.data {
	public class CIString implements ICItem {

		private var _data:String;

		public function CIString(data:String) {
			_data = data;
		}

		public function get time():Number {
			return 0;
		}

		public function get from():Object {
			return null;
		}

		public function get body():Object {
			return _data;
		}

		public function get isRead():Boolean {
			return false;
		}
	}
}
