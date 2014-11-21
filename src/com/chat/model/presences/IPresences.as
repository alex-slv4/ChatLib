/**
 * Created by AlexanderSla on 21.11.2014.
 */
package com.chat.model.presences {
	public interface IPresences {
		function subscribe(data:IPresencable):void;
		function unsubscribe(data:IPresencable):void;
	}
}
