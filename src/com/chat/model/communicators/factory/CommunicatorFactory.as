/**
 * Created by AlexanderSla on 06.11.2014.
 */
package com.chat.model.communicators.factory {
	import com.chat.model.ChatRoom;
	import com.chat.model.ChatUser;
	import com.chat.model.communicators.*;
	import com.chat.model.communicators.DefaultCommunicator;
	import com.chat.model.communicators.factory.communicators.DefaultCommunicatorCreator;
	import com.chat.model.communicators.factory.communicators.ICommunicatorCreator;
	import com.chat.model.communicators.factory.communicators.MessageCreator;
	import com.chat.model.communicators.factory.communicators.RoomCreator;
	import com.chat.model.communicators.factory.uid.ChatUserUIDCreator;
	import com.chat.model.communicators.factory.uid.DefaultUIDCreator;
	import com.chat.model.communicators.factory.uid.IUIDCreator;
	import com.chat.model.communicators.factory.uid.MessageUIDCreator;
	import com.chat.model.communicators.factory.uid.RoomUIDCreator;
	import com.chat.model.communicators.factory.uid.RosterItemUIDCreator;
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

		private var _creatorsMap:Dictionary = new Dictionary();
		private var _uidsMap:Dictionary = new Dictionary();
		private var _items:ICItemCollection = new CItemCollection();

		[PostConstruct]
		public function init():void{
			_creatorsMap[Message] = MessageCreator;
			_creatorsMap[ChatRoom] = RoomCreator;

			_uidsMap[ChatRoom] = RoomUIDCreator;
			_uidsMap[ChatUser] = ChatUserUIDCreator;
			_uidsMap[RosterItemVO] = RosterItemUIDCreator;
			_uidsMap[Message] = MessageUIDCreator;

		}

		public function dispose(communicator:ICommunicator):void {
			if(communicator.uid != null){
				communicator.active = false;
				var i:int = getIndexBy(communicator.uid);
				communicator.destroy();
				items.remove(i);
			}
		}
		public function getFor(data:Object):ICommunicator {
			if(data == null) return null;

			var uid:String = getUID(data);

			var communicator:ICommunicator = getBy(uid);
			if(communicator != null) return communicator;

			communicator = createCommunicator(data, uid);
			items.append(communicator);

			return communicator;
		}

		private function createCommunicator(data:Object, uid:String):ICommunicator {
			var CreatorClass:Class = _creatorsMap[data.constructor];
			if (CreatorClass == null) CreatorClass = DefaultCommunicatorCreator;
			var creator:ICommunicatorCreator = new CreatorClass(data, uid);
			injector.injectInto(creator);
			var createdData = creator.create();
			if(createdData is ICommunicator) {
				createdData.uid = uid;
				injector.injectInto(createdData);
			} else if(createdData != null) {
				return createCommunicator(createdData, uid);
			}
			return createdData;
		}

		private function getUID(data:Object):String {
			var UIDCreator:Class = _uidsMap[data.constructor];
			if (UIDCreator == null) UIDCreator = DefaultUIDCreator;
			var uidCreator:IUIDCreator = new UIDCreator(data);
			injector.injectInto(uidCreator);
			var uid:String = uidCreator.toString();
			if(uid == null){
				throw new Error("UID generation failed by " + UIDCreator + " for " + data);
			}
			return uid;
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

		public function get creatorsMap():Dictionary {
			return _creatorsMap;
		}
	}
}
