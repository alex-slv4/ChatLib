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
		public function get next():RSMSet {
			return getNext(_stepSize);
		}
		public function get previous():RSMSet {
			return getPrevious(_stepSize);
		}

		public function getNext(count:int):RSMSet {
			var result:RSMSet = new RSMSet();
			result.max = count;
			if(_current) {
				if(_current.last){
					result.after = _current.last;
				}else{
					//There is no last, it's blank page
					return null;
				}
			}
			return result;
		}
		public function getPrevious(count:int):RSMSet {
			var result:RSMSet = new RSMSet();
			if(_current) {
				if(_current.first){
					result.before = _current.first;
				}else{
					//There is no last, it's blank page
					return null;
				}
			}
			result.before = _current.first;
			result.max = _stepSize;
			return result;
		}
	}
}
