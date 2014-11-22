/**
 * Created by AlexanderSla on 21.11.2014.
 */
package com.chat.model.presences {
	import flash.utils.Dictionary;

	import org.igniterealtime.xiff.data.IPresence;
	import org.igniterealtime.xiff.data.Presence;
	import org.igniterealtime.xiff.data.muc.MUCItem;
	import org.igniterealtime.xiff.data.muc.MUCUserExtension;

	public class Presences implements IPresences, IPresencesHandler {

		private var _storage:Vector.<IPresencable> = new <IPresencable>[];
		private var _pending:Dictionary = new Dictionary();

		public function handlePresence(presence:IPresence):void {
			var allExtensionsByNS:Array = presence.getAllExtensionsByNS(MUCUserExtension.NS);

			if(allExtensionsByNS){
				//It's muc
				for(var i:int = 0; i < allExtensionsByNS.length; i++) {
					var userExtension:MUCUserExtension = allExtensionsByNS[i];
					for(var j:int = 0; j < userExtension.items.length; j++) {
						var mucItem:MUCItem = userExtension.items[j];
						storePresence(presence, mucItem.jid.toString());
					}
				}
			}else{
				if(presence.from){
					storePresence(presence, presence.from.toString());
				}
			}
		}

		private function storePresence(presence:IPresence, uid:String):void {
			if(presence.type == Presence.TYPE_UNAVAILABLE){
				delete _pending[uid];
			}else{
				_pending[uid] = presence;
			}
			updatePresencablesByUID(uid);
		}

		private function updatePresencablesByUID(uid:String):void {
			var presencables:Vector.<IPresencable> = _storage.filter(function(obj:IPresencable):Boolean{
				return obj.uid == uid;
			});

			for(var i:int = 0; i < presencables.length; i++) {
				var presencable:IPresencable = presencables[i];
				presencable.online = _pending[uid] != null;
			}
		}
		public function subscribe(presencable:IPresencable):void {
			if(_storage.indexOf(presencable) == -1){
				_storage.push(presencable);
				updatePresencablesByUID(presencable.uid);
			}
		}

		public function unsubscribe(data:IPresencable):void {
			var index:Number = _storage.indexOf(data);
			if(index != -1){
				_storage.splice(index, 1);
			}
		}
	}
}
