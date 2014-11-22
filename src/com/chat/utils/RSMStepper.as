/**
 * Created by kvint on 17.11.14.
 */
package com.chat.utils {
	import org.igniterealtime.xiff.data.rsm.RSMSet;

	public class RSMStepper {

		private var _current:RSMSet;
		private var _stepSize:int;

		public function RSMStepper(stepSize:int = 1) {
			_stepSize = stepSize;
		}

		public function set current(current:RSMSet):void{
			_current = current;
		}

		public function get current():RSMSet {
			return _current;
		}

		public function get next():RSMSet {
			return getNext(_stepSize);
		}
		public function get previous():RSMSet {
			return getPrevious(_stepSize);
		}

		public function getInitial():RSMSet {
			var result:RSMSet = new RSMSet();
			result.max = 1; //It has to be zero here, but openfire...
			result.before = "";
			return result;
		}
		protected function getNext(count:int):RSMSet {
			var result:RSMSet = new RSMSet();
			if(_current) {
				result.index = Math.min(_current.firstIndex+1, _current.count);
			}
			result.max = count;
			return result;
		}
		protected function getPrevious(count:int):RSMSet {
			var result:RSMSet = new RSMSet();
			if(_current) {
				result.index = Math.max(_current.firstIndex-count, 0);
			}
			result.max = count;
			return result;
		}

		public function get stepSize():int {
			return _stepSize;
		}

		public function set stepSize(value:int):void {
			_stepSize = value;
		}
	}
}
