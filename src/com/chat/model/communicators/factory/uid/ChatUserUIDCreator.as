/**
 * Created by kuts on 11/27/14.
 */
package com.chat.model.communicators.factory.uid
{
	import com.chat.model.ChatUser;

	public class ChatUserUIDCreator extends DefaultUIDCreator {

	public function ChatUserUIDCreator(item:ChatUser) {
		super(item.jid);
	}
}
}
