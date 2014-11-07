/**
 * Created by kvint on 07.11.14.
 */
package model.communicators {
	import model.ChatModel;

	public interface ICommunicatorProvider {
		function set chatModel(value:ChatModel):void;
		function getCommunicator(data:Object):ICommunicator;
	}
}
