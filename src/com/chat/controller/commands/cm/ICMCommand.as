/**
 * Created by AlexanderSla on 11.11.2014.
 */
package com.chat.controller.commands.cm {
import com.chat.model.communicators.ICommunicatorBase;

public interface ICMCommand {
		function get requiredParamsCount():int;
		function get communicator():ICommunicatorBase;
		function get params():Array;
	}
}
