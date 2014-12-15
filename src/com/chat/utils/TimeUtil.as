/**
 * Created by AlexanderSla on 15.12.2014.
 */
package com.chat.utils {
	public class TimeUtil {

		private static var _serverTimeOffset:Number;

		public static function get serverTimeOffset():Number {
			return _serverTimeOffset;
		}

		public static function set serverTimeOffset(value:Number):void {
			_serverTimeOffset = value;
		}

		public static function get currentTime():Number {
			return convertTime(new Date());
		}

		private static function convertTime(date:Date):Number {
			return date.time + _serverTimeOffset;
		}
	}
}
