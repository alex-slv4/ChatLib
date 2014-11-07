/**
 * Created by kuts on 11/7/14.
 */
package view.container
{
import feathers.controls.LayoutGroup;
import feathers.core.IFeathersControl;
import feathers.skins.IStyleProvider;

import model.communicators.ICommunicator;

import starling.display.DisplayObject;

import view.utils.SimpleViewFactory;

public class CommunicatorContainerView extends LayoutGroup
{
	private var _communicatorFactory	:SimpleViewFactory		 = new SimpleViewFactory();

	private var _communicatorView		:DisplayObject;
	private var _communicatorProvider	:ICommunicator;

	override protected function draw():void
	{
		super.draw();

		const dataInvalid:Boolean = isInvalid(INVALIDATION_FLAG_DATA);
		const stylesInvalid:Boolean = isInvalid(INVALIDATION_FLAG_STYLES);
		const stateInvalid:Boolean = isInvalid(INVALIDATION_FLAG_STATE);
		var sizeInvalid:Boolean = isInvalid(INVALIDATION_FLAG_SIZE);
		var layoutInvalid:Boolean = isInvalid(INVALIDATION_FLAG_LAYOUT);

		if (dataInvalid)
			updateCommunicatorView();

		sizeInvalid = autoSizeIfNeeded() || sizeInvalid;

		if (layoutInvalid || stylesInvalid || sizeInvalid || stateInvalid || dataInvalid)
			layoutContent();
	}

	protected function autoSizeIfNeeded():Boolean
	{
		const needsWidth:Boolean = isNaN(explicitWidth);
		const needsHeight:Boolean = isNaN(explicitHeight);

		if(!needsWidth && !needsHeight)
			return false;

		var control:IFeathersControl;

		if (communicatorView && communicatorView is IFeathersControl)
		{
			control = IFeathersControl(communicatorView);
			control.validate();
		}

		var newWidth:Number = explicitWidth;

		if(needsWidth)
			newWidth = control ? control.width : newWidth;

		var newHeight:Number = explicitHeight;

		if(needsHeight)
			newHeight = control ? control.height : newHeight;

		return setSizeInternal(newWidth, newHeight, false);
	}

	protected function updateCommunicatorView():void
	{
		if (communicatorView)
			communicatorView.removeFromParent();

		_communicatorView = communicatorFactory.createView(communicatorProvider.type);

		if (communicatorView)
			addChild(communicatorView);
	}

	protected function layoutContent():void
	{
		if (communicatorView)
		{
			IFeathersControl(communicatorView).validate();
			communicatorView.width = actualWidth;
			communicatorView.height = actualHeight;
		}
	}

	public function get communicatorView():DisplayObject
	{
		return _communicatorView;
	}

	public static var globalStyleProvider:IStyleProvider;

	override protected function get defaultStyleProvider():IStyleProvider
	{
		return globalStyleProvider;
	}

	public function get communicatorFactory():SimpleViewFactory
	{
		return _communicatorFactory;
	}

	public function get communicatorProvider():ICommunicator
	{
		return _communicatorProvider;
	}

	public function set communicatorProvider(value:ICommunicator):void
	{
		if (_communicatorProvider == value)
			return;

		_communicatorProvider = value;

		invalidate(INVALIDATION_FLAG_DATA);
	}
}
}
