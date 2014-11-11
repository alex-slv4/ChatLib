/**
 * Created by AlexanderSla on 11.11.2014.
 */
package controller.commands {
	import flash.utils.Dictionary;

	public class InfoCMCommand extends CMCommand {

		private var _commandMap:Dictionary;

		public function InfoCMCommand(commandMap:Dictionary) {
			_commandMap = commandMap;
		}

		override public function exec(...args):Boolean {
			var result:Boolean = super.exec.apply(args);
			if(result){
				_communicator.add("Commands map:");
				for(var key:String in _commandMap) {
					_communicator.add(key + " " + _commandMap[key]);
				}
			}
			return result;
		}

		override public function get requiredArgsCount():int {
			return 0;
		}
	}
}
