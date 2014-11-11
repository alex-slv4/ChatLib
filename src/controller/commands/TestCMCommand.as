/**
 * Created by AlexanderSla on 11.11.2014.
 */
package controller.commands {
	public class TestCMCommand extends CMCommand {

		override public function exec(...args):Boolean {
			var result:Boolean = super.exec.apply(args);
			if(result){
				_communicator.add("run test command");
				for(var i:int = 0; i < args.length; i++) {
					var string:String = args[i];
					_communicator.add(string);
				}
			}
			return result;
		}
	}
}
