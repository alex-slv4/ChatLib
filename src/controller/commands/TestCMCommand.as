/**
 * Created by AlexanderSla on 11.11.2014.
 */
package controller.commands {
	public class TestCMCommand extends CMCommand {

		override public function exec(...args):Boolean {
			var result:Boolean = super.exec.apply(args);
			if(result){
				print("run test command");
				for(var i:int = 0; i < args.length; i++) {
					var string:String = args[i];
					print(string);
				}
			}
			return result;
		}
	}
}
