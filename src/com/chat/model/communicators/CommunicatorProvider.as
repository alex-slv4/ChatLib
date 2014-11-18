/**
 * Created by AlexanderSla on 06.11.2014.
 */
package com.chat.model.communicators {
	import com.chat.controller.ChatController;
	import com.chat.events.ChatModelEvent;
	import com.chat.model.ChatModel;
	import com.chat.model.ChatRoom;

	import flash.utils.Dictionary;

	import org.as3commons.lang.DictionaryUtils;
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.im.RosterItemVO;

	import robotlegs.bender.framework.api.IInjector;

	public class CommunicatorProvider implements ICommunicatorProvider {

		private var _privateCommunications:Dictionary = new Dictionary();
		private var _roomCommunications:Dictionary = new Dictionary();

		[Inject]
		public var injector:IInjector;

		[Inject]
		public var model:ChatModel;

		[Inject]
		public var controller:ChatController;

		public function destroyCommunicator(communicator:ICommunicator):void {
			var key:String;
			for (key in _privateCommunications) {
				if(_privateCommunications[key] == communicator){
					delete _privateCommunications[key];
				}
			}
			for (key in _roomCommunications) {
				if(_roomCommunications[key] == communicator){
					delete _roomCommunications[key];
				}
			}
			model.dispatchEvent(new ChatModelEvent(ChatModelEvent.COMMUNICATOR_DESTROYED, communicator));

			communicator.active = false;
			communicator.destroy();
		}
		public function getCommunicator(data:Object):ICommunicator {
			var constructFunc:Function;
			switch (data.constructor){
				case RosterItemVO:
					constructFunc = getCommunicatorForRoster;
					break;
				case Message:
					constructFunc = getCommunicatorForMessage;
					break;
				case ChatRoom:
					constructFunc = getCommunicatorForRoom;
			}
			var iCommunicator:ICommunicator = constructFunc(data);
			return iCommunicator;
		}

		private function getCommunicatorForMessage(message:Message):ICommunicator {
			var isCurrentUserMessage:Boolean = message.from.equals(model.currentUser.jid.escaped, true);
			var keyJID:EscapedJID = isCurrentUserMessage ? message.to : message.from;
			var iCommunicator:ICommunicator;
			var key:String = keyJID.bareJID;
			if(message.type == Message.TYPE_GROUPCHAT){
				iCommunicator = _roomCommunications[key] as ICommunicator;
				if(iCommunicator == null){
					var chatRoom:ChatRoom = new ChatRoom();
					chatRoom.join(keyJID.unescaped);
					iCommunicator = getCommunicatorForRoom(chatRoom);
				}
			}else{
				iCommunicator = _privateCommunications[key] as ICommunicator;
				if(iCommunicator == null){
					iCommunicator = new DirectCommunicator(keyJID.unescaped, model.currentUser);
					addCommunicator(iCommunicator);
				}
			}
			return iCommunicator;
		}

		private function addCommunicator(iCommunicator:ICommunicator):void {
			_privateCommunications[iCommunicator.uid] = iCommunicator;
			model.dispatchEvent(new ChatModelEvent(ChatModelEvent.COMMUNICATOR_ADDED, iCommunicator));
			if (DictionaryUtils.getValues(_privateCommunications).length == 1) {
				injector.injectInto(iCommunicator);
				iCommunicator.active = true;
			}
		}
		private function getCommunicatorForRoom(chatRoom:ChatRoom):ICommunicator {
			var key:String = chatRoom.room.roomJID.bareJID;
			var iCommunicator:ICommunicator = _roomCommunications[key] as ICommunicator;
			if(iCommunicator == null){
				iCommunicator = new RoomCommunicator(chatRoom);
				_roomCommunications[iCommunicator.uid] = iCommunicator;
				model.dispatchEvent(new ChatModelEvent(ChatModelEvent.COMMUNICATOR_ADDED, iCommunicator));
			}
			injector.injectInto(iCommunicator);
			iCommunicator.active = true;
			return iCommunicator;
		}
		private function getCommunicatorForRoster(item:RosterItemVO):ICommunicator {
			var keyJID:UnescapedJID = item.jid;
			var key:String = keyJID.bareJID;
			var iCommunicator:ICommunicator = _privateCommunications[key] as ICommunicator;
			if(iCommunicator == null){
				iCommunicator = new DirectCommunicator(keyJID, model.currentUser);
				addCommunicator(iCommunicator);
			}
			return iCommunicator;
		}

		public function getAll():Vector.<ICommunicatorBase> {
			var result:Vector.<ICommunicatorBase> = new <ICommunicatorBase>[];
			for each (var communicator:ICommunicator in _privateCommunications) {
				result.push(communicator);
			}
			for each (communicator in _roomCommunications) {
				result.push(communicator);
			}
			return result;
		}
	}
}
