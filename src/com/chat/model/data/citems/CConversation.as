/**
 * Created by AlexanderSla on 11.12.2014.
 */
package com.chat.model.data.citems {
	import com.chat.events.CItemCollectionEvent;
	import com.chat.events.DataEvent;
	import com.chat.model.communicators.DirectCommunicator;
	import com.chat.model.communicators.ICommunicator;

	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;

	import org.igniterealtime.xiff.core.AbstractJID;

	public class CConversation extends EventDispatcher implements ICConversation {


		private var _communicator:DirectCommunicator;
		private var _timeData:CTime = new CTime();
		private var _last:ICItem = new CItem("");

		public function CConversation(communicator:DirectCommunicator, startTime:Number = NaN) {
			super(communicator);
			_communicator = communicator;
			_timeData.originTime = startTime;
			//_communicator.items.addEventListener(CItemCollectionEvent.CHANGE, onCollectionChanged);
			setTimeout(function():void{this.last=new CItem("Hello wordl")}, Math.round(Math.random() * 1000))
		}

		private function onCollectionChanged(event:CItemCollectionEvent):void {
			if(communicator.items.length){
				this.last = communicator.items.getItemAt(communicator.items.length - 1);
			}
		}

		public function get withJID():AbstractJID {
			return (communicator as DirectCommunicator).participant;
		}

		public function get communicator():ICommunicator {
			return _communicator;
		}
		public function get last():ICItem {
			return _last;
		}

		public function set last(value:ICItem):void {
			if(_last != value){
				_last = value;
				dispatchEvent(new DataEvent(DataEvent.LAST_CHANGED, value));
			}
		}

		public function get data():* {
			return _communicator;
		}
		override public function toString():String {
			return withJID.bareJID + " " + last.toString();
		}

		public function set originTime(value:Number):void {
			_timeData.originTime = value;
		}

		public function get originTime():Number {
			return _timeData.originTime;
		}

		public function get time():Number {
			return _timeData.time;
		}

		public function destroy():void {
			_communicator.items.removeEventListener(CItemCollectionEvent.CHANGE, onCollectionChanged);
		}

	}
}
