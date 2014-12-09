/**
 * Created by kvint on 18.11.14.
 */
package com.chat.model.history {
	public interface IHistoryProvider {
		function fetchNext(minRequired:int):void;
	}
}
