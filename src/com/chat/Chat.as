package com.chat {

	import com.chat.controller.IChatController;
	import com.chat.model.IChatModel;

	public class Chat implements IChat {

		private var _controller:IChatController;
		private var _model:IChatModel;


		public function get model():IChatModel {
			return _model;
		}

		[Inject]
		public function set model(value:IChatModel):void {
			_model = value;
		}

		public function get controller():IChatController {
			return _controller;
		}

		[Inject]
		public function set controller(value:IChatController):void {
			_controller = value;
		}

	}
}
