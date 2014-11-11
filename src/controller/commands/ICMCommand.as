/**
 * Created by AlexanderSla on 11.11.2014.
 */
package controller.commands {
	import model.communicators.ICommunicator;

	public interface ICMCommand {
		function exec(...args):Boolean;
		function get requiredArgsCount():int ;
		function set communicator(value:ICommunicator):void;
	}
}
