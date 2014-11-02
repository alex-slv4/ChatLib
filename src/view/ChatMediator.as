/**
 * Created by kvint on 01.11.14.
 */
package view {
	import events.CommunicatorEvent;

	import flash.utils.Dictionary;

	import model.ChatModel;
	import model.CommunicatorTypes;
	import model.communicators.ICommunicator;

	import robotlegs.extensions.starlingFeathers.impl.FeathersMediator;

	import view.communicator.DefaultCommunicatorView;
	import view.communicator.DirectCommunicatorView;
	import view.communicator.ICommunicatorView;
	import view.communicator.LogCommunicatorView;

	public class ChatMediator extends FeathersMediator {

		[Inject]
		public var chatModel:ChatModel;
		private var _view:ChatView;
		private var _communicatorViewMap:Dictionary = new Dictionary();

		override public function initializeComplete():void {
			super.initializeComplete();

			_communicatorViewMap[CommunicatorTypes.DIRECT] = DirectCommunicatorView;
			_communicatorViewMap[CommunicatorTypes.LOG] = LogCommunicatorView;
			_communicatorViewMap[CommunicatorTypes.TEAM] = DefaultCommunicatorView;
			_communicatorViewMap[CommunicatorTypes.GLOBAL] = DefaultCommunicatorView;

			_view = viewComponent as ChatView;
			chatModel.addEventListener(CommunicatorEvent.CHANGE, onCommunicationChange);
			_view.communicatorView = constructCommunicator(_view.tabsView.selectedItem as ICommunicator);
		}
		private function onCommunicationChange(event:CommunicatorEvent):void {
			switch (event.type){
				case CommunicatorEvent.CHANGE:
					var data:ICommunicator = event.data as ICommunicator;
					_view.communicatorView = constructCommunicator(data);
					break;
			}
		}

		private function constructCommunicator(data:ICommunicator):ICommunicatorView {
			var communicatorView:ICommunicatorView = new _communicatorViewMap[data.type];
			communicatorView.provider.data = data;
			return  communicatorView;
		}

		override public function destroy():void {
			chatModel.removeEventListener(CommunicatorEvent.CHANGE, onCommunicationChange);
			super.destroy();
		}
	}
}
