package com {
	import com.core.FontFactory;
	import com.core.XmlParser;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quart;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.CSSLoader;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	import com.utils.MCAnimation;
	import com.zoo.Aligner;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	/**
	 * @author Marcelo
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="1256", height="803")] 
	public class Preloader extends MovieClip{
	
		private var background:MovieClip;
		private var logoPreloader:MovieClip;
		private var addLogo : MCAnimation;
		private var addBkg : MCAnimation;
		private var parseInitAssets:XmlParser;
		//** formule  a:b = c:d ,  a x d = b x c 
		public var a:Number = undefined;
		public var b:Number = undefined;
		public var c:Number = 1024;
		public var d:Number = 728;
		
		private var objNames:Dictionary = new Dictionary();
		public var swfAssets:Vector.<Class> = new Vector.<Class>();
		public var swfAssetsNames:Vector.<String> = new Vector.<String>();
		
	
		
		
		public function Preloader():void{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			LoaderMax.activate([ImageLoader, CSSLoader, SWFLoader]);
			
			background = new MovieClip();
			logoPreloader = new MovieClip();
			
			// getting flash vars of conf.xml, the main xml for urls
			var flashVars:Object = this.loaderInfo.parameters;
			Globals.confURL = flashVars.initData;
			if (Globals.confURL == null || Globals.confURL == "") {
				Globals.confURL = "data/xml/conf.xml";
			}
			
			
			
			var queue:LoaderMax = new LoaderMax({name:"xmlLoader", onComplete:parseXML});
			queue.append( new XMLLoader(Globals.confURL, {name:"conf"}));
			queue.load();
			
		}
		private function parseXML(event:LoaderEvent):void{
			
			
			
			Globals.confContent = LoaderMax.getContent("conf");
			parseInitAssets = new XmlParser();
			parseInitAssets.parseXML(Globals.confContent, "initAssets");
			
			Globals.initAssetsURL = parseInitAssets.xmlParsed.child("swf")[0].@url;
			Globals.mainSWFURL = parseInitAssets.xmlParsed.child("swf")[1].@url;
			parseInitAssets.parseXML(Globals.confContent, "assets");
			Globals.assetsURL = parseInitAssets.xmlParsed.child("swf")[0].@url;
			Globals.fontsURL = parseInitAssets.xmlParsed.child("font")[0].@url;
			Globals.cssURL = parseInitAssets.xmlParsed.child("css")[0].@url;
			
			
			trace(Globals.confContent.child("assetNames").child("register").length() + "   damn")
			for (var i : int = 0; i < Globals.confContent.child("assetNames").child("register").length(); i++){
				trace(i + " damn")
				swfAssetsNames.push(Globals.confContent.child("assetNames").child("register")[i].@name.toString());
			}
			
			loadInitAssets();
		}
		
		private function loadInitAssets():void{
			logoPreloader = new MovieClip();
			addChild(logoPreloader);
			var loader : Loader = new Loader();
			loader.load(new URLRequest(Globals.initAssetsURL));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,startPreloader);
		}

		
		private function startPreloader(event:Event):void{
			addLogo = new MCAnimation();
			addLogo.getMCName(event.target.content.loaderInfo.applicationDomain.getDefinition("preloader_mushroom") as Class,  true);
			
			
			addBkg = new MCAnimation();
			addBkg.getMCName(event.target.content.loaderInfo.applicationDomain.getDefinition("background") as Class);
			
		//	trace(getQualifiedClassName(addLogo._currentObj) + " current shit");
			

			addChild(DisplayObject(addBkg._currentObj));
			addChild(DisplayObject(addLogo._currentObj));
			
			background = MovieClip(addBkg._currentObj);
			logoPreloader = MovieClip(addLogo._currentObj);
			
			
			
			Aligner.add(logoPreloader, {align:Aligner.CENTER});
			
			logoPreloader.percent_mc.percent_txt.text = "LOADING 0%";
			logoPreloader.percent_mc.alpha = 0;
			logoPreloader.percent_mc.x = -27.7;
			logoPreloader.percent_mc.y = 150;
			logoPreloader.addEventListener(Event.ENTER_FRAME, loop);
		//	trace(getQualifiedClassName(addLogo._currentObj));
			resize();
			stage.addEventListener(Event.RESIZE, resize);
		}
		
		
		private function loop(e:Event):void{
			if(e.currentTarget.currentLabel == "stop"){
				e.currentTarget.stop();
				logoPreloader.removeEventListener(Event.ENTER_FRAME, loop);
				TweenLite.to(logoPreloader.percent_mc, .5, {alpha:1, y:100, ease:Quart.easeOut, onComplete:startLoader});
			}
		}
		private var masterSWF:LoaderMax;
		private function startLoader():void{
			masterSWF = new LoaderMax({name:"xmlLoader", onComplete:mainSWFLoaded, onProgress:mainSWFProgress, onSoundComplete:null});
			masterSWF.append( new SWFLoader(Globals.mainSWFURL, {name:"mainSWF"}));
			masterSWF.append( new SWFLoader(Globals.assetsURL, {name:"assetsSWF"}));
			masterSWF.append( new SWFLoader(Globals.fontsURL, {name:"fontsSWF"}));
			masterSWF.append( new CSSLoader(Globals.cssURL, {name:"cssStyle"}));
			
			masterSWF.load();
			
		}
		
		private function mainSWFProgress(e:LoaderEvent):void{
			//trace(e.target.progress);
			logoPreloader.percent_mc.percent_txt.text = "LOADING " + int(e.target.progress * 100) + "%";
		}
		
		public var _logo : MCAnimation;
		public var _addFont : FontFactory;
		private function mainSWFLoaded(e:LoaderEvent):void{
			
			
			// getting assets from swf
			
			var appDomain:ApplicationDomain = masterSWF.getLoader("assetsSWF").rawContent.loaderInfo.applicationDomain;
            

			for (var i : int = 0; i < swfAssetsNames.length; i++){
				var appClass:Class = appDomain.getDefinition(swfAssetsNames[i].toString()) as Class;
				Globals.arrAssets.push(appClass);
			}
			
			
			/**
			 * adding font
			 */
			var appDomainFonts:ApplicationDomain = masterSWF.getLoader("fontsSWF").rawContent.loaderInfo.applicationDomain;
    		_addFont = new FontFactory(appDomainFonts, masterSWF.getLoader("fontsSWF").rawContent);
    		
    		/**
    		 * adding css
    		 */
    		 
    		Globals.css = masterSWF.getContent("cssStyle");
    		//trace(Globals.css)
    		
    		
			closePreloader();
		}
		
		private function closePreloader():void{
			logoPreloader.gotoAndPlay("playOut");
			logoPreloader.addEventListener(Event.ENTER_FRAME, loopEnd);
		}
		private function loopEnd(e:Event):void{
			if(e.currentTarget.currentLabel == "end"){
				e.currentTarget.stop();
				TweenLite.to(logoPreloader.percent_mc, .5, {alpha:0, y:150, ease:Quart.easeOut, onComplete:removeInstances});
				logoPreloader.removeEventListener(Event.ENTER_FRAME, loopEnd);
			}
		}
		
		private function removeInstances():void{
			removeChild(DisplayObject(addLogo._currentObj));
			addMain();
		}
		
		private function addMain():void{
			addChild(LoaderMax.getContent("mainSWF"));
		}
		
		
		public function resize(e:Event = null):void
		{
			background.x = 0;
			background.y = 0;
			background.height = stage.stageHeight;
			
			b = stage.stageHeight+10;
			var result1:Number = b * c;
			a = result1 / d;
			if(stage.stageWidth > 980)
			{
				if (a > stage.stageWidth) 
				{
					background.width = a;
					background.height = b;
					
				} else if (a < stage.stageWidth) 
				{
					a = stage.stageWidth+10;
					result1 = a * d;
					b = result1 / c;
					background.width = a;
					background.height = b;
				}
			} else if(stage.stageHeight > 800)
			{
				a = stage.stageHeight+10;
				result1 = a * c;
				b = result1 / d;
				background.width = b;
				background.height = a;
			}else{
				/*background.x = 0;
				background.y = 0;
				background.width = stage.stageWidth;
				background.width = stage.stageHeight;*/
			}
		}
	}
}
