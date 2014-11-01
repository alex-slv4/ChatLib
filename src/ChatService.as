package {

	import controller.ChatController;

	import feathers.controls.LayoutGroup;

	import view.ChatView;

	public class ChatService implements IChatService{

 		private var _view:ChatView;
		private var _controller:ChatController;

		public function ChatService() {
			_view = new ChatView();
			_controller = new ChatController();
		}

		public function get view():LayoutGroup {
			return _view;
		}

		public function get controller():ChatController {
			return _controller;
		}
	}
}
