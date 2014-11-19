/**
 * Created by AlexanderSla on 06.11.2014.
 */
package com.chat.model.communicators.factory {
	import com.chat.model.communicators.*;
	import com.chat.controller.ChatController;
	import com.chat.events.ChatModelEvent;
	import com.chat.model.ChatModel;
	import com.chat.model.ChatRoom;
	import com.chat.model.communicators.factory.ICreator;
	import com.chat.model.communicators.factory.MessageCreator;
	import com.chat.model.communicators.factory.RoomCreator;
	import com.chat.model.communicators.factory.RosterItemCreator;

	import flash.utils.Dictionary;

	import org.as3commons.lang.Assert;

	import org.as3commons.lang.DictionaryUtils;
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.im.RosterItemVO;

	import robotlegs.bender.framework.api.IInjector;

	public class CommunicatorFactory implements ICommunicatorProvider {

		private var hash:Dictionary = new Dictionary();

		[Inject]
		public var injector:IInjector;

		[Inject]
		public var model:ChatModel;

		[Inject]
		public var controller:ChatController;

		public var creatorsMap:Dictionary = new Dictionary();

		[PostConstruct]
		public function fillCreators():void{
			creatorsMap[Message] = MessageCreator;
			creatorsMap[ChatRoom] = RoomCreator;
			creatorsMap[RosterItemVO] = RosterItemCreator;
		}

		public function destroyCommunicator(communicator:ICommunicator):void {
			delete hash[communicator.uid];
			model.dispatchEvent(new ChatModelEvent(ChatModelEvent.COMMUNICATOR_DESTROYED, communicator));
			communicator.destroy();
		}
		public function getCommunicator(data:Object):ICommunicator {

			var creatorClass:Class = creatorsMap[data.constructor];
			Assert.notNull(creatorClass, "Creator class for " + data.constructor + " doesn't exist");

			var creator:ICreator = new creatorClass(data);
			injector.injectInto(creator);
			Assert.notNull(creator.uid, "Creator uid not implemented");

			var communicator:ICommunicator = hash[creator.uid];
			if(communicator == null){
				var communicator:ICommunicator = creator.create();
				communicator.uid = creator.uid;
				hash[creator.uid] = communicator;
			}
			injector.injectInto(communicator);
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
