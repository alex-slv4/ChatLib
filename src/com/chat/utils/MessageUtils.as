/**
 * Created by kvint on 04.11.14.
 */
package com.chat.utils {
import com.chat.model.data.ChatMessage;

import org.igniterealtime.xiff.data.Message;

public class MessageUtils {
		public static function isMessageRead(message:ChatMessage):Boolean {
			return message.receipt == null || message.receipt == Message.RECEIPT_REQUEST;
		}
	}
}
