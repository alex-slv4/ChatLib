/**
 * Created by AlexanderSla on 05.12.2014.
 */
package com.chat.model.data.collections {
	import com.chat.events.CItemCollectionEvent;
	import com.chat.model.data.citems.ICItem;

	import flash.events.EventDispatcher;

	public class CItemCollection extends EventDispatcher implements ICItemCollection {

		private var _source:Vector.<ICItem> = new <ICItem>[];

		public function append(item:ICItem):void {
			_source.push(item);

			changed();
			this.dispatchEventWith(CItemCollectionEvent.ADD_ITEM, false, this.length-1);
		}

		public function insert(index:int, item:ICItem):void {
			_source.splice(index, 0, item);

			changed();
			this.dispatchEventWith(CItemCollectionEvent.ADD_ITEM, false, index);
		}

		public function getItemAt(index:int):ICItem {
			return _source[index];
		}

		public function setItemAt(item:ICItem, index:int):void {
			_source[index] = item;
			changed();
			this.dispatchEventWith(CItemCollectionEvent.REPLACE_ITEM, false, index);
		}

		public function prepend(item:ICItem):void {
			_source.unshift(item);

			changed();
			this.dispatchEventWith(CItemCollectionEvent.ADD_ITEM, false, 0);
		}

		public function remove(index:int):ICItem {
			var icItem:ICItem = _source.splice(index, 1)[0];
			changed();
			this.dispatchEventWith(CItemCollectionEvent.REMOVE_ITEM, false, index);
			return icItem;
		}


		public function removeAll():void {
			_source = new <ICItem>[];
			changed();
			this.dispatchEventWith(CItemCollectionEvent.RESET, false);
		}

		public function touch(indexOrItem:* = null):void {
			if(indexOrItem is int){
				this.dispatchEventWith(CItemCollectionEvent.UPDATE_ITEM, false, indexOrItem);
			}else if(indexOrItem is ICItem){
				var index:int = indexOf(indexOrItem);
				if(index != -1){
					this.dispatchEventWith(CItemCollectionEvent.UPDATE_ITEM, false, index);
				}
			}else{
				changed();
			}
		}

		private function changed():void {
			this.dispatchEventWith(CItemCollectionEvent.CHANGE);
		}

		public function dispatchEventWith(eventName:String, bubbles:Boolean = false, data:Object = null):void {
			dispatchEvent(new CItemCollectionEvent(eventName, bubbles, data));
		}

		public function indexOf(item:ICItem):int {
			return _source.indexOf(item);
		}

		public function get length():int {
			return _source.length;
		}

		public function get source():Vector.<ICItem> {
			return _source;
		}
	}
}
