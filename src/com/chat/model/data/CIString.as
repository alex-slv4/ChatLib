/**
 * Created by kvint on 13.11.14.
 */
package com.chat.model.data {
	public class CIString extends BaseCItem {

		public function CIString(data:String) {
			super(data);
		}

		override public function get body():Object {
			return _data;
		}
	}
}
