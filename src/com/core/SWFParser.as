package com.core {
	import flash.display.DisplayObject;

	/**
	 * @author Marcelo
	 */
	
	
	public class SWFParser extends DisplayObject {
		static public var movieClipContainer:DisplayObject;
		public function SWFParser() {
		}
		public function addMovieClip(getMovieClip:DisplayObject):void{
			movieClipContainer = getMovieClip;
			stage.addChild(movieClipContainer);
			for(var i:* in movieClipContainer){
				trace(i + " saved object");
			}
		}
	}
}
