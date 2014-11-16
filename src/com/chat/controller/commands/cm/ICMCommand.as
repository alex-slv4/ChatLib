/**
 * Created by AlexanderSla on 11.11.2014.
 */
package com.chat.controller.commands.cm {
import com.chat.model.communicators.ICommunicator;

public interface ICMCommand {
		function get requiredParamsCount():int;
		function get communicator():ICommunicator;
		function get params():Array;
	}
}
