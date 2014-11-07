/**
 * Created by kvint on 01.11.14.
 */
package view {
import model.ChatModel;
import model.communicators.CommunicatorType;
import model.communicators.ICommunicator;

import robotlegs.extensions.starlingFeathers.impl.FeathersMediator;

import view.communicator.DefaultCommunicatorView;
import view.communicator.DirectCommunicatorView;
import view.communicator.HistoryCommunicatorView;

public class ChatMediator extends FeathersMediator {

		[Inject]
		public var chatModel:ChatModel;
		private var _view:ChatView;

		override public function initializeComplete():void {
			_view = viewComponent as ChatView;

			_view.containerView.communicatorFactory.setViewClass(DirectCommunicatorView , CommunicatorType.DIRECT);
			_view.containerView.communicatorFactory.setViewClass(HistoryCommunicatorView , CommunicatorType.DIRECT);
			_view.containerView.communicatorFactory.setViewClass(DefaultCommunicatorView , CommunicatorType.TEAM);
			_view.containerView.communicatorFactory.setViewClass(DefaultCommunicatorView , CommunicatorType.GLOBAL);

			setCommunicators();

			_view.containerView.communicatorProvider = chatModel;

//			chatModel.addEventListener(ChatModelEvent.COMMUNICATOR_ADDED, communicatorEventHandler);
//			chatModel.addEventListener(ChatModelEvent.COMMUNICATOR_ACTIVATED, communicatorEventHandler);
//			_view.communicatorView = constructCommunicatorView(_view.tabsView.selectedItem as ICommunicator);
		}

	private function setCommunicators():void
	{
		for (var idx:int = 0; idx < chatModel.provider.getAll().length; idx++)
			addCommunicatorTab(chatModel.communicators[idx]);
	}

	private function addCommunicatorTab(provider:ICommunicator):void
	{
		_view.addCommunicatorTab(provider);
	}

		/*private function communicatorEventHandler(event:ChatModelEvent):void {
			switch (event.type){
				case ChatModelEvent.COMMUNICATOR_ADDED:

					break;
				case ChatModelEvent.COMMUNICATOR_ACTIVATED:
					var data:ICommunicator = event.data as ICommunicator;
					_view.communicatorView = constructCommunicatorView(data);
					break;
			}
		}*/

		/*private function constructCommunicatorView(data:ICommunicator):ICommunicatorView {
			var communicatorView:ICommunicatorView = new _communicatorViewMap[data.type];
			communicatorView.provider.data = data;
			return  communicatorView;
		}*/

		/*override public function destroy():void {
			chatModel.removeEventListener(ChatModelEvent.COMMUNICATOR_ACTIVATED, communicatorEventHandler);
			super.destroy();
		}*/
	}
}
