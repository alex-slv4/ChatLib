/**
 * Created by AlexanderSla on 11.11.2014.
 */
package controller.commands {
	import model.communicators.ICommunicator;

	public interface ICMCommand {
		function get requiredParamsCount():int;
		function get communicator():ICommunicator;
		function get params():Array;
	}
}
