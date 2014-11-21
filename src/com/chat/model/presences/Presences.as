/**
 * Created by AlexanderSla on 21.11.2014.
 */
package com.chat.model.presences {
	import org.igniterealtime.xiff.data.IPresence;

	public class Presences implements IPresences, IPresencesHandler {

		private var _storage:Vector.<IPresencable> = new <IPresencable>[];
		private var _pending:Vector.<IPresence> = new <IPresence>[];

		public function handlePresence(data:IPresence):void {
			_pending.push(data);
		}

		public function subscribe(data:IPresencable):void {
			if(_storage.indexOf(data) == -1){
				_storage.push(data);
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
