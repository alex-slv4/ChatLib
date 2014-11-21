/**
 * Created by AlexanderSla on 11.11.2014.
 */
package com.chat.controller.commands.cm {
	import com.chat.controller.commands.*;
	import com.chat.events.CommunicatorFactoryEvent;
	import com.chat.events.CommunicatorCommandEvent;
	import com.chat.model.communicators.ICommunicatorBase;
	import com.chat.model.communicators.ICommunicatorFactory;
	import com.chat.model.data.CItemString;

	import flash.events.IEventDispatcher;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	public class CMCommand extends BaseChatCommand implements ICommand, ICMCommand{

		[Inject]
		public var event:CommunicatorCommandEvent;
		[Inject]
		public var communicators:ICommunicatorFactory;

		[Inject]
		public var bus:IEventDispatcher;
		private var _communicator:ICommunicatorBase;

		override public function execute():void {
			_communicator = event.communicator;
			setUp();

			if (!hasErrors()) {
				executeIfNoErrors();
			}

			tearDown();
		}


		private function setUp():void {
			communicators.addEventListener(CommunicatorFactoryEvent.COMMUNICATOR_DESTROYED, onCommunicatorDestroyed);
		}
		private function tearDown():void {
			communicators.removeEventListener(CommunicatorFactoryEvent.COMMUNICATOR_DESTROYED, onCommunicatorDestroyed);
		}

		protected function onCommunicatorDestroyed(e:CommunicatorFactoryEvent):void {
			if(e.data === _communicator){
				_communicator = null;
			}
		}

		protected function executeIfNoErrors():void {

		}

		public function hasErrors():Boolean {
			var result:Boolean;
			if (communicator == null) {
				result = true;
			}
			if (params.length < this.requiredParamsCount) {
				onParamsError();
				result = true;
			}
			return result;
		}

		protected function onParamsError():void {
			error("params expected", this.requiredParamsCount, "got", params.length);
		}

		protected function print(...args):void {
			args.unshift(0);
			write.apply(this, args);
		}

		protected function error(...args):void {
			args.unshift(1);
			write.apply(this, args);
		}

		public function write(type:int, ...args):void {
			var prefix:String = type == 1 ? "error" : "";
			communicator.push(new CItemString(prefix + " " + args.join(" ")));
		}

		public function get communicator():ICommunicatorBase {
			return _communicator;
		}

		public function get params():Array {
			return event.params;
		}

		public function get requiredParamsCount():int {
			return 0;
		}
	}
}
