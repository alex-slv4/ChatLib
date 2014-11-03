package {

	import controller.ChatController;

	import model.ChatModel;

	import view.ChatView;

	public class ChatService implements IChatService{

		[Inject]
		public var thisController		:ChatController;

		[Inject]
		public var _model				:ChatModel;

 		private var _view:ChatView
		private static var _instance	:ChatService;

		static public function get instance():IChatService
		{
			return _instance ||= new ChatService();
		}

		public function ChatService() {
			_view = new ChatView();
		}

		public function get view():ChatView {
			return _view;
		}


		public function get model():ChatModel {
			return _model;
		}

		public function get controller():ChatController {
			return thisController;
		}
	}
}
