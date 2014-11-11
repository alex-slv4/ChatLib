/**
 * Created by kvint on 07.11.14.
 */
package com.chat.model.communicators {
import com.chat.controller.ChatController;
import com.chat.model.ChatModel;

public interface ICommunicatorProvider {
		function set chatModel(value:ChatModel)				:void;
		function set chatController(value:ChatController)	:void;

		function getCommunicator(data:Object)				:ICommunicator;

		function getAll()									:Vector.<ICommunicator>;
	}
}
