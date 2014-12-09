/**
 * Created by AlexanderSla on 05.12.2014.
 */
package com.chat.model.data.collections {
	import com.chat.model.data.citems.ICItem;

	[Event(name="change",type="starling.events.Event")]
	[Event(name="reset",type="starling.events.Event")]
	[Event(name="addItem",type="starling.events.Event")]
	[Event(name="removeItem",type="starling.events.Event")]
	[Event(name="replaceItem",type="starling.events.Event")]
	[Event(name="updateItem",type="starling.events.Event")]

	public interface ICItemCollection {
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
