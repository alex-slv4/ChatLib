/**
 * Created by AlexanderSla on 05.11.2014.
 */
package org.igniterealtime.xiff.data.archive {
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;

	public class ArchiveExtension extends Extension implements IExtension {

		public static const NS:String = "urn:xmpp:archive";
		public static const ELEMENT_NAME:String = "pref";

		public function ArchiveExtension(parent:XML = null) {
			super(parent);
		}

		public function getNS():String {
			return NS;
		}

		public function getElementName():String {
			return ELEMENT_NAME;
		}
	}
}
