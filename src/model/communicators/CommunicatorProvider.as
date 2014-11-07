/**
 * Created by AlexanderSla on 06.11.2014.
 */
package model.communicators {
	import events.ChatModelEvent;

	import flash.utils.Dictionary;

	import model.ChatModel;
	import model.data.ChatMessage;

	import org.igniterealtime.xiff.collections.ArrayCollection;
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.im.RosterItemVO;

	public class CommunicatorProvider implements ICommunicatorProvider {

		private var _chatModel:ChatModel;
		private var _privateCommunications:Dictionary = new Dictionary();

		public function CommunicatorProvider() {

		}

		public function getCommunicator(data:Object):ICommunicator {
			var constructFunc:Function;
			switch (data.constructor){
				case RosterItemVO:
					constructFunc = getCommunicatorForRoster;
					break;
				case Message:
					ArrayCollection
				case ChatMessage:
					constructFunc = getCommunicatorForMessage;
			}
			return constructFunc(data);
		}

		private function getCommunicatorForMessage(message:Message):ICommunicator {
			//TODO: MUC
			var isCurrentUserMessage:Boolean = message.from.equals(_chatModel.currentUser.jid.escaped, true);
			var keyJID:EscapedJID = isCurrentUserMessage ? message.to : message.from;
			var key:String = keyJID.bareJID;
			var iCommunicator:ICommunicator = _privateCommunications[key] as ICommunicator;
			if(iCommunicator == null){
				iCommunicator = new DirectCommunicator(keyJID.unescaped, _chatModel.currentUser);
				addCommunicator(key, iCommunicator);
			}
			return iCommunicator;
		}

		private function addCommunicator(key:String, iCommunicator:ICommunicator):void {
			_privateCommunications[key] = iCommunicator;
			_chatModel.dispatchEvent(new ChatModelEvent(ChatModelEvent.COMMUNICATOR_ADDED, iCommunicator));
		}
		private function getCommunicatorForRoster(item:RosterItemVO):ICommunicator {
			var keyJID:UnescapedJID = item.jid;
			var key:String = keyJID.bareJID;
			var iCommunicator:ICommunicator = _privateCommunications[key] as ICommunicator;
			if(iCommunicator == null){
				iCommunicator = new DirectCommunicator(keyJID, _chatModel.currentUser);
				addCommunicator(key, iCommunicator);
			}
			return iCommunicator;
		}

		public function set chatModel(value:ChatModel):void {
			_chatModel = value;
		}
	}
}
