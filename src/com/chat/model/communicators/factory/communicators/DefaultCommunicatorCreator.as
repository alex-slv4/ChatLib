/**
 * Created by kvint on 18.12.14.
 */
package com.chat.model.communicators.factory.communicators {
	import com.chat.model.IChatModel;
	import com.chat.model.communicators.DirectCommunicator;

	import org.igniterealtime.xiff.core.UnescapedJID;

	public class DefaultCommunicatorCreator implements ICommunicatorCreator {

		[Inject]
		public var model:IChatModel;

		protected var uid:String;
		protected var data:Object;

		public function DefaultCommunicatorCreator(data:Object, uid:String) {
			this.data = data;
			this.uid = uid;
		}

		public function create():* {
			return new DirectCommunicator(new UnescapedJID(uid), model.currentUser);
		}
	}
}
