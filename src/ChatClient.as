package {

	import controller.ChatController;

	import model.ChatModel;

	import view.chat.ChatView;

	public class ChatClient implements Chat{

		[Inject]
		public var thisController		:ChatController;

		[Inject]
		public var _model				:ChatModel;

 		private var _view:ChatView
		private static var _instance	:ChatClient;

		static public function get instance():Chat
		{
			return _instance ||= new ChatClient();
		}

		public function ChatClient() {
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
