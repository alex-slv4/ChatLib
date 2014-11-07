/**
 * Created by kvint on 01.11.14.
 */
package view.chat.tabs
{
import events.ChatModelEvent;

import feathers.data.ListCollection;

import model.communicators.ICommunicator;

import robotlegs.extensions.starlingFeathers.impl.FeathersMediator;

import starling.events.Event;

public class CommunicatorsTabsMediator extends FeathersMediator
{

	[Inject]
	public var view:CommunicatorsTabsView;

	[Inject]
	public var chat:Chat;

	override public function initializeComplete():void
	{
		view.dataProvider = new ListCollection();

		setTabs();

		chat.model.addEventListener(ChatModelEvent.COMMUNICATOR_ADDED, model_handleEvent);
		chat.model.addEventListener(ChatModelEvent.COMMUNICATOR_ACTIVATED, model_handleEvent);

		mapStarlingEvent(view, Event.CHANGE, view_onChange);

		view.tabFactory = function ():CommunicatorTabView
		{
			return new CommunicatorTabView();
		};

		view.tabInitializer = tabInitializer;
	}

	override public function destroy():void
	{
		chat.model.removeEventListener(ChatModelEvent.COMMUNICATOR_ADDED, model_handleEvent);
		chat.model.removeEventListener(ChatModelEvent.COMMUNICATOR_ACTIVATED, model_handleEvent);
	}

	protected function tabInitializer(tab:CommunicatorTabView, communicator:ICommunicator):void
	{
		tab.provider.data = communicator;
	}

	private function setTabs():void
	{
		var iCommunicators:Vector.<ICommunicator> = chat.model.provider.getAll();
		for (var idx:int = 0; idx < iCommunicators.length; idx++)
			addTab(iCommunicators[idx]);
	}

	private function addTab(provider:ICommunicator):void
	{
		view.dataProvider.addItem(provider);
	}

	private function view_onChange():void
	{
		var communicator:ICommunicator = view.selectedItem as ICommunicator;
		communicator.activate();
	}

	private function model_handleEvent(event:ChatModelEvent):void
	{
		switch (event.type)
		{
			case ChatModelEvent.COMMUNICATOR_ADDED:
				addTab(event.data as ICommunicator);
				break;
			case ChatModelEvent.COMMUNICATOR_ACTIVATED:
				for (var idx:int = 0; idx < view.dataProvider.length; idx++)
				{
					var provider:ICommunicator = view.dataProvider.getItemAt(idx) as ICommunicator;
					;

					if (event.data == provider)
						view.selectedIndex = idx;
				}
				break;
		}
	}

}
}
