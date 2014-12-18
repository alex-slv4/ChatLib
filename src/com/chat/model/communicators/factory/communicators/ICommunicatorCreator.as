/**
 * Created by kvint on 19.11.14.
 */
package com.chat.model.communicators.factory.communicators {
	import com.chat.model.communicators.ICommunicator;

	public interface ICommunicatorCreator {
		function create():ICommunicator;
	}
}
