/**
 * Created by kvint on 01.11.14.
 */
package view.chat.communicator.types {
import view.chat.communicator.*;
	import model.ChatModel;
	import model.communicators.ICommunicator;

	import robotlegs.extensions.starlingFeathers.impl.FeathersMediator;

	public class DefaultCommunicatorMediator extends FeathersMediator {

		[Inject]
		public var chatModel:ChatModel;


		override public function initializeComplete():void {
			super.initializeComplete();
			view.provider.subscribe(onViewDataChanged);
		}

		protected function onViewDataChanged():void {

		}
		protected function get communicatorData():ICommunicator {
			return view.provider.data as ICommunicator;
		}

		protected function get view():ICommunicatorView {
			return viewComponent as ICommunicatorView;
		}

		override public function destroy():void {
			view.provider.unsubscribe(onViewDataChanged);
			super.destroy();
		}
	}
}
