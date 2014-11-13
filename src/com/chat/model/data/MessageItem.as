/**
 * Created by kvint on 13.11.14.
 */
package com.chat.model.data
{
import org.igniterealtime.xiff.core.AbstractJID;
import org.igniterealtime.xiff.data.Message;

public class MessageItem implements ICItem
{

	private var _data:Message;
	private var _isRead:Boolean;

	public function MessageItem(data:Message)
	{
		_data = data;
	}

	public function get time():Number
	{
		return 0;
	}

	public function get from():Object
	{
		if (data.from is AbstractJID)
			return (data.from as AbstractJID).node;
		else if (data.from is String)
			return data.from;
		else
			return data.from;
	}

	public function get body():Object
	{
		return data.body;
	}

	public function get isRead():Boolean
	{
		return _isRead;
	}

	public function get data():Message
	{
		return _data;
	}
}
}
