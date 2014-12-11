/**
 * Created by AlexanderSla on 10.12.2014.
 */
package com.chat.model.data.citems {
	public class CTitle extends CItem implements ICTime {

		private var _time:Number;

		public function CTitle(data:String, time:Number) {
			super(data);
			_time = time;
		}

		public function get time():Number {
			return _time;
		}
	}
}
