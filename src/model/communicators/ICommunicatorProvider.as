/**
 * Created by kvint on 07.11.14.
 */
package model.communicators {
	import controller.ChatController;

	import model.ChatModel;

	public interface ICommunicatorProvider {
		function set chatModel(value:ChatModel):void;
		function set chatController(value:ChatController):void;
		function getCommunicator(data:Object):ICommunicator;
		function getAll():Vector.<ICommunicatorProvider>;
	}
}
