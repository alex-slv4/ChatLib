/**
 * Created by kvint on 18.12.14.
 */
package com.chat.model.communicators.factory.uid {
	import com.chat.model.IChatModel;

	import org.igniterealtime.xiff.core.UnescapedJID;

	import org.igniterealtime.xiff.data.Message;

	public class MessageUIDCreator extends DefaultUIDCreator {
		[Inject]
		public var model:IChatModel;

		public function MessageUIDCreator(data:Object) {
			super(data);
		}

		override public function toString():String {
			if(data is Message){
				var msg:Message = data as Message;
				if(msg == null) return null;
				if(msg.from == null) return null;
				if(msg.to == null) return null;
				var isCurrentUserMessage:Boolean = model.isMe(msg.from);
				var from:UnescapedJID = isCurrentUserMessage ? msg.to.unescaped : msg.from.unescaped;
				return from.bareJID.toString();
			}
			return super.toString();
		}
	}
}
