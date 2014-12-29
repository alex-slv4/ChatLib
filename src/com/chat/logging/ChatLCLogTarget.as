/**
 * Created by kvint on 26.12.14.
 */
package com.chat.logging {
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;

	import org.as3commons.logging.setup.ILogTarget;

	public class ChatLCLogTarget implements ILogTarget {

		private static const CONNECTION_NAME:String = "lclogger";
		private static const METHOD_SENT:String = "onMessageSent";
		private static const METHOD_RECEIVED:String = "onMessageReceived";
		private static const METHOD_FAIL:String = "onFail";
		private static const METHOD_DEFAULT:String = "defaultMethod";

		private var _connection:LocalConnection;
		public static const INCOMING:int = 1;
		public static const OUTGOING:int = 2;

		public function ChatLCLogTarget():void {
			_connection = new LocalConnection();
			_connection.addEventListener(StatusEvent.STATUS, onLCStatus);
		}

		private function onLCStatus(event:StatusEvent):void {
			//just for silence
		}


		public function log(name:String, shortName:String, level:int, timeStamp:Number, message:*, parameters:Array, person:String):void {

			var direction:int = parameters.length > 0 ?  parameters[0] : -1;

			try{
				var methodName:String;
				switch (direction){
					case INCOMING:
						methodName = METHOD_SENT;
						break;
					case OUTGOING:
						methodName = METHOD_RECEIVED;
						break;
					default :
						methodName = METHOD_DEFAULT;

				}
				_connection.send(CONNECTION_NAME, methodName, message);
			}catch (e:Error){
				_connection.send(CONNECTION_NAME, METHOD_FAIL, e);
			}
		}
	}
}
