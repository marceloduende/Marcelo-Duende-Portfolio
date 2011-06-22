package com.core {
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;

	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * @author Marcelo
	 */
	public class XmlLoader extends Sprite{
		public var xmlLoaded:XML;
		public var queue:LoaderMax;
		public function loadXML(url:String):void{
			queue = new LoaderMax({name:"xmlLoader", onComplete:xmlLoadComplete});
			queue.append( new XMLLoader(url, {name:"xml"}));
			queue.load();
		}

		public function xmlLoadComplete(e : LoaderEvent) : void {
			xmlLoaded = new XML(queue.getContent("xml"));
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
