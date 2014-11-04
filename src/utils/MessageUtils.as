/**
 * Created by kvint on 04.11.14.
 */
package utils {
	import org.igniterealtime.xiff.data.Message;

	public class MessageUtils {
		public static function isMessageRead(message:Message):Boolean {
			return message.receipt == null || message.receipt == Message.RECEIPT_REQUEST;
		}
	}
}
