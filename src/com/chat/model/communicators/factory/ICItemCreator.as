/**
 * Created by kuts on 12/3/14.
 */
package com.chat.model.communicators.factory
{
import com.chat.model.IChatModel;
import com.chat.model.communicators.DirectCommunicator;
import com.chat.model.communicators.ICommunicator;
import com.chat.model.data.citems.ICItem;

import org.igniterealtime.xiff.core.AbstractJID;
import org.igniterealtime.xiff.core.UnescapedJID;
import org.igniterealtime.xiff.util.JIDUtil;
import org.igniterealtime.xiff.util.JIDUtil;

public class ICItemCreator implements ICreator
{
	[Inject]
	public var model:IChatModel;

	private var _icItem:ICItem;

	public function ICItemCreator(item:ICItem) {
		_icItem = item;
	}

	public function get uid():String {
		if(from){
			return from.bareJID;
		}
		return null;
	}

	private function get from():UnescapedJID
	{
		if(_icItem.from is AbstractJID){
			return JIDUtil.unescape(_icItem.from as AbstractJID);
		}
		return null;
	}

	public function create():ICommunicator {
		return new DirectCommunicator(from, model.currentUser);
	}
}
}
