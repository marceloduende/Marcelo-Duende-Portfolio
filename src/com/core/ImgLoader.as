package com.core {
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * @author marcelosantos
	 */
	public class ImgLoader extends Sprite{
		public var queue:LoaderMax;
		public var bm:Bitmap;
		public var bmd:BitmapData;
		public function loadImg(url:String):void{
			queue = new LoaderMax({name:"imgLoader", onComplete:imgLoadComplete});
			queue.append( new ImageLoader(url, {name:"img"}));
			queue.load();
		}
		public function imgLoadComplete(e : LoaderEvent) : void {
			bmd = new BitmapData(queue.getContent("img").width, queue.getContent("img").height);
			bmd.draw(queue.getContent("img"));
			
			bm = new Bitmap;
			bm.bitmapData = bmd;
			//addChild(bm);
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
