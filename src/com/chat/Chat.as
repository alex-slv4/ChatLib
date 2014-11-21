package com.chat
{

	import com.chat.controller.ChatController;
	import com.chat.model.IChatModel;

	public class Chat implements IChat
{

	[Inject]
	public var thisController:ChatController;

	[Inject]
	public var _model:IChatModel;

	private static var _instance:Chat;

	static public function get instance():IChat
	{
		return _instance ||= new Chat();
	}

	public function get model():IChatModel
	{
		return _model;
	}

	public function get controller():ChatController
	{
		return thisController;
	}
}
}
