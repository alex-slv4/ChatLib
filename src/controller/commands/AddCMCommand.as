/**
 * Created by AlexanderSla on 11.11.2014.
 */
package controller.commands {
	public class AddCMCommand extends CMCommand {

		override public function exec(...args):Boolean {
			var result:Boolean = super.exec.apply(this, args);
			if(result){
				var resultStr:String = "added " + args[0];
				_communicator.add(resultStr);
				result = resultStr != null;
			}
			return result;
		}

		override public function get requiredArgsCount():int {
			return 1;
		}
	}
}
