/**
 * Created by kvint on 01.11.14.
 */
package view.tabs
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
	public var chat:ChatClient;

	override public function initializeComplete():void
	{
		view.dataProvider = new ListCollection();

		setTabs();

		chat.model.addEventListener(ChatModelEvent.COMMUNICATOR_ADDED, model_handleEvent);
		chat.model.addEventListener(ChatModelEvent.COMMUNICATOR_ACTIVATED, model_handleEvent);

		mapStarlingEvent(view, Event.CHANGE, view_onChange);

		view.tabFactory = function():ChatTabView{
			return new ChatTabView();
		};

		view.tabInitializer = function(tab:ChatTabView, data:ICommunicator):ChatTabView{
			tab.provider.data = data;
			tab.label = data.label; //FIXME: feathers bug?
		};

		/*
		 ;

		 view.dataProvider = new ListCollection([
		 new LogCommunicator(),
		 new GlobalCommunicator(),
		 new TeamCommunicator(),
		 ]);
		 mapStarlingEvent(view, Event.CHANGE, onTabSelected);
		 chatModel.addEventListener(ChatModelEvent.COMMUNICATOR_ADDED, onCommunicatorAdded);
		 onTabSelected();*/
	}

	private function setTabs():void
	{
		for (var idx:int = 0; idx < chat.model.provider.getAll().length; idx++)
			addTab(chat.model.provider.getAll()[idx]);
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

	private function model_handleEvent(event:ChatModelEvent):void {
		switch (event.type){
			case ChatModelEvent.COMMUNICATOR_ADDED:
				addTab(event.data as ICommunicator);
				break;
			case ChatModelEvent.COMMUNICATOR_ACTIVATED:
				for (var idx:int = 0; idx < view.dataProvider.length; idx++)
				{
					var provider:ICommunicator = view.dataProvider.getItemAt(idx) as ICommunicator;;

					if (event.data == provider)
						view.selectedIndex = idx;
				}
				break;
		}
	}

	override public function destroy():void
	{
		super.destroy();
	}
}
}
