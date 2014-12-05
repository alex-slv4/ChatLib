/**
 * Created by AlexanderSla on 05.12.2014.
 */
package com.chat.model.data.collections {
	import com.chat.model.data.citems.ICItem;

	import feathers.data.IListCollectionDataDescriptor;

	import flash.errors.IllegalOperationError;

	public class CItemCollectionDescriptor implements IListCollectionDataDescriptor {

		public function getLength(data:Object):int
		{
			this.checkForCorrectDataType(data);
			return (data as ICItemCollection).length;
		}

		public function getItemAt(data:Object, index:int):Object
		{
			this.checkForCorrectDataType(data);
			return (data as ICItemCollection).getItemAt(index);
		}

		public function setItemAt(data:Object, item:Object, index:int):void
		{
			this.checkForCorrectDataType(data);
			checkForCorrectItemType(item);
			var icItem:ICItem = item as ICItem;
			(data as ICItemCollection).setItemAt(icItem, index);
		}

		public function addItemAt(data:Object, item:Object, index:int):void
		{
			this.checkForCorrectDataType(data);
			checkForCorrectItemType(item);
			var icItem:ICItem = item as ICItem;
			(data as ICItemCollection).insert(index, icItem);
		}

		public function removeItemAt(data:Object, index:int):Object
		{
			this.checkForCorrectDataType(data);
			return (data as ICItemCollection).remove(index);
		}

		public function removeAll(data:Object):void
		{
			this.checkForCorrectDataType(data);
			(data as ICItemCollection).removeAll();
		}

		public function getItemIndex(data:Object, item:Object):int
		{
			this.checkForCorrectDataType(data);
			checkForCorrectItemType(item);
			var icItem:ICItem = item as ICItem;
			return (data as ICItemCollection).indexOf(icItem);
		}

		protected function checkForCorrectItemType(item:Object):void
		{
			if(!(item is ICItem))
			{
				throw new IllegalOperationError("Expected ICItem. Received " + Object(item).constructor + " instead.");
			}
		}
		protected function checkForCorrectDataType(data:Object):void
		{
			if(!(data is ICItemCollection))
			{
				throw new IllegalOperationError("Expected ICItemCollection. Received " + Object(data).constructor + " instead.");
			}
		}
	}
}
