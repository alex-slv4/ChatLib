/**
 * Created by kvint on 11.12.14.
 */
package com.chat.model.data.citems {
	public interface ICMessage extends ICTime {

		function get from():Object;
		function get body():Object;
		function get isRead():Boolean;
		function set isRead(value:Boolean):void;

	}
}
