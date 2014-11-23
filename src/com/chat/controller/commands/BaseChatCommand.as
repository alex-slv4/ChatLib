/**
 * Created by kvint on 16.11.14.
 */
package com.chat.controller.commands {
	import com.chat.controller.IChatController;
	import com.chat.model.IChatModel;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	public class BaseChatCommand implements ICommand {
		[Inject]
		public var model:IChatModel;
		[Inject]
		public var controller:IChatController;

		public function execute():void {
		}
	}
}
