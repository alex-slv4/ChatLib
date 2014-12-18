/**
 * Created by AlexanderSla on 05.12.2014.
 */
package com.chat.model.data.collections {
	import com.chat.model.data.citems.ICItem;

	import flash.events.IEventDispatcher;

	[Event(name="change",type="com.chat.events.CItemCollectionEvent")]
	[Event(name="reset",type="com.chat.events.CItemCollectionEvent")]
	[Event(name="addItem",type="com.chat.events.CItemCollectionEvent")]
	[Event(name="removeItem",type="com.chat.events.CItemCollectionEvent")]
	[Event(name="replaceItem",type="com.chat.events.CItemCollectionEvent")]
	[Event(name="updateItem",type="com.chat.events.CItemCollectionEvent")]

	//TODO: implement filter
	public interface ICItemCollection extends IEventDispatcher {
		function append(item:ICItem):void;
		function insert(index:int, item:ICItem):void;
		function prepend(item:ICItem):void;
		function remove(index:int):ICItem;
		function indexOf(item:ICItem):int;
		function touch(indexOrItem:* = null):void;
		function getItemAt(index:int):ICItem;
		function setItemAt(item:ICItem, index:int):void;
		function removeAll():void;
		function get length():int;
		function get source():Vector.<ICItem>;
	}
}
