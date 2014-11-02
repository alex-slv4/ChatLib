/**
 * Created by kvint on 01.11.14.
 */
package view {
	import model.ChatModel;

	import robotlegs.extensions.starlingFeathers.impl.FeathersMediator;

	import view.communicator.CommunicatorView;
	import view.tabs.DirectCommunicator;
	import view.tabs.GlobalCommunicator;
	import view.tabs.LogCommunicator;

	import view.tabs.TeamCommunicator;

	public class ChatMediator extends FeathersMediator {

		[Inject]
		public var chatModel:ChatModel;

		override public function initializeComplete():void {
			super.initializeComplete();
		}
	}
}
