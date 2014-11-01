package {

	import controller.ChatController;

	import feathers.controls.LayoutGroup;

	import model.ChatModel;

	import view.ChatView;

	public class ChatService implements IChatService{

		[Inject]
		public var thisController		:ChatController;

		[Inject]
		public var model				:ChatModel;

 		private var _view:ChatView

		public function ChatService() {
			_view = new ChatView();
		}

		public function get view():LayoutGroup {
			return _view;
		}


		public function get controller():ChatController {
			return thisController;
		}
	}
}
