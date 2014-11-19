/**
 * Created by AlexanderSla on 06.11.2014.
 */
package com.chat.model.communicators {
	import com.chat.controller.ChatController;
	import com.chat.events.ChatModelEvent;
	import com.chat.model.ChatModel;
	import com.chat.model.ChatRoom;
	import com.chat.model.communicators.factory.ICreator;

	import flash.utils.Dictionary;

	import org.as3commons.lang.DictionaryUtils;
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.im.RosterItemVO;

	import robotlegs.bender.framework.api.IInjector;

	public class CommunicatorProvider implements ICommunicatorProvider {

		private var hash:Dictionary = new Dictionary();

		[Inject]
		public var injector:IInjector;

		[Inject]
		public var model:ChatModel;

		[Inject]
		public var controller:ChatController;

		public var creatorsMap:Dictionary = new Dictionary();

		public function destroyCommunicator(communicator:ICommunicator):void {
			delete hash[communicator.uid];
			model.dispatchEvent(new ChatModelEvent(ChatModelEvent.COMMUNICATOR_DESTROYED, communicator));
			communicator.destroy();
		}
		public function getCommunicator(data:Object):ICommunicator {
			var creator:ICreator = creatorsMap[data.constructor];
			var communicator:ICommunicator = hash[creator.key];
			if(communicator == null){
				var communicator:ICommunicator = creator.create();
				hash[creator.key] = communicator;
				return communicator;
			}
			injector.injectInto(communicator);
			return communicator;
		}

		private function getCommunicatorForMessage(message:Message):ICommunicator {
			var isCurrentUserMessage:Boolean = message.from.equals(model.currentUser.jid.escaped, true);
			var keyJID:EscapedJID = isCurrentUserMessage ? message.to : message.from;
			var iCommunicator:ICommunicator;
			var key:String = keyJID.bareJID;
			if(message.type == Message.TYPE_GROUPCHAT){
				iCommunicator = hash[key] as ICommunicator;
				if(iCommunicator == null){
					var chatRoom:ChatRoom = new ChatRoom();
					chatRoom.join(keyJID.unescaped);
					iCommunicator = getCommunicatorForRoom(chatRoom);
				}
			}else{
				iCommunicator = hash[key] as ICommunicator;
				if(iCommunicator == null){
					iCommunicator = new DirectCommunicator(keyJID.unescaped, model.currentUser);
					addCommunicator(iCommunicator);
				}
			}
			return iCommunicator;
		}

		private function addCommunicator(iCommunicator:ICommunicator):void {
			hash[iCommunicator.uid] = iCommunicator;
			model.dispatchEvent(new ChatModelEvent(ChatModelEvent.COMMUNICATOR_ADDED, iCommunicator));
//			if (DictionaryUtils.getValues(hash).length == 1) {
				injector.injectInto(iCommunicator);
				iCommunicator.active = true;
//			}
		}
		private function getCommunicatorForRoom(chatRoom:ChatRoom):ICommunicator {
			var key:String = chatRoom.room.roomJID.bareJID;
			var iCommunicator:ICommunicator = hash[key] as ICommunicator;
			if(iCommunicator == null){
				iCommunicator = new RoomCommunicator(chatRoom);
				hash[iCommunicator.uid] = iCommunicator;
				model.dispatchEvent(new ChatModelEvent(ChatModelEvent.COMMUNICATOR_ADDED, iCommunicator));
			}
			injector.injectInto(iCommunicator);
			iCommunicator.active = true;
			return iCommunicator;
		}
		private function getCommunicatorForRoster(item:RosterItemVO):ICommunicator {
			var keyJID:UnescapedJID = item.jid;
			var key:String = keyJID.bareJID;
			var iCommunicator:ICommunicator = hash[key] as ICommunicator;
			if(iCommunicator == null){
				iCommunicator = new DirectCommunicator(keyJID, model.currentUser);
				addCommunicator(iCommunicator);
			}
			return iCommunicator;
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
