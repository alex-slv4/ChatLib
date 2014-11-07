/**
 * Created by kuts on 11/7/14.
 */
package view.utils
{
import flash.utils.Dictionary;

import org.as3commons.logging.api.ILogger;
import org.as3commons.logging.api.getLogger;

import starling.display.DisplayObject;

public class SimpleViewFactory {

	private static const log		:ILogger 	= getLogger(SimpleViewFactory);

	private var _viewClasses		:Dictionary;

	public function SimpleViewFactory()
	{
		_viewClasses = new Dictionary();
	}

	public function createView(id:Object, data:* = null):DisplayObject
	{
		if (!_viewClasses[id])
			return null;

		return data ? new _viewClasses[id](data) : new _viewClasses[id]();
	}

	public function setViewClass(viewClass:Class, id:Object):void
	{
		_viewClasses[id] = viewClass;
	}

}
}
