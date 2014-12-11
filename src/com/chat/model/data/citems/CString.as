/**
 * Created by kvint on 13.11.14.
 */
package com.chat.model.data.citems {
	public class CString implements ICItem {

		private var _data:String;

		public function CString(data:String) {
			_data = data;
		}

		public function get data():* {
			return _data;
		}

		public function toString():String {
			return _data;
		}
	}
}
