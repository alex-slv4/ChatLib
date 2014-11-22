/**
 * Created by AlexanderSla on 21.11.2014.
 */
package com.chat.model.presences {
	public interface IPresencable {

		function set uid(value:String):void;
		function get uid():String;

		function set online(value:Boolean):void;
	}
}
