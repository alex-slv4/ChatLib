/**
 * Created by kvint on 02.12.14.
 */
package com.chat.model.communicators {
	public interface IConversationsCommunicator extends ICommunicatorBase {
		function updateUnreadCount():void;
	}
}
