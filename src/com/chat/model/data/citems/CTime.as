/**
 * Created by AlexanderSla on 15.12.2014.
 */
package com.chat.model.data.citems {
	public class CTime extends CItem implements ICItem, ICTime {

		private static var _serverTimeOffset:Number = 0;
		private var _time:Number;
		protected var _originTime:Number;

		public function CTime(data:*) {
			super(data);
		}

		public function set time(value:Number):void {
			_time = value;
		}
		public function get time():Number {
			return getTime(_time);
		}

		public static function get serverTimeOffset():Number {
			return _serverTimeOffset;
		}

		public static function set serverTimeOffset(value:Number):void {
			_serverTimeOffset = value;
		}

		public static function get currentTime():Number {
			return convertTimeFromDate(new Date());
		}

		public static function convertTimeFromDate(date:Date):Number {
			return getTime(date.time);
		}
		public static function getTime(time:Number):Number {
			return time + _serverTimeOffset;
		}

		public function set originTime(value:Number):void {
			_originTime = value;
		}

		public function get originTime():Number {
			return _originTime;
		}
	}
}
