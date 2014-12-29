/**
 * Created by kvint on 27.12.14.
 */
package com.chat.logging {
	import flash.net.Socket;

	import org.as3commons.logging.setup.ILogTarget;

	public class ChatSocketLogTarget implements ILogTarget {

		private var _socket:Socket;

		public function ChatSocketLogTarget() {

		}

		public function log(name:String, shortName:String, level:int, timeStamp:Number, message:*, parameters:Array, person:String):void {

		}
	}
}
