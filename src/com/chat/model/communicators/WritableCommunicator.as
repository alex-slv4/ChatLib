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
		private var _state:String;

		/**
		 *
		 * @param data
		 * @return status code. 0 - success
		 */

		public function WritableCommunicator() {
			commandsMap["/roster"] = CommunicatorCommandEvent.ROSTER;
			commandsMap["/room"] = CommunicatorCommandEvent.ROOM;
			commandsMap["/clear"] = CommunicatorCommandEvent.CLEAR;
			commandsMap["/help"] = CommunicatorCommandEvent.HELP;
			commandsMap["/trace"] = CommunicatorCommandEvent.TRACE;
			commandsMap["/info"] = CommunicatorCommandEvent.INFO;
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
				var eventName:String = commandsMap[commandName];

				if (eventName != null) {
					if (eventName == CommunicatorCommandEvent.HELP) {
						dispatch(eventName, [commandsMap]);
					} else {
						dispatch(eventName, params);
					}
					success = true;
				}
			}
			return success;
		}

		public function get state():String {
			return _state;
		}

		public function set state(value:String):void {
			if(_state != value){
				_state = value;
				dispatch(CommunicatorCommandEvent.SEND_MESSAGE_STATE, [_state]);
			}
		}
	}
}
