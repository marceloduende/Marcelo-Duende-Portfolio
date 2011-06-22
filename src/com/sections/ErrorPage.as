package com.sections {
	import com.Globals;
	import com.core.Modules;
	import com.utils.TextFactory;

	import flash.text.TextField;

	/**
	 * @author Marcelo
	 */
	public class ErrorPage extends Modules {
		public const ID:String = "errorPage"; // setting ID to get in SWFAddresManager
		
		
		public function ErrorPage() {
			super();
			pageID = ID;
			init();
		}

		private function init() : void {
			releaseMenu();
			var tfac : TextField = TextFactory.addText(Globals.confContent.child("sections").child("section")[5].child("menu").toString(), Globals.confContent.child("sections").child("section")[5].child("menu").@cssClass);
			addChild(tfac);
			tfac.x = 1256 / 2 - tfac.textWidth / 2;
			
			
			
		}
	}
}
