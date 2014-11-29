/**
 * Created by kvint on 29.11.14.
 */
package com.chat.config {
	public interface ICMCommandsConfig {

		function getCommand(name:String, forClass:Class = null):Class;

		function getCommands(forClass:Class = null):Array;

	}
}
