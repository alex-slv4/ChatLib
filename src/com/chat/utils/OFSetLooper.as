/**
 * Created by AlexanderSla on 04.12.2014.
 */
package com.chat.utils {
	import org.igniterealtime.xiff.data.rsm.RSMSet;
	import org.igniterealtime.xiff.setmanagement.IndexedSetLooper;

	public class OFSetLooper extends IndexedSetLooper {

		public function OFSetLooper(bufferSize:int) {
			this.bufferSize = bufferSize;
		}

		override public function get previous():RSMSet {
			if(current == null) {
				return getBottomEdge();
			}
			return super.previous;
		}

		private function getBottomEdge():RSMSet {
			var result:RSMSet = new RSMSet();
			result.index = int.MAX_VALUE;
			return result;
		}
	}
}
