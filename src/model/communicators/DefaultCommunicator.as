/**
 * Created by kvint on 02.11.14.
 */
package model.communicators {
	import flash.events.EventDispatcher;

	import org.igniterealtime.xiff.data.Message;

	public class DefaultCommunicator extends EventDispatcher implements ICommunicator {

		protected var _label:String;
		private var _history:Array = [];

		public function DefaultCommunicator() {
		}

		public function get type():int {
			return 0;
		}
		public function get label():String {
			return _label ? _label : toString();
		}

		public function add(data:Object):void {
			_history.push(data);
		}

		public function markAsRead(message:Message):Boolean {
			return false;
		}

		public function get history():Array {
			return _history;
		}

		override public function toString():String {
			return "[DefaultCommunicator]";
		}
	}
}
