/**
 * Created by AlexanderSla on 11.11.2014.
 */
package controller.commands {
	import events.CMEvent;

	import model.communicators.ICommunicator;
	import model.data.ListData;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	public class CMCommand implements ICommand, ICMCommand{

		[Inject]
		public var event:CMEvent;

		public function execute():void {
			if(!hasErrors()){
				_execute();
			}
		}

		protected function _execute():void {

		}

		public function hasErrors():Boolean {
			var result:Boolean;
			if(communicator == null){
				result = false;
			}
			if(params.length < this.requiredArgsCount){
				error("params expected", this.requiredArgsCount, "got", params.length);
				result = false;
			}
			return result;
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
			communicator.add(new ListData(prefix + " " + args.join(" ")));
		}
		public function get communicator():ICommunicator {
			return event.communicator;
		}

		public function get params():Array {
			return event.params;
		}

		public function get requiredArgsCount():int {
			return 0;
		}
	}
}
