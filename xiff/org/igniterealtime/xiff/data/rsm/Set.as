/**
 * Created by AlexanderSla on 06.11.2014.
 */
package org.igniterealtime.xiff.data.rsm {
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;

	/**
	 *  <xs:element name='set'>
	 		<xs:complexType>
	 			<xs:sequence>
					 <xs:element name='after' type='xs:string' minOccurs='0' maxOccurs='1'/>
					 <xs:element name='before' type='xs:string' minOccurs='0' maxOccurs='1'/>
					 <xs:element name='count' type='xs:int' minOccurs='0' maxOccurs='1'/>
					 <xs:element ref='first' minOccurs='0' maxOccurs='1'/>
					 <xs:element name='index' type='xs:int' minOccurs='0' maxOccurs='1'/>
					 <xs:element name='last' type='xs:string' minOccurs='0' maxOccurs='1'/>
					 <xs:element name='max' type='xs:int' minOccurs='0' maxOccurs='1'/>
	 			</xs:sequence>
	 		</xs:complexType>
	 	</xs:element>

	 	<xs:element name='first'>
	 		<xs:complexType>
	 			<xs:simpleContent>
	 				<xs:extension base='xs:string'>
	 					<xs:attribute name='index' type='xs:int' use='optional'/>
	 				</xs:extension>
	 			</xs:simpleContent>
	 		</xs:complexType>
	 	</xs:element>
	 */

	public class Set extends Extension implements IExtension {

		public static const ELEMENT_NAME:String = "set";
		public static const NS:String = "http://jabber.org/protocol/rsm";

		public static const MAX:String = "max";
		public static const LAST:String = "last";
		public static const INDEX:String = "index";
		public static const COUNT:String = "count";
		public static const BEFORE:String = "before";
		public static const AFTER:String = "after";

		public function get max():int {
			return getField(MAX) as int;
		}

		public function set max(value:int):void {
			setField(MAX, String(value));
		}

		public function get last():String {
			return getField(LAST);
		}

		public function set last(value:String):void {
			setField(LAST, value);
		}

		public function get index():int {
			return getField(INDEX) as int;
		}

		public function set index(value:int):void {
			setField(INDEX, String(value));
		}

		public function get count():int {
			return getField(COUNT) as int;
		}

		public function set count(value:int):void {
			setField(COUNT, String(value));
		}

		public function get before():String {
			return getField(BEFORE);
		}

		public function set before(value:String):void {
			setField(BEFORE, value);
		}

		public function get after():String {
			return getField(AFTER);
		}

		public function set after(value:String):void {
			setField(AFTER, value);
		}

		public function get first():First {
			return null;;
		}

		public function set first(value:First):void {

		}


		public function getNS():String {
			return NS;
		}

		public function getElementName():String {
			return ELEMENT_NAME;
		}
	}
}

import org.igniterealtime.xiff.data.INodeProxy;
import org.igniterealtime.xiff.data.XMLStanza;

class First extends XMLStanza implements INodeProxy {

	public function First(parent:XML) {

	}
}