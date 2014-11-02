/**
 * Created by kvint on 01.11.14.
 */
package {
	import controller.ChatController;

	import feathers.controls.LayoutGroup;

	import view.ChatView;

	public interface IChatService {

		function get view():ChatView;
		function get controller():ChatController;

	}
}
