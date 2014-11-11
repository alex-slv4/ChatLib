/**
 * Created by AlexanderSla on 11.11.2014.
 */
package controller.commands {
	import model.communicators.ICommunicator;

	public class CMCommand implements ICMCommand {

		protected var _communicator:ICommunicator;

		public function exec(...args):Boolean {
			if(_communicator == null){
				return false;
			}
			if(args.length < this.requiredArgsCount){
				_communicator.add("args error: expected " + this.requiredArgsCount + " got " + args.length);
				return false;
			}
			return true;
		}

		public function set communicator(value:ICommunicator):void {
			_communicator = value;
		}

		public function get requiredArgsCount():int {
			return 0;
		}
	}
}
