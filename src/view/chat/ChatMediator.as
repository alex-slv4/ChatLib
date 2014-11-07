/**
 * Created by kvint on 01.11.14.
 */
package view.chat
{
import events.ChatModelEvent;

import model.communicators.CommunicatorType;
import model.communicators.ICommunicator;

import robotlegs.extensions.starlingFeathers.impl.FeathersMediator;

import view.chat.communicator.types.DefaultCommunicatorView;
import view.chat.communicator.types.DirectCommunicatorView;
import view.chat.communicator.types.HistoryCommunicatorView;

public class ChatMediator extends FeathersMediator
{

	[Inject]
	public var view		:ChatView;

	[Inject]
	public var chat		:Chat;

	override public function initializeComplete():void
	{
		view.containerView.communicatorFactory.setViewClass(DirectCommunicatorView, CommunicatorType.DIRECT);
		view.containerView.communicatorFactory.setViewClass(HistoryCommunicatorView, CommunicatorType.DIRECT);
		view.containerView.communicatorFactory.setViewClass(DefaultCommunicatorView, CommunicatorType.TEAM);
		view.containerView.communicatorFactory.setViewClass(DefaultCommunicatorView, CommunicatorType.GLOBAL);

		chat.model.addEventListener(ChatModelEvent.COMMUNICATOR_ACTIVATED, model_onCommunicatorActivated)
	}

	private function model_onCommunicatorActivated(event:ChatModelEvent):void
	{
		view.containerView.communicatorProvider = event.data as ICommunicator;
	}

	override public function destroy():void
	{
		super.destroy();

		chat.model.removeEventListener(ChatModelEvent.COMMUNICATOR_ACTIVATED, model_onCommunicatorActivated)
	}
}
}
