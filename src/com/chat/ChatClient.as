package com.chat
{

import com.chat.controller.ChatController;
import com.chat.model.ChatModel;

public class ChatClient implements Chat
{

	[Inject]
	public var thisController:ChatController;

	[Inject]
	public var _model:ChatModel;

	private static var _instance:ChatClient;

	static public function get instance():Chat
	{
		return _instance ||= new ChatClient();
	}

	public function get model():ChatModel
	{
		return _model;
	}

	public function get controller():ChatController
	{
		return thisController;
	}
}
}
