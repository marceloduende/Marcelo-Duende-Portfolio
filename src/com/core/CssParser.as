package com.core {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;

	/**
	 * @author Marcelo
	 */
	public class CssParser extends Sprite {
		private var loader   : URLLoader = new URLLoader();
		private var request  : URLRequest = new URLRequest(Global.cssURL);
		public var cssParsed : StyleSheet;
		public function CssParser():void{}
		
		public function loadingCss():void{
        	loader.addEventListener(Event.COMPLETE, onComplete);
        	loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        	loader.load(request);
		}
		
		private function onComplete(event:Event):void{
			cssParsed = new StyleSheet();
			cssParsed.parseCSS(event.target.data);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void{
			trace("Error - Wrong URL or some shit you did :D");
		}
	}
}
