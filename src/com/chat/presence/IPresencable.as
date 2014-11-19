/**
 * Created by kvint on 19.11.14.
 */
package com.chat.presence {
	public interface IPresencable {
		function get state():String;
		function set state(value:String):void;
	}
}
