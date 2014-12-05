/**
 * Created by AlexanderSla on 05.12.2014.
 */
package com.chat.model.data.collections {
	import com.chat.model.data.citems.ICItem;

	import feathers.events.CollectionEventType;

	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class CItemCollection extends EventDispatcher implements ICItemCollection {

		private var _rawData:Vector.<ICItem> = new <ICItem>[];

		public function append(item:ICItem):void {
			_rawData.push(item);

			changed();
			this.dispatchEventWith(CollectionEventType.ADD_ITEM, false, this.length-1);
		}

		public function insert(index:int, item:ICItem):void {
			_rawData.splice(index, 0, item);

			changed();
			this.dispatchEventWith(CollectionEventType.ADD_ITEM, false, index);
		}

		public function getItemAt(index:int):ICItem {
			return _rawData[index];
		}

		public function setItemAt(item:ICItem, index:int):void {
			_rawData[index] = item;
			changed();
			this.dispatchEventWith(CollectionEventType.REPLACE_ITEM, false, index);
		}

		public function prepend(item:ICItem):void {
			_rawData.unshift(item);

			changed();
			this.dispatchEventWith(CollectionEventType.ADD_ITEM, false, 0);
		}

		public function remove(index:int):ICItem {
			var icItem:ICItem = _rawData.splice(index, 1)[0];
			changed();
			this.dispatchEventWith(CollectionEventType.REMOVE_ITEM, false, index);
			return icItem;
		}


		public function removeAll():void {
			_rawData = new <ICItem>[];
			changed();
			this.dispatchEventWith(CollectionEventType.RESET, false);
		}

		public function touch(indexOrItem:*):void {
			if(indexOrItem is int){
				this.dispatchEventWith(CollectionEventType.UPDATE_ITEM, false, indexOrItem);
			}else if(indexOrItem is ICItem){
				var index:int = indexOf(indexOrItem);
				if(index != -1){
					this.dispatchEventWith(CollectionEventType.UPDATE_ITEM, false, index);
				}
			}
		}

		private function changed():void {
			this.dispatchEventWith(Event.CHANGE);
		}

		public function indexOf(item:ICItem):int {
			return _rawData.indexOf(item);
		}

		public function get length():int {
			return _rawData.length;
		}
	}
}
