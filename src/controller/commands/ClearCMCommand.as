/**
 * Created by AlexanderSla on 11.11.2014.
 */
package controller.commands {
	public class ClearCMCommand extends CMCommand {

		override public function exec(...args):Boolean {
			var result:Boolean = super.exec.apply(args);
			if(result){
				_communicator.clear();
			}
			return result;
		}

	}
}
