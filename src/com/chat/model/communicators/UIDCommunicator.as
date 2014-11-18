/**
 * Created by kvint on 18.11.14.
 */
package com.chat.model.communicators {
	public interface UIDCommunicator extends ICommunicator {

		function get uid():String;

		function get type():int;

		function get name():String;

	}
}
