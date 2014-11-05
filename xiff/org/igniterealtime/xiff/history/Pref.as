/**
 * Created by AlexanderSla on 05.11.2014.
 */
package org.igniterealtime.xiff.history {
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.IPref;
	import org.igniterealtime.xiff.data.XMPPStanza;

	public class Pref extends XMPPStanza implements IPref {
		public function Pref(sender:EscapedJID, theType:String, theID:String, nodeName:String) {
			super(null, sender, theType, theID, nodeName);
		}
	}
}
