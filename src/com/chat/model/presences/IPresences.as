/**
 * Created by AlexanderSla on 21.11.2014.
 */
package com.chat.model.presences {
	import org.igniterealtime.xiff.data.IPresence;

	public interface IPresences {
		function subscribe(data:IPresenceStatus):void;
		function unsubscribe(data:IPresenceStatus):void;
		function getByUID(uid:String):IPresence;
	}
}
