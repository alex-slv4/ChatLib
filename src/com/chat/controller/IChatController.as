/**
 * Created by kvint on 23.11.14.
 */
package com.chat.controller {
	import org.igniterealtime.xiff.data.IXMPPStanza;

	public interface IChatController {
		function send(stanza:IXMPPStanza):void;
		function connect(username:String, password:String):void;
		function disconnect():void;
	}
}
