/**
 * Created by kvint on 26.12.14.
 */
package com.chat.logging {
	import org.as3commons.logging.setup.ILogTarget;

	public class ChatLoggerTarget implements ILogTarget {

		public function log(name:String, shortName:String, level:int, timeStamp:Number, message:*, parameters:Array, person:String):void {
			trace("ChatLoggerTarget", timeStamp);
		}
	}
}
