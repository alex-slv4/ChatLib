/**
 * Created by kvint on 13.11.14.
 */
package com.chat.model.communicators {
	import com.chat.events.CommunicatorCommandEvent;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import flash.utils.Dictionary;

	import org.as3commons.lang.StringUtils;

	public class WritableCommunicator extends DefaultCommunicator {

		private static const COMMAND_PATTERN:RegExp = /^\/\w+(\s|$)/ig;
		private static const ARG_DELIMITER:RegExp = /\s+/;

		public static const COMMAND:int = 1;
		public static const BLANK_BODY:int = -1;
		public static const SUCCESS:int = 0;
		protected var commandsMap:Dictionary = new Dictionary();

		[Inject]
		public var eventDispatcher:IEventDispatcher;

		/**
		 *
		 * @param data
		 * @return status code. 0 - success
		 */

		public function WritableCommunicator() {
			commandsMap["/trace"] = CommunicatorCommandEvent.TRACE;
			commandsMap["/clear"] = CommunicatorCommandEvent.CLEAR;
			commandsMap["/muc"] = CommunicatorCommandEvent.CREATE_ROOM;
			commandsMap["/join"] = CommunicatorCommandEvent.JOIN_ROOM;
			commandsMap["/add"] = CommunicatorCommandEvent.ADD;
			commandsMap["/help"] = CommunicatorCommandEvent.HELP;
		}

		public function send(data:Object):int {

			if(!(data is String)) throw new Error("Implement me!");

			var body:String = StringUtils.trim(data.toString());

			if(!body || body == "")
				return BLANK_BODY;

			if(proceedCommand(body)){
				return COMMAND;
			}
			return SUCCESS;
		}

		private function proceedCommand(body:String):Boolean {
			var commands:Array = body.match(COMMAND_PATTERN);
			var success:Boolean = false;
			if(commands && commands.length == 1) {
				var commandName:String = StringUtils.trim(commands[0])
				var params:Array = body.split(ARG_DELIMITER);
				params.shift();
				var event:String = commandsMap[commandName];

				if (event != null) {
					if (event == CommunicatorCommandEvent.HELP) {
						dispatch(new CommunicatorCommandEvent(event, this, [commandsMap]));
					} else {
						dispatch(new CommunicatorCommandEvent(event, this, params));
					}
					success = true;
				}
			}
			return success;
		}

		public function dispatch(e:Event):void {
			eventDispatcher.dispatchEvent(e);
		}
	}
}
