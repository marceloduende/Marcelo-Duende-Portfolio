package com.sections {
	import com.Globals;
	import com.asual.swfaddress.SWFAddress;
	import com.core.Modules;
	import com.core.XmlLoader;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.utils.TextFactory;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * @author Marcelo
	 */
	
	public class Home extends Modules {
		
		public const ID:String = "home"; // setting ID to get in SWFAddresManager
		private var homeXML:XML;
		private var titles:Vector.<String>;
		private var descriptions:Vector.<String>;
		private var agencies:Vector.<String>;
		private var clients:Vector.<String>;
		private var images:Vector.<String>;
		private var thumbnails:Vector.<String>;
		private var hrefs:Vector.<String>;
		private var rotatingID:int = 0;
		private var titleText:TextField;
		private var titleThumbText:TextField;
		private var descriptionText:TextField;
		
		private var barbkg:Sprite;
		private var bar:Sprite;
		
		private var bigImg:MovieClip;
		private var thumbImg:MovieClip;
		private var imageURL:String;
		private var thumbURL:String;
		private var imageLoaders:LoaderMax;
		private var masky:Sprite;
		
		private var imagesID:int;
		
		private var xmlContent:XmlLoader;
		
		private var timer:Timer = new Timer(20000, 0);
		
		public function Home():void {
			super();
			pageID = ID;
			
			init();
			
			
		}

		public function init() : void {
			xmlContent = new XmlLoader();
			xmlContent.loadXML(Globals.confContent.child("sections").child("section")[0].@xmlURL.toString());
			xmlContent.addEventListener(Event.COMPLETE, onXMLComplete);
		}

		private function onXMLComplete(e : Event) : void {
			homeXML = new XML(xmlContent.xmlLoaded);
			titles = new Vector.<String>;
			descriptions = new Vector.<String>;
			agencies = new Vector.<String>;
			clients = new Vector.<String>;
			images = new Vector.<String>;
			thumbnails = new Vector.<String>;
			hrefs = new Vector.<String>;
			for(var i:int = 0; i<homeXML.child("register").length(); i++){
				titles.push(homeXML.child("register")[i].child("title").toString());
				descriptions.push(homeXML.child("register")[i].child("description").toString());
				agencies.push(homeXML.child("register")[i].child("agency").toString());
				clients.push(homeXML.child("register")[i].child("client").toString());
				images.push(homeXML.child("register")[i].child("image").toString());
				thumbnails.push(homeXML.child("register")[i].child("thumbnail").toString());
				hrefs.push(homeXML.child("register")[i].child("href").toString());
			} 
			bigImg = new MovieClip();
			addChild(bigImg);
			thumbImg = new MovieClip();
			addChild(thumbImg);
			thumbImg.y = 380;
			
			masky = new Sprite();
			masky.graphics.beginFill(0x000000, .3);
			masky.graphics.drawRect(0, 0, 300, 200);
			masky.y = 360;
			addChild(masky);
			masky.buttonMode = false;
			masky.mouseChildren = false;
			masky.mouseEnabled = false;
			masky.useHandCursor = false;
			thumbImg.mask = masky;
			thumbImg.addEventListener(MouseEvent.CLICK, clickHandle);
			thumbImg.buttonMode = true;
			
			bar = new Sprite();
			barbkg = new Sprite();
			bar.graphics.beginFill(0x000000);
			bar.graphics.drawRect(0, 317, 561, 3);
			bar.graphics.endFill();
			
			barbkg.graphics.beginFill(0xFFFFFF);
			barbkg.graphics.drawRect(0, 317, 561, 3);
			barbkg.graphics.endFill();
			addChild(barbkg);
			addChild(bar);
			bar.alpha = barbkg.alpha = 0;
			imageLoaders = new LoaderMax({name:"img", onComplete:onTopImgLoaded});
			topBox(rotatingID);
			thumbBox(rotatingID);
			timer.addEventListener(TimerEvent.TIMER, changeImage);
			timer.start();
			releaseMenu();
		}
		
		/**
		 * mouse events
		 */
		private function clickHandle(e:MouseEvent):void{
			
			timer.stop();
			timer.start();
			TweenMax.to(bar, speed, {alpha:0, ease:Quint.easeOut});
			TweenMax.to(barbkg, speed, {alpha:0, ease:Quint.easeOut});
			changeImage();
		}
		
		/**
		 * Changing image
		 */
		private function changeImage(e:TimerEvent = null):void{
			TweenMax.to(bar, speed, {alpha:0, ease:Quint.easeOut});
			TweenMax.to(barbkg, speed, {alpha:0, ease:Quint.easeOut});
			TweenMax.to(bigImg, speed, {alpha:0, y:-100, scaleX:.92,rotationX:-50, ease:Quint.easeIn});
			TweenMax.to(thumbImg, speed, {y:120, onComplete:removeImages, ease:Quint.easeIn});
			
		}
		private function removeImages():void{
			bigImg.scaleX = 1;
			bigImg.alpha = 0;
			bigImg.y = 200;
			bigImg.rotationX = 50;
			thumbImg.y = 580;
			for(;bigImg.numChildren;){
				bigImg.removeChildAt(0);
			}
			for(;thumbImg.numChildren;){
				thumbImg.removeChildAt(0);
			}
			topBox(rotatingID);
			thumbBox(rotatingID);
		}
		
		/**
		 * loading top img - TOPBOX
		 */
		private function topBox(id:int) : void {
			imagesID = id;
			imageURL = images[id];
			bigImg.alpha = 0;
			bigImg.y = 200;
			bigImg.rotationX = 50;
			imageLoaders.unload();
			imageLoaders.append( new ImageLoader(imageURL, {name:"imgHome", container:bigImg}));
			imageLoaders.load();
			titleText = TextFactory.addText(titles[id].toString(), homeXML.child("register")[id].child("title").@cssClass);
			bigImg.addChild(titleText);
			bigImg.addEventListener(MouseEvent.CLICK, gotoWork);
			bigImg.buttonMode = true;
			titleText.x = 583;
			descriptionText = TextFactory.addText(descriptions[id].toString() + "<br/><br/><br/><br/>" + agencies[id] + "<br/>" + clients[id], homeXML.child("register")[id].child("description").@cssClass, 666, 315);
			bigImg.addChild(descriptionText);
			descriptionText.x = 583;
			descriptionText.y = titleText.textHeight + 10;
			rotatingID++;
			if(rotatingID == homeXML.child("register").length()){
				rotatingID = 0;
			}
		}
		private function gotoWork(e:MouseEvent):void{
			//navigateToURL(new URLRequest(hrefs[imagesID]), "_self");
			Globals.simpleAddressID = "work";
			SWFAddress.setValue("work/" + hrefs[imagesID]);
			Globals.addressID = hrefs[imagesID];
			parseURL("work", "com.sections");
		}
		
		
		private function onTopImgLoaded(e:LoaderEvent) : void {
			bigImg.scaleX = 1;
			bigImg.alpha = 0;
			bigImg.y = 200;
			bigImg.rotationX = 50;
			thumbImg.y = 580;
			TweenMax.to(bigImg, speed, {alpha:1, y:0, rotationX:0, ease:Quint.easeOut});
			TweenMax.to(thumbImg, speed, { y:380, rotationX:0, ease:Quint.easeOut});
			at = getTimer();
			progressBar();
			
		}
		
		private function thumbBox(id:int) : void {
			thumbURL = thumbnails[id];
			thumbImg.y = 580;
			imageLoaders.unload();
			imageLoaders.append( new ImageLoader(thumbURL, {name:"thumbHome", container:thumbImg}));
			imageLoaders.load();
			
			titleThumbText = TextFactory.addText(titles[id].toString(), homeXML.child("register")[id].child("thumbnail").@cssClass);
			thumbImg.addChild(titleThumbText);
			titleThumbText.y = 145;
			
		}
		
		/**
		 * progress time bar
		 */
		private function progressBar():void{
			bar.y = barbkg.y = 150;
			TweenMax.to(bar, speed, {alpha:1, y:0, ease:Quint.easeOut});
			TweenMax.to(barbkg, speed, {alpha:1, y:0, ease:Quint.easeOut});
			addEventListener(Event.ENTER_FRAME, moveBar);
		}
		private var at:Number;
		private var bt:Number;
		private function moveBar(e:Event):void{
			bt = getTimer() - at;
			bar.scaleX = bt/20000 + .1;
			if(bar.scaleX >= 1){
				bar.scaleX = 1;
				removeEventListener(Event.ENTER_FRAME, moveBar);
				TweenMax.to(bar, speed, {alpha:0, ease:Quint.easeOut});
				TweenMax.to(barbkg, speed, {alpha:0, ease:Quint.easeOut});
			}
		}
	}
}
