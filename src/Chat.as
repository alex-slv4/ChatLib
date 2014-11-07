/**
 * Created by kvint on 01.11.14.
 */
package {
import controller.ChatController;

import model.ChatModel;

public interface Chat {

		function get model():ChatModel;
		function get controller():ChatController;

	}
}
