/**
 * Created by kvint on 13.11.14.
 */
package com.chat.model.data.citems {
	public class CItemString extends BaseCItem {

		public function CItemString(data:String) {
			super(data);
		}

		override public function get body():Object {
			return _data;
		}
	}
}
