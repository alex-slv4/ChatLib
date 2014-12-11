/**
 * Created by AlexanderSla on 11.12.2014.
 */
package com.chat.model.data.citems {
	import org.igniterealtime.xiff.core.AbstractJID;

	public interface ICConversation extends ICCommunicator {

		function get withJID():AbstractJID;

		function get last():ICItem;
	}
}
