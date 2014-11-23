/**
 * Created by kvint on 01.11.14.
 */
package com.chat {
	import com.chat.controller.IChatController;
	import com.chat.model.IChatModel;

	public interface IChat {

		function get model():IChatModel;
		function get controller():IChatController;

	}
}
