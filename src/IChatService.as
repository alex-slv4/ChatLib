/**
 * Created by kvint on 01.11.14.
 */
package {
	import controller.ChatController;

	import feathers.controls.LayoutGroup;

	public interface IChatService {

		function get view():LayoutGroup;
		function get controller():ChatController;

	}
}
