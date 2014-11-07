/**
 * Created by kvint on 01.11.14.
 */
package view.chat
{
import model.communicators.CommunicatorType;

import robotlegs.extensions.starlingFeathers.impl.FeathersMediator;

import view.chat.communicator.types.DefaultCommunicatorView;
import view.chat.communicator.types.DirectCommunicatorView;
import view.chat.communicator.types.HistoryCommunicatorView;

public class ChatMediator extends FeathersMediator
{

	[Inject]
	public var view		:ChatView;

	override public function initializeComplete():void
	{
		view.containerView.communicatorFactory.setViewClass(DirectCommunicatorView, CommunicatorType.DIRECT);
		view.containerView.communicatorFactory.setViewClass(HistoryCommunicatorView, CommunicatorType.DIRECT);
		view.containerView.communicatorFactory.setViewClass(DefaultCommunicatorView, CommunicatorType.TEAM);
		view.containerView.communicatorFactory.setViewClass(DefaultCommunicatorView, CommunicatorType.GLOBAL);
	}

}
}
