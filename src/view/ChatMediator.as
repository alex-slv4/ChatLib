/**
 * Created by kvint on 01.11.14.
 */
package view {
	import events.ChatModelEvent;

	import flash.utils.Dictionary;

	import model.ChatModel;
	import model.communicators.CommunicatorTypes;
	import model.communicators.ICommunicator;

	import robotlegs.extensions.starlingFeathers.impl.FeathersMediator;

	import view.communicator.DefaultCommunicatorView;
	import view.communicator.DirectCommunicatorView;
	import view.communicator.ICommunicatorView;
	import view.communicator.HistoryCommunicatorView;

	public class ChatMediator extends FeathersMediator {

		[Inject]
		public var chatModel:ChatModel;
		private var _view:ChatView;
		private var _communicatorViewMap:Dictionary = new Dictionary();

		override public function initializeComplete():void {
			super.initializeComplete();

			_communicatorViewMap[CommunicatorTypes.DIRECT] = DirectCommunicatorView;
			_communicatorViewMap[CommunicatorTypes.LOG] = HistoryCommunicatorView;
			_communicatorViewMap[CommunicatorTypes.TEAM] = DefaultCommunicatorView;
			_communicatorViewMap[CommunicatorTypes.GLOBAL] = DefaultCommunicatorView;

			_view = viewComponent as ChatView;
			chatModel.addEventListener(ChatModelEvent.COMMUNICATOR_ADDED, communicatorEventHandler);
			chatModel.addEventListener(ChatModelEvent.COMMUNICATOR_ACTIVATED, communicatorEventHandler);
			_view.communicatorView = constructCommunicatorView(_view.tabsView.selectedItem as ICommunicator);
		}
		private function communicatorEventHandler(event:ChatModelEvent):void {
			switch (event.type){
				case ChatModelEvent.COMMUNICATOR_ADDED:

					break;
				case ChatModelEvent.COMMUNICATOR_ACTIVATED:
					var data:ICommunicator = event.data as ICommunicator;
					_view.communicatorView = constructCommunicatorView(data);
					break;
			}
		}

		private function constructCommunicatorView(data:ICommunicator):ICommunicatorView {
			var communicatorView:ICommunicatorView = new _communicatorViewMap[data.type];
			communicatorView.provider.data = data;
			return  communicatorView;
		}

		override public function destroy():void {
			chatModel.removeEventListener(ChatModelEvent.COMMUNICATOR_ACTIVATED, communicatorEventHandler);
			super.destroy();
		}
	}
}
