/**
 * Created by kvint on 18.12.14.
 */
package com.chat.model.communicators.factory.uid {
	import org.igniterealtime.xiff.data.im.RosterItemVO;

	public class RosterItemUIDCreator extends DefaultUIDCreator {
		public function RosterItemUIDCreator(data:RosterItemVO) {
			super(data);
		}

		override public function toString():String {
			if(data is RosterItemVO){
				return (data as RosterItemVO).jid.bareJID;
			}
			return super.toString();
		}
	}
}
