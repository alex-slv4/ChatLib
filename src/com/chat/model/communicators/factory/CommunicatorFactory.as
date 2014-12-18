/**
 * Created by AlexanderSla on 06.11.2014.
 */
package com.chat.model.communicators.factory {
	import com.chat.model.ChatRoom;
	import com.chat.model.ChatUser;
	import com.chat.model.communicators.*;
	import com.chat.model.data.collections.CItemCollection;
	import com.chat.model.data.collections.ICItemCollection;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	import org.igniterealtime.xiff.core.AbstractJID;
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.im.RosterItemVO;

	import robotlegs.bender.framework.api.IInjector;

	public class CommunicatorFactory extends EventDispatcher implements ICommunicatorFactory {

		[Inject]
		public var injector:IInjector;

		public var creatorsMap:Dictionary = new Dictionary();
		private var _items:ICItemCollection = new CItemCollection();

		[PostConstruct]
		public function init():void{
			creatorsMap[Message] = MessageCreator;
			creatorsMap[ChatRoom] = RoomCreator;
			creatorsMap[RosterItemVO] = RosterItemCreator;
			creatorsMap[ChatUser] = ChatUserCreator;

			creatorsMap[AbstractJID] = JIDCreator;
			creatorsMap[UnescapedJID] = JIDCreator;
			creatorsMap[EscapedJID] = JIDCreator;
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
				items.append(communicator);
			}
			return communicator;
		}

		private function getBy(uid:String):ICommunicator {
			var i:int = getIndexBy(uid);
			if(i == -1) return null;
			return items.getItemAt(i) as ICommunicator;
		}
		private function getIndexBy(uid:String):int {
			for (var i:int = 0; i < items.length; i++) {
				var item:ICommunicator = items.getItemAt(i) as ICommunicator;
				if(item.uid.toLowerCase() == uid.toLowerCase()){
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
