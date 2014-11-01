/**
 * Created by mikhailkuts on 30.07.14.
 */
package utils.providers {
import flash.utils.Dictionary;

public interface IViewDataProvider {

	function subscribe(callback:Function)		:void;
	function unsubscribe(callback:Function)		:void;

	function set data(value:Object)				:void;
	function get data()							:Object;
	function get dataAsInt()					:int;
	function get dataAsDictionary()				:Dictionary;

}
}
