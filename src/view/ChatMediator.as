/**
 * Created by kvint on 01.11.14.
 */
package view
{
import model.ChatModel;
import model.communicators.CommunicatorType;
import model.communicators.ICommunicator;

import robotlegs.extensions.starlingFeathers.impl.FeathersMediator;

import view.communicator.DefaultCommunicatorView;
import view.communicator.DirectCommunicatorView;
import view.communicator.HistoryCommunicatorView;

public class ChatMediator extends FeathersMediator
{

	[Inject]
	public var chatModel:ChatModel;
	private var _view:ChatView;

	override public function initializeComplete():void
	{
		_view = viewComponent as ChatView;

		_view.containerView.communicatorFactory.setViewClass(DirectCommunicatorView, CommunicatorType.DIRECT);
		_view.containerView.communicatorFactory.setViewClass(HistoryCommunicatorView, CommunicatorType.DIRECT);
		_view.containerView.communicatorFactory.setViewClass(DefaultCommunicatorView, CommunicatorType.TEAM);
		_view.containerView.communicatorFactory.setViewClass(DefaultCommunicatorView, CommunicatorType.GLOBAL);
	}

}
}
