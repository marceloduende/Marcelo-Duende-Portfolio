package com.sections {
	import com.core.Modules;

	import flash.text.TextField;

	/**
	 * @author Marcelo
	 */
	public class Photo extends Modules {
		public const ID:String = "photos"; // setting ID to get in SWFAddresManager
		public function Photo() {
			super();
			pageID = ID;
			init();
		}
		private function init():void{
			releaseMenu();
			var tf:TextField = new TextField();
			tf.text = "Photo";
			addChild(tf);
		}
	}
}
