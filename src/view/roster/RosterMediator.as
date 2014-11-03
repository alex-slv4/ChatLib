/**
 * Created by AlexanderSla on 03.11.2014.
 */
package view.roster {
	import controller.ChatController;

	import feathers.controls.List;
	import feathers.data.ListCollection;

	import model.ChatModel;
	import org.igniterealtime.xiff.data.im.RosterItemVO;

	import org.igniterealtime.xiff.events.RosterEvent;

	import robotlegs.extensions.starlingFeathers.impl.FeathersMediator;

	import starling.events.Event;

	public class RosterMediator extends FeathersMediator {

		[Inject]
		public var chatModel:ChatModel;

		[Inject]
		public var chatController		:ChatController;

		private var _view:RosterView;

		override public function initializeComplete():void {
			super.initializeComplete();
			_view = viewComponent as RosterView;
			_view.list.addEventListener(Event.CHANGE, listChangeHandler);
			chatModel.addEventListener(RosterEvent.ROSTER_LOADED, onRosterLoaded);
			displayRoster();
		}

		private function listChangeHandler(event:Event):void {
			var ri:RosterItemVO = (event.currentTarget as List).selectedItem as RosterItemVO;
			chatController.startChatWithJID(ri.jid);
		}

		private function onRosterLoaded(event:RosterEvent):void {
			displayRoster();
		}

		private function displayRoster():void {
			_view.list.dataProvider = new ListCollection(chatModel.roster.source);
		}
	}
}
