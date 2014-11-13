/**
 * Created by kvint on 13.11.14.
 */
package com.chat.model.data {
	public interface ICItem {
		function get uid():Object;
		function get time():Number;
		function get from():Object;
		function get body():Object;
		function get isRead():Boolean;
	}
}
