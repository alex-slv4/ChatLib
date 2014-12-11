/**
 * Created by kvint on 11.12.14.
 */
package com.chat.events {
	import flash.events.Event;

	public class CItemCollectionEvent extends Event {

		public static var CHANGE:String = "change";
		public static var RESET:String = "reset";
		public static var ADD_ITEM:String = "addItem";
		public static var REMOVE_ITEM:String = "removeItem";

		public static var REPLACE_ITEM:String = "replaceItem";
		public static var UPDATE_ITEM:String = "updateItem";

		private var _data:Object;

		public function CItemCollectionEvent(type:String, bubbles:Boolean, data:Object) {
			super(type, bubbles);
			_data = data;
		}

		public function get data():Object {
			return _data;
		}
	}
}
