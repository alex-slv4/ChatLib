/**
 * Created by AlexanderSla on 21.11.2014.
 */
package com.chat.model.presences {
	public interface IPresenceStatus {

		function get uid():String;

		function set online(value:Boolean):void;

		function set showStatus(value:int):void;
		function set textStatus(value:String):void;
	}
}