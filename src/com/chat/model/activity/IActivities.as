/**
 * Created by AlexanderSla on 27.11.2014.
 */
package com.chat.model.activity {
	public interface IActivities {
		function subscribe(data:IActivityStatus):void;
		function unsubscribe(data:IActivityStatus):void;
		//function getByUID(uid:String):IPresence;
	}
}
