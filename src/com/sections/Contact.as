package com.sections {
	import com.core.Modules;

	import flash.text.TextField;

	/**
	 * @author Marcelo
	 */
	public class Contact extends Modules {
		
		public const ID:String = "contact"; // setting ID to get in SWFAddresManager
		
		public function Contact() {
			super();
			pageID = ID;
			init();
		}
		private function init():void{
			releaseMenu();
			var tf:TextField = new TextField();
			tf.text = "Contact";
			addChild(tf);
		}
	}
}
