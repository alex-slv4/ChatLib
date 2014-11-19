/**
 * Created by kvint on 19.11.14.
 */
package com.chat.model.communicators.factory {
	import com.chat.model.communicators.ICommunicator;

	public interface ICreator {
		function get key():String;
		function create():ICommunicator;
	}
}
