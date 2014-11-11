/**
 * Created by AlexanderSla on 11.11.2014.
 */
package model.data {
	public class ListData {

		private var _data:String;

		public function ListData(data:String) {
			_data = data;
		}

		public function toString():String {
			return _data;
		}
	}
}
