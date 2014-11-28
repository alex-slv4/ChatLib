/**
 * Created by AlexanderSla on 28.11.2014.
 */
package com.chat.model.communicators {
	public interface IWritableCommunicator {
		function get thread():String;
		function set thread(value:String):void;
	}
}
