/**
 * Created by kvint on 16.11.14.
 */
package com.chat.model.data.citems {
	public class BaseCItem implements ICItem {

		private var _isRead:Boolean = false;
		protected var _data:Object;

		public function BaseCItem(data:Object) {
			_data = data;
		}

		public function get time():Number {
			return 0;
		}

		public function get from():Object {
			return null;
		}

		public function get body():Object {
			return null;
		}

		public function get isRead():Boolean {
			return _isRead;
		}

		public function set isRead(value:Boolean):void {
			_isRead = value;
		}

		public function get data():Object {
			return _data;
		}
	}
}
