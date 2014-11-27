/**
 * Created by AlexanderSla on 27.11.2014.
 */
package com.chat.model.activity {
	import com.chat.model.config.ActivityStatuses;

	import flash.utils.Dictionary;

	import org.igniterealtime.xiff.data.IMessage;
	import org.igniterealtime.xiff.data.Message;

	public class Activities implements IActivities, IActivitiesHandler {

		private var _statuses:Vector.<IActivityStatus> = new <IActivityStatus>[];
		private var _states:Dictionary = new Dictionary();

		public function subscribe(data:IActivityStatus):void {
			if(_statuses.indexOf(data) == -1){
				_statuses.push(data);
			}
			updateActivityStatus(data);
		}


		public function unsubscribe(data:IActivityStatus):void {
			var index:Number = _statuses.indexOf(data);
			if(index != -1){
				_statuses.splice(index, 1);
			}
		}

		public function handleActivity(data:IMessage):void {
			if(data.state != null){
				var uid:String = data.from.bareJID;
				_states[uid] = data.state;
				updateStatesByUID(uid);
			}
		}

		private function updateStatesByUID(uid:String):void {
			var filteredStates:Vector.<IActivityStatus> = _statuses.filter(function(obj:IActivityStatus, index:int, arr:Vector.<IActivityStatus>):Boolean{
				return obj.uid == uid;
			});

			for(var i:int = 0; i < filteredStates.length; i++) {
				var status:IActivityStatus = filteredStates[i];
				updateActivityStatus(status);
			}
		}

		private function updateActivityStatus(data:IActivityStatus):void {

			var stateData:String = _states[data.uid];
			switch (stateData){
				case Message.STATE_ACTIVE:
					data.state = ActivityStatuses.ACTIVE;
					break;
				case Message.STATE_COMPOSING:
					data.state = ActivityStatuses.COMPOSING;
					break;
				case Message.STATE_PAUSED:
					data.state = ActivityStatuses.PAUSED;
					break;
				case null:
				default:
					data.state = ActivityStatuses.UNKNOWN;
			}
		}
	}
}
