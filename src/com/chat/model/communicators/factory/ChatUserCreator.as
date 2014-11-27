/**
 * Created by kuts on 11/27/14.
 */
package com.chat.model.communicators.factory
{
import com.chat.model.ChatUser;
import com.chat.model.IChatModel;
import com.chat.model.communicators.DirectCommunicator;
import com.chat.model.communicators.ICommunicator;

public class ChatUserCreator implements ICreator
{
	[Inject]
	public var model:IChatModel;

	private var _chatUser:ChatUser;

	public function ChatUserCreator(item:ChatUser) {
		_chatUser = item;
	}

	public function get uid():String {
		return _chatUser.jid.bareJID;
	}

	public function create():ICommunicator {
		return new DirectCommunicator(_chatUser.jid, model.currentUser);
	}
}
}
