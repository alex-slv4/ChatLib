/**
 * Created by AlexanderSla on 21.11.2014.
 */
package com.chat.model.presences {
	public interface IPresenceStatus {

		function get uid():String;

		function set online(value:Boolean):void;
	}
}
