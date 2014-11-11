/**
 * Created by AlexanderSla on 11.11.2014.
 */
package controller.commands {
	public class ClearCMCommand extends CMCommand {

		override protected function _execute():void {
			communicator.clear();
		}
	}
}
