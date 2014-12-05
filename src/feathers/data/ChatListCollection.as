/**
 * Created by AlexanderSla on 05.12.2014.
 */
package feathers.data {
	import com.chat.model.data.collections.CItemCollectionDescriptor;
	import com.chat.model.data.collections.ICItemCollection;

	public class ChatListCollection extends ListCollection {

		override public function set data(value:Object):void
		{
			removeCollectionListeners();
			super.data = value;
			if(_data is ICItemCollection)
			{
				this.dataDescriptor = new CItemCollectionDescriptor();
			}
			addCollectionListeners();
		}

		override public function set dataDescriptor(value:IListCollectionDataDescriptor):void {
			super.dataDescriptor = value;
		}

		private function addCollectionListeners():void {
			//TODO:
		}

		private function removeCollectionListeners():void {
			//TODO:
		}

		override public function addItemAt(item:Object, index:int):void
		{
			this._dataDescriptor.addItemAt(this._data, item, index);
			//this.dispatchEventWith(Event.CHANGE);
			//this.dispatchEventWith(CollectionEventType.ADD_ITEM, false, index);
		}
		override public function removeItemAt(index:int):Object
		{
			var item:Object = this._dataDescriptor.removeItemAt(this._data, index);
			//this.dispatchEventWith(Event.CHANGE);
			//this.dispatchEventWith(CollectionEventType.REMOVE_ITEM, false, index);
			return item;
		}

		override public function removeAll():void
		{
			if(this.length == 0)
			{
				return;
			}
			this._dataDescriptor.removeAll(this._data);
			//this.dispatchEventWith(Event.CHANGE);
			//this.dispatchEventWith(CollectionEventType.RESET, false);
		}

		override public function setItemAt(item:Object, index:int):void
		{
			this._dataDescriptor.setItemAt(this._data, item, index);
			//this.dispatchEventWith(Event.CHANGE);
			//this.dispatchEventWith(CollectionEventType.REPLACE_ITEM, false, index);
		}
	}
}
