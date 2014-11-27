/**
 * Created by AlexanderSla on 27.11.2014.
 */
package com.chat.utils {
	import org.igniterealtime.xiff.data.im.IRosterItemVO;
	import org.igniterealtime.xiff.data.im.RosterExtension;

	public class FriendUtil {
		public static function isFriend(item:IRosterItemVO):Boolean{

			switch (item.subscribeType){
				case RosterExtension.SUBSCRIBE_TYPE_BOTH:
					return true;
				case RosterExtension.SUBSCRIBE_TYPE_FROM:
					if(item.askType == RosterExtension.ASK_TYPE_SUBSCRIBE) { // User asks contact to subscription
						return true;
					}
			}
			return false;
		}
	}
}
