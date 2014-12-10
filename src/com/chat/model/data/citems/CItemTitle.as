/**
 * Created by AlexanderSla on 10.12.2014.
 */
package com.chat.model.data.citems {
	public class CItemTitle extends CItemString {

		private var _time:Number;

		public function CItemTitle(data:String, time:Number) {
			super(data);
			_time = time;
		}

		override public function get time():Number {
			return _time;
		}
	}
}
