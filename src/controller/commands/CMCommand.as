/**
 * Created by AlexanderSla on 11.11.2014.
 */
package controller.commands {
	import model.communicators.ICommunicator;
	import model.data.ListData;

	public class CMCommand implements ICMCommand {

		protected var _communicator:ICommunicator;

		public function exec(...args):Boolean {
			if(_communicator == null){
				return false;
			}
			if(args.length < this.requiredArgsCount){
				error("args expected", this.requiredArgsCount, "got", args.length);
				return false;
			}
			return true;
		}

		protected function print(...args):void {
			args.unshift(0);
			write.apply(this, args);
		}
		protected function error(...args):void {
			args.unshift(1);
			write.apply(this, args);
		}

		public function write(type:int, ...args):void {
			//TODO: use type as ListData type
			var prefix:String = type == 1 ? "error" : "";
			_communicator.add(new ListData(prefix + " " + args.join(" ")));
		}
		public function set communicator(value:ICommunicator):void {
			_communicator = value;
		}

		public function get requiredArgsCount():int {
			return 0;
		}
	}
}
