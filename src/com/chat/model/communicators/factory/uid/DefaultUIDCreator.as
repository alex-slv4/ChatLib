/**
 * Created by kvint on 18.12.14.
 */
package com.chat.model.communicators.factory.uid {
	import org.igniterealtime.xiff.core.AbstractJID;
	import org.igniterealtime.xiff.util.JIDUtil;

	public class DefaultUIDCreator implements IUIDCreator {

		protected var data:Object;

		public function DefaultUIDCreator(data:Object) {
			this.data = data;
		}

		public function toString():String {
			if(data is AbstractJID){
				return JIDUtil.unescape(data as AbstractJID).bareJID
			}
			return null;
		}
	}
}
