package com.sections {
	import com.Globals;
	import com.core.Modules;
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	import com.utils.TextFactory;

	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * @author Marcelo
	 */
	public class About extends Modules {
		
		public const ID:String = "about"; // setting ID to get in SWFAddresManager
		
		private var queueWorkXML:LoaderMax;
		private var xml:XML;
		private var mcImage:MovieClip;
		
		
		public function About() {
			super();
			pageID = ID;
			init();
		}
		private function init():void{
			handleProgress(Number(0));
			releaseMenu();
			LoaderMax.activate([XMLLoader,ImageLoader]);
			queueWorkXML = new LoaderMax({name:"about"});
			queueWorkXML.append(new XMLLoader(Globals.confContent.child("sections").child("section")[1].@xmlURL, {name:"aboutXML", onComplete:onXMLComplete}));
			queueWorkXML.load();
		}
		private function onXMLComplete(e:LoaderEvent):void{
			
			xml = new XML(LoaderMax.getContent("aboutXML"));
			
			var queueWork : LoaderMax = new LoaderMax({name:"imgAbout", onComplete:handleComplete, onProgress:_onProgress});
			queueWork.append(new ImageLoader(xml.child("image").@src, {name:"image", alpha:1}));
			queueWork.load();
		}
		
		private function _onProgress(e:LoaderEvent):void{
			handleProgress(Number(e.target.progress * 100));
		}
		private var tf:TextField;
		private function handleComplete(e:LoaderEvent):void{
			mcImage = new MovieClip();
			mcImage.alpha = 0;
			addChild(mcImage);
			mcImage.addChild(LoaderMax.getContent("image"));
			TweenMax.to(mcImage, .6, {alpha:1});
			
			
			tf = TextFactory.addText(xml.child("register")[0].child("title").toString(), xml.child("register")[0].child("title").@cssClass);
			
			tf.x = mcImage.width + 10;
			tf.y = 0;
			addChild(tf);
			
			
			
			var cf:TextField = TextFactory.addText(xml.child("register")[0].child("copy"), xml.child("register")[0].child("copy").@cssClass, 900, 200);
			cf.x = mcImage.width + 10;
			cf.y = tf.y + tf.textHeight + 10;
			
			var tf2:TextField = TextFactory.addText(xml.child("register")[1].child("title"), xml.child("register")[0].child("title").@cssClass);
			tf2.x = mcImage.width + 10;
			tf2.y = cf.y + cf.textHeight + 40;
			var cf2:TextField = TextFactory.addText(xml.child("register")[1].child("copy"), xml.child("register")[0].child("copy").@cssClass, 900, 200);
			cf2.x = mcImage.width + 10;
			cf2.y = tf2.y + tf2.textHeight + 10;
			
			addChild(cf);
			addChild(tf2);
			addChild(cf2);
			
			
		}
	}
}
