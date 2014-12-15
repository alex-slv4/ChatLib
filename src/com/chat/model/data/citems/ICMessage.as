/**
 * Created by kvint on 11.12.14.
 */
package com.chat.model.data.citems {
	import org.igniterealtime.xiff.data.Message;

	public interface ICMessage extends ICTime {

		function get messageData():Message;
		function get from():Object;
		function get body():Object;
		function get isRead():Boolean;
		function set isRead(value:Boolean):void;

	}
}
