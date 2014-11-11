/**
 * Created by mikhailkuts on 30.07.14.
 */
package com.chat.utils.providers {

	import flash.utils.Dictionary;

	public class ViewDataProvider implements IViewDataProvider{

	private var _data			:Object 			= null;

	private var _subscribers	:Vector.<Function> 	= new <Function>[];

	public function subscribe(callback:Function):void
	{
		if (_subscribers.indexOf(callback) != -1)
			return;

		_subscribers.push(callback);
	}

	public function unsubscribe(callback:Function):void
	{
		var callbackIdx:int = _subscribers.indexOf(callback);

		if (callbackIdx == -1)
			return;

		_subscribers.splice(callbackIdx, 1);
	}

	public function get data():Object
	{
		return _data;
	}

	public function get dataAsInt():int
	{
		return _data as int;
	}

	public function get dataAsDictionary():Dictionary
	{
		return _data as Dictionary;
	}

	public function set data(value:Object):void
	{
		_data = value;

		notifySubscribers();
	}

	protected function notifySubscribers():void
	{
		var listener:Function;
		var numArgs:int;

		for (var s:uint = 0; s < _subscribers.length; s++)
		{
			listener = _subscribers[s];
			numArgs = listener.length;

			if (numArgs == 1)
				listener(data);
			else if (numArgs == 0)
				listener();
		}
	}

}
}
