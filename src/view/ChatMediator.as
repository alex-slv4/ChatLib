/**
 * Created by kvint on 01.11.14.
 */
package view {
	import events.CommunicatorEvent;

	import flash.utils.Dictionary;

	import model.ChatModel;
	import model.CommunicatorTypes;
	import model.ICommunicator;

	import robotlegs.extensions.starlingFeathers.impl.FeathersMediator;

	import view.communicator.CommunicatorView;

	public class ChatMediator extends FeathersMediator {

		[Inject]
		public var chatModel:ChatModel;
		private var _view:ChatView;
		private var _communicatorViewMap:Dictionary = new Dictionary();

		override public function initializeComplete():void {
			super.initializeComplete();

			_communicatorViewMap[CommunicatorTypes.DIRECT] = CommunicatorView;
			_communicatorViewMap[CommunicatorTypes.LOG] = CommunicatorView;
			_communicatorViewMap[CommunicatorTypes.TEAM] = CommunicatorView;
			_communicatorViewMap[CommunicatorTypes.GLOBAL] = CommunicatorView;

			_view = viewComponent as ChatView;
			chatModel.addEventListener(CommunicatorEvent.CHANGE, onCommunicationChange);
		}
		private function onCommunicationChange(event:CommunicatorEvent):void {
			switch (event.type){
				case CommunicatorEvent.CHANGE:
					var data:ICommunicator = event.data as ICommunicator;
					_view.communicatorView = constructCommunicator(data);
					break;
			}
		}

		private function constructCommunicator(data:ICommunicator):CommunicatorView {
			return new _communicatorViewMap[data.type];
		}

		override public function destroy():void {
			chatModel.removeEventListener(CommunicatorEvent.CHANGE, onCommunicationChange);
			super.destroy();
		}
	}
}
