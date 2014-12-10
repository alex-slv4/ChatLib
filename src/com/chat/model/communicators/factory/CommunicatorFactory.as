/**
 * Created by AlexanderSla on 06.11.2014.
 */
package com.chat.model.communicators.factory {
	import com.chat.model.ChatRoom;
	import com.chat.model.ChatUser;
	import com.chat.model.communicators.*;
	import com.chat.model.data.citems.CCommunicator;
	import com.chat.model.data.collections.CItemCollection;
	import com.chat.model.data.collections.ICItemCollection;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.im.RosterItemVO;

	import robotlegs.bender.framework.api.IInjector;

	public class CommunicatorFactory extends EventDispatcher implements ICommunicatorFactory {

		[Inject]
		public var injector:IInjector;

		public var creatorsMap:Dictionary = new Dictionary();
		private var _items:ICItemCollection = new CItemCollection();

		[PostConstruct]
		public function fillCreators():void{
			creatorsMap[Message] = MessageCreator;
			creatorsMap[ChatRoom] = RoomCreator;
			creatorsMap[RosterItemVO] = RosterItemCreator;
			creatorsMap[ChatUser] = ChatUserCreator;
			creatorsMap[CCommunicator] = ICItemCreator;
		}

		public function dispose(communicator:ICommunicator):void {
			if(communicator.uid != null){
				communicator.active = false;
				communicator.destroy();
				var i:int = getIndexBy(communicator.uid);
				items.remove(i);
			}
		}
		public function getFor(data:Object):ICommunicator {
			if(data == null) return null;

			var creatorClass:Class = creatorsMap[data.constructor];
			if(creatorClass == null) return null;

			var creator:ICreator = new creatorClass(data);
			injector.injectInto(creator);
			if(creator.uid == null) return null;

			var communicator:ICommunicator = getBy(creator.uid);
			if(communicator == null){
				communicator = creator.create();
				communicator.uid = creator.uid;
				injector.injectInto(communicator);
				items.append(new CCommunicator(communicator));
			}
			return communicator;
		}

		private function getBy(uid:String):ICommunicator {
			var i:int = getIndexBy(uid);
			if(i == -1) return null;
			var item:CCommunicator = (_items.getItemAt(i) as CCommunicator);
			return item.communicator;
		}
		private function getIndexBy(uid:String):int {
			for (var i:int = 0; i < _items.length; i++) {
				var item:CCommunicator = _items.getItemAt(i) as CCommunicator;
				if(item.communicator.uid == uid){
					return i;
				}
			}
			return -1;
		}

		public function get items():ICItemCollection {
			return _items;
		}
	}
}
