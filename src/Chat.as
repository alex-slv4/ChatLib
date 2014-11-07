/**
 * Created by kvint on 01.11.14.
 */
package {
	import controller.ChatController;

	import feathers.controls.LayoutGroup;

	import model.ChatModel;

	import view.chat.ChatView;

	public interface Chat {

		function get model():ChatModel;
		function get view():ChatView;
		function get controller():ChatController;

	}
}
