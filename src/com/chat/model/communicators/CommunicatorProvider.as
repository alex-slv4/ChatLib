/**
 * Created by AlexanderSla on 06.11.2014.
 */
package com.chat.model.communicators {
import com.chat.controller.ChatController;
import com.chat.events.ChatModelEvent;
import com.chat.model.ChatModel;
import com.chat.model.ChatRoom;
import com.chat.model.data.ChatMessage;

import flash.utils.Dictionary;

import org.as3commons.lang.DictionaryUtils;
import org.igniterealtime.xiff.core.EscapedJID;
import org.igniterealtime.xiff.core.UnescapedJID;
import org.igniterealtime.xiff.data.Message;
import org.igniterealtime.xiff.data.im.RosterItemVO;

public class CommunicatorProvider implements ICommunicatorProvider {

		private var _model:ChatModel;
		private var _controller:ChatController;
		private var _privateCommunications:Dictionary = new Dictionary();
		private var _roomCommunications:Dictionary = new Dictionary();

		public function getCommunicator(data:Object):ICommunicator {
			var constructFunc:Function;
			switch (data.constructor){
				case RosterItemVO:
					constructFunc = getCommunicatorForRoster;
					break;
				case Message:
				case ChatMessage:
					constructFunc = getCommunicatorForMessage;
					break;
				case ChatRoom:
					constructFunc = getCommunicatorForRoom;
			}
			return constructFunc(data);
		}

		private function getCommunicatorForMessage(message:Message):ICommunicator {
			var isCurrentUserMessage:Boolean = message.from.equals(_model.currentUser.jid.escaped, true);
			var keyJID:EscapedJID = isCurrentUserMessage ? message.to : message.from;
			var iCommunicator:ICommunicator;
			var key:String = keyJID.bareJID;
			if(message.type == Message.TYPE_GROUPCHAT){
				iCommunicator = _roomCommunications[key] as ICommunicator;
				if(iCommunicator == null){
					throw new Error("No room for", key);
				}
			}else{
				iCommunicator = _privateCommunications[key] as ICommunicator;
				if(iCommunicator == null){
					iCommunicator = new DirectCommunicator(keyJID.unescaped, _model.currentUser);
					addCommunicator(key, iCommunicator);
				}
			}
			return iCommunicator;
		}

		private function addCommunicator(key:String, iCommunicator:ICommunicator):void {
			_privateCommunications[key] = iCommunicator;
			_model.dispatchEvent(new ChatModelEvent(ChatModelEvent.COMMUNICATOR_ADDED, iCommunicator));
			if (DictionaryUtils.getValues(_privateCommunications).length == 1) {
				_model.dispatchEvent(new ChatModelEvent(ChatModelEvent.COMMUNICATOR_ACTIVATED, iCommunicator));
			}
		}
		private function getCommunicatorForRoom(chatRoom:ChatRoom):ICommunicator {
			var key:String = chatRoom.room.roomJID.bareJID;
			var iCommunicator:ICommunicator = _roomCommunications[key] as ICommunicator;
			if(iCommunicator == null){
				iCommunicator = new RoomCommunicator(chatRoom);
				_roomCommunications[key] = iCommunicator;
				_model.dispatchEvent(new ChatModelEvent(ChatModelEvent.COMMUNICATOR_ADDED, iCommunicator));
				_model.dispatchEvent(new ChatModelEvent(ChatModelEvent.COMMUNICATOR_ACTIVATED, iCommunicator));
			}
			return iCommunicator;
		}
		private function getCommunicatorForRoster(item:RosterItemVO):ICommunicator {
			var keyJID:UnescapedJID = item.jid;
			var key:String = keyJID.bareJID;
			var iCommunicator:ICommunicator = _privateCommunications[key] as ICommunicator;
			if(iCommunicator == null){
				iCommunicator = new DirectCommunicator(keyJID, _model.currentUser);
				addCommunicator(key, iCommunicator);
			}
			return iCommunicator;
		}

		public function getAll():Vector.<ICommunicator> {
			var result:Vector.<ICommunicator> = new <ICommunicator>[];
			for each (var communicator:ICommunicator in _privateCommunications) {
				result.push(communicator);
			}
			for each (communicator in _roomCommunications) {
				result.push(communicator);
			}
			return result;
		}

		public function set chatModel(value:ChatModel):void {
			_model = value;
		}

		public function set chatController(value:ChatController):void {
			_controller = value;
		}
	}
}
