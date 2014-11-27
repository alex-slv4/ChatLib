/**
 * Created by AlexanderSla on 27.11.2014.
 */
package com.chat.model.activity {
	import org.igniterealtime.xiff.data.IMessage;

	public interface IActivitiesHandler {
		function handleActivity(data:IMessage):void;
	}
}
