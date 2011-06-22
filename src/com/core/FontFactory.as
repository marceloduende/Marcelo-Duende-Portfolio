package com.core {
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.text.Font;

	/**
	 * @author Marcelo
	 */
	public class FontFactory extends Sprite {
		public var registeredfonts:Array = new Array();
		private var font:Font;
		
		public function FontFactory(domain:ApplicationDomain, stageContent:*):void{
			trace(stageContent.numChildren + " content")
			for(var i:uint; i<stageContent.numChildren; i++){
				var fontClass:Class = Class( domain.getDefinition( stageContent.getChildAt(i).text ) );
				
 				Font.registerFont( fontClass );
			}
			registeredfonts = Font.enumerateFonts();
			
			for(i = 0; i < registeredfonts.length; i++){
				font = registeredfonts[i];
				trace("name : " + font.fontName);
				trace("style : " + font.fontStyle);
				trace("type : " + font.fontType);
				trace("");
			}
			
			
		}
	}
}
