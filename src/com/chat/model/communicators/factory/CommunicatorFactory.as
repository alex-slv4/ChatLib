/**
 * Created by AlexanderSla on 06.11.2014.
 */
package com.chat.model.communicators.factory {
	import com.chat.events.CommunicatorFactoryEvent;
	import com.chat.model.ChatRoom;
import com.chat.model.ChatUser;
import com.chat.model.communicators.*;
import com.chat.model.data.CItemConversation;
import com.chat.model.data.ICItem;

import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.im.RosterItemVO;

	import robotlegs.bender.framework.api.IInjector;

	[Event(name="onCommunicatorAdded", type="com.chat.events.CommunicatorFactoryEvent")]
	[Event(name="onCommunicatorRemoved", type="com.chat.events.CommunicatorFactoryEvent")]
	[Event(name="onCommunicatorActivated", type="com.chat.events.CommunicatorFactoryEvent")]
	[Event(name="onCommunicatorActivated", type="com.chat.events.CommunicatorFactoryEvent")]
	public class CommunicatorFactory extends EventDispatcher implements ICommunicatorFactory {


		[Inject]
		public var injector:IInjector;

		public var creatorsMap:Dictionary = new Dictionary();
		private var hash:Dictionary = new Dictionary();

		[PostConstruct]
		public function fillCreators():void{
			creatorsMap[Message] = MessageCreator;
			creatorsMap[ChatRoom] = RoomCreator;
			creatorsMap[RosterItemVO] = RosterItemCreator;
			creatorsMap[ChatUser] = ChatUserCreator;
			creatorsMap[CItemConversation] = ICItemCreator;
		}

		public function dispose(communicator:ICommunicator):void {
			if(communicator.uid != null){
				delete hash[communicator.uid];
				dispatchEvent(new CommunicatorFactoryEvent(CommunicatorFactoryEvent.COMMUNICATOR_DESTROYED, communicator));
				communicator.active = false;
				communicator.destroy();
			}
		}
		public function getFor(data:Object):ICommunicator {
			if(data == null) return null;

			var creatorClass:Class = creatorsMap[data.constructor];
			if(creatorClass == null) return null;

			var creator:ICreator = new creatorClass(data);
			injector.injectInto(creator);
			if(creator.uid == null) return null;

			var communicator:ICommunicator = hash[creator.uid];
			if(communicator == null){
				communicator = creator.create();
				communicator.uid = creator.uid;
				hash[creator.uid] = communicator;
				injector.injectInto(communicator);
				dispatchEvent(new CommunicatorFactoryEvent(CommunicatorFactoryEvent.COMMUNICATOR_ADDED, communicator));
			}
			return communicator;
		}

		public function getAll():Vector.<ICommunicator> {
			var result:Vector.<ICommunicator> = new <ICommunicator>[];
			for each (var communicator:ICommunicator in hash) {
				result.push(communicator);
			}
			return result;
		}
	}
}
