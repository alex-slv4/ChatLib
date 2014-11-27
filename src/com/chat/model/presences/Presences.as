/**
 * Created by AlexanderSla on 21.11.2014.
 */
package com.chat.model.presences {
	import com.chat.model.config.PresenceStatuses;

	import flash.utils.Dictionary;

	import org.igniterealtime.xiff.data.IPresence;
	import org.igniterealtime.xiff.data.Presence;
	import org.igniterealtime.xiff.data.muc.MUCItem;
	import org.igniterealtime.xiff.data.muc.MUCUserExtension;

	public class Presences implements IPresences, IPresencesHandler {

		private var _statuses:Vector.<IPresenceStatus> = new <IPresenceStatus>[];
		private var _presences:Dictionary = new Dictionary();

		private const IGNORED_TYPES:Vector.<String> = new <String>[
				Presence.TYPE_ERROR,
				Presence.TYPE_SUBSCRIBE,
				Presence.TYPE_SUBSCRIBED,
				Presence.TYPE_UNSUBSCRIBE,
		];

		public function handlePresence(presence:IPresence):void {
			var allExtensionsByNS:Array = presence.getAllExtensionsByNS(MUCUserExtension.NS);

			if(allExtensionsByNS){
				//It's muc
				for(var i:int = 0; i < allExtensionsByNS.length; i++) {
					var userExtension:MUCUserExtension = allExtensionsByNS[i];
					for(var j:int = 0; j < userExtension.items.length; j++) {
						var mucItem:MUCItem = userExtension.items[j];
						storePresence(presence, mucItem.jid.bareJID);
					}
				}
			}else{
				if(presence.from){
					storePresence(presence, presence.from.bareJID);
				}
			}
		}
		public function subscribe(status:IPresenceStatus):void {
			if(_statuses.indexOf(status) == -1){
				_statuses.push(status);
			}
			updatePresenceStatus(status);
		}

		public function unsubscribe(status:IPresenceStatus):void {
			var index:Number = _statuses.indexOf(status);
			if(index != -1){
				_statuses.splice(index, 1);
			}
		}

		public function getByUID(uid:String):IPresence {
			return _presences[uid];
		}

		private function storePresence(presence:IPresence, uid:String):void {
			if(presence.type == Presence.TYPE_UNSUBSCRIBED){
				delete _presences[uid];
			}else{
				if(presence.type != null){
					if(IGNORED_TYPES.indexOf(presence.type) != -1){
						//Skip the special presence types
						return;
					}
				}
				_presences[uid] = presence;
			}
			updateStatusesByUID(uid);
		}

		private function updateStatusesByUID(uid:String):void {
			var statuses:Vector.<IPresenceStatus> = _statuses.filter(function(obj:IPresenceStatus, index:int, arr:Vector.<IPresenceStatus>):Boolean{
				return obj.uid == uid;
			});

			for(var i:int = 0; i < statuses.length; i++) {
				var status:IPresenceStatus = statuses[i];
				updatePresenceStatus(status);
			}
		}

		private function updatePresenceStatus(presencable:IPresenceStatus):void {
			var presence:IPresence = getByUID(presencable.uid);
			if(presence){
				if(presence.type == Presence.TYPE_UNAVAILABLE){
					presencable.showStatus = PresenceStatuses.OFFLINE;
				}else{
					if (presence.show == null) {
						presencable.showStatus = PresenceStatuses.ONLINE;
					}else{
						switch (presence.show){
							case "away":
								presencable.showStatus = PresenceStatuses.AWAY;
								break;
							case "dnd":
								presencable.showStatus = PresenceStatuses.DND;
								break;
							default :
								presencable.showStatus = PresenceStatuses.ONLINE;
						}
					}
				}
			}else{
				presencable.showStatus = PresenceStatuses.UNKNOWN;
			}
		}
	}
}
