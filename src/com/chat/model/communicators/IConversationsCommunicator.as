/**
 * Created by kvint on 02.12.14.
 */
package com.chat.model.communicators {
	import com.chat.model.data.citems.ICItem;

	public interface IConversationsCommunicator extends ICommunicator {
		function updateUnreadCount():void;
		function push(data:ICItem):void;
	}
}
