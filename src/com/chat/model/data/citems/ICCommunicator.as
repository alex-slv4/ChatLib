/**
 * Created by kvint on 11.12.14.
 */
package com.chat.model.data.citems {
	import com.chat.model.communicators.ICommunicator;

	public interface ICCommunicator extends ICTime {

		function get communicator():ICommunicator;

		function get lastMessage():ICMessage;
	}
}
