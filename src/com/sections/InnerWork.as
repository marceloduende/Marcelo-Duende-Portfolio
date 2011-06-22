package com.sections {
	import com.Globals;
	import com.asual.swfaddress.SWFAddress;
	import com.core.ImgLoader;
	import com.core.VideoLoader;
	import com.core.XmlLoader;
	import com.greensock.TweenMax;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	import com.utils.MCAnimation;
	import com.utils.TextFactory;

	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	/**
	 * @author Marcelo
	 */
	public class InnerWork extends Sprite {
		
		public static var ID:String;
		
		private var xml:XmlLoader;
		private var xmlPath:String = Globals.confContent.child("globalXMLData").toString();
		private var xmlFileName:String = "/client.xml";
		private var loadXML:LoaderMax;
		
		private var title:String;
		private var copy:String;
		private var agency:String;
		private var client:String;
		private var link:String;
		private var seeMore:String;
		private var vecType:Vector.<String> = new Vector.<String>();
		private var vecURL:Vector.<String> = new Vector.<String>();
		private var vecText:Vector.<String> = new Vector.<String>();
		private var vecCss:Vector.<String> = new Vector.<String>();
		private var vecButtons:Vector.<MovieClip> = new Vector.<MovieClip>();
		
		private var imgLoader:ImgLoader;
		private var id_loader:int = 0;
		private var current_id:int = 99999;
		private var imgContainer:Sprite;
		
		public var vidLoader:VideoLoader;
		
		
		
		
		public function init($id:String):void{
			ID = $id;
			/*var tf:TextField = new TextField();
			tf.width =1000;
			tf.y = -80;
			tf.text = $id + "  innnner";
			addChild(tf); 
			*/
			imgContainer = new Sprite;
			addChild(imgContainer);
			imgContainer.name = "imgContainer";
			
			LoaderMax.activate([XMLLoader, ImageLoader, VideoLoader]);
			xml = new XmlLoader();
			xml.loadXML(xmlPath + ID + xmlFileName);
			xml.addEventListener(Event.COMPLETE, parseXMLData);
		}
		
		
		private function parseXMLData(e:Event):void{
			
			title = xml.xmlLoaded.child("title").toString();
			copy = xml.xmlLoaded.child("copy").toString();
			agency = xml.xmlLoaded.child("agency").toString();
			client = xml.xmlLoaded.child("client").toString();
			link = xml.xmlLoaded.child("link").toString();
			seeMore = xml.xmlLoaded.child("seeMore").toString();

			for (var i : int = 0; i < xml.xmlLoaded.child("register").length(); i++) {
				vecText.push(xml.xmlLoaded.child("register")[i].toString());
				vecType.push(xml.xmlLoaded.child("register")[i].@type);
				vecURL.push(xml.xmlLoaded.child("register")[i].@url);
				vecCss.push(xml.xmlLoaded.child("register")[i].@cssClass);
			}
			
			addText();
			imageLoader();
			imageMenu();
			addShare();
		}
		
		/**
		 * adding text
		 */
		
		private function addText():void{
			
			var delay:Number = .2;
			
			
			var tfTitle:TextField;
			tfTitle = TextFactory.addText(title, xml.xmlLoaded.child("title").@cssClass);
			tfTitle.x = 820;
			tfTitle.alpha = 0;
			addChild(tfTitle);
			
			var tfDesc:TextField;
			tfDesc = TextFactory.addText(copy, xml.xmlLoaded.child("copy").@cssClass, 400, 400);
			tfDesc.x = 820;
			tfDesc.y = 50;
			tfDesc.alpha = 0;
			addChild(tfDesc);
			
			var tfAg:TextField;
			tfAg = TextFactory.addText(agency, xml.xmlLoaded.child("agency").@cssClass);
			tfAg.x = 820;
			tfAg.y = 393;
			tfAg.alpha = 0;
			addChild(tfAg);
			
			var tfCl:TextField;
			tfCl = TextFactory.addText(client, xml.xmlLoaded.child("client").@cssClass);
			tfCl.x = 820;
			tfCl.y = tfAg.y + 20;
			tfCl.alpha = 0;
			addChild(tfCl);
			
			var tfLaunch:TextField;
			tfLaunch = TextFactory.addText(link, xml.xmlLoaded.child("link").@cssClass);
			tfLaunch.x = 820;
			tfLaunch.y = tfCl.y + 20;
			tfLaunch.alpha = 0;
			addChild(tfLaunch);
			
			var tfSee:TextField;
			tfSee = TextFactory.addText(seeMore, xml.xmlLoaded.child("seeMore").@cssClass);
			tfSee.y = 460;
			tfSee.alpha = 0;
			addChild(tfSee);
			
			TweenMax.to(tfTitle, .2, {alpha:1, delay:delay});
			TweenMax.to(tfDesc, .2, {alpha:1, delay:delay+.1});
			TweenMax.to(tfAg, .2, {alpha:1, delay:delay+.2});
			TweenMax.to(tfCl, .2, {alpha:1, delay:delay+.2});
			TweenMax.to(tfLaunch, .2, {alpha:1, delay:delay+.3});
			TweenMax.to(tfSee, .2, {alpha:1, delay:delay+.4});
		}
		
		/**
		 * adding share icons
		 * 
		 */
		private var fb:MCAnimation;
		private var twitter:MCAnimation;
		private function addShare() : void {
			fb = new MCAnimation();
			twitter = new MCAnimation();
			
			fb.getMCName(Globals.arrAssets[6]);
			twitter.getMCName(Globals.arrAssets[7]);
			
			addChild(DisplayObject(fb._currentObj));
			addChild(DisplayObject(twitter._currentObj));
			
			fb._currentObj.x = 820;
			fb._currentObj.y = 360;
			
			twitter._currentObj.x = 850;
			twitter._currentObj.y = 360;

			fb._currentObj.addEventListener(MouseEvent.CLICK, fbShare);
			fb._currentObj.buttonMode = true;
			twitter._currentObj.addEventListener(MouseEvent.CLICK, fbTwitter);
			twitter._currentObj.buttonMode = true;
			
		}
		
		public function fbShare(e:MouseEvent):void{
			
			
			var title:String = 'Marcelo Duende - Creative Flash Developer';
			var description:String = 'Flash';
			var image:String = 'http://www.marceloduende.com/images/facebook.jpg';
			//var deeplink:String = "http://www.marceloduende.com.br/2011/fbshare.php?redirect=" + escape( 'deeplink url to gallery' );
			var deeplink:String = "http://www.marceloduende.com/" + escape( "#" + SWFAddress.getPath() );			
			/*deeplink += "&fbsharetitle=" + escape( title );
			deeplink += "&fbsharedescription=" + escape( description );
			deeplink += "&fbshareimage=" + escape( image ) + "&";
			*/
			var url:String = "http://www.facebook.com/sharer.php?t=" + escape( title ) + "&u=" + escape( deeplink ) + "&i=" + escape( image );
			
			ExternalInterface.call( "window.open", url, "marceloduendesharing", "width=600, height=400, status=no, menubar=no, location=no, scrollbars=0" );
			
			
			/*
			trace(Globals.addressID + "      damns")
			//Globals.addressID = SWFAddress.getPath();
			
			//navigateToURL(new URLRequest("http://www.facebook.com/sharer.php?u=http://marceloduende.com.br/2011/&#35;" + "/work/can"), "_blank");
			navigateToURL(new URLRequest("http://www.facebook.com/sharer.php?u=" + "http://www.marceloduende.com.br/2011/" + "&t=" + SWFAddress.getPath()), "_blank");
			*/
		}
		
		public function fbTwitter(e:MouseEvent):void{
			var url_for_tweet:String  	= "http://marceloduende.com/" + "&t=" + "work/create";
			var twitter_status:String 	= encodeURIComponent( "Just sharing the @marceloduende work at - http://marceloduende.com.br/#" +SWFAddress.getPath() );
			navigateToURL(new URLRequest("http://twitter.com/home/?status=" + twitter_status), "_blank");
		}
		
		/**
		 * bottom image menu
		 */
		
		
		
		private function imageMenu():void{
			
			
			
			var decreaseCounter:int = vecText.length-1;
			
			vecText.reverse();
			vecCss.reverse();
			//vecType.reverse();
			
			var _delay:Number;
			
			for(var i:int = 0; i < vecText.length; i++){
				var addTextButton:MovieClip;
				addTextButton = TextFactory.addButton(vecText[i], vecCss[i]);
				vecButtons.push(addTextButton);
				addTextButton["index"] = decreaseCounter;
				addTextButton.y = 460;
				if(i==0){
					addTextButton.x = 800 - vecButtons[0].width;
				} else {
					addTextButton.x = vecButtons[i-1].x - vecButtons[i].width;
				}
				addTextButton.alpha = 0;
				TweenMax.to(addTextButton, .2, {alpha:1, delay:.05*i});
				_delay = .05*i;
				addChild(addTextButton);
				addTextButton.addEventListener(MouseEvent.CLICK, changeView);
				decreaseCounter--;
			}
			vecButtons.reverse();
			TweenMax.to(vecButtons[id_loader], .3, {alpha:.5, delay:_delay});
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardView);
		}
		
		/**
		 * change button numbers style
		 */
		 
		private function buttonStyle() : void {
			for (var i : int = 0; i < vecButtons.length; i++){
				TweenMax.to(vecButtons[i], .3, {alpha:1, overwrite:true});
			}
			TweenMax.to(vecButtons[id_loader], .3, {alpha:.2, delay:.2, overwrite:true});
			
		}
		
		/**
		 * change the image view (photo or video)
		 */
		
		private function changeView(e:MouseEvent):void{
			id_loader = e.currentTarget.index;
			
			switch(vecType[id_loader]){
				case "photo":
					imageLoader();
				break;
				case "video":
					videoLoader();
				break;
			}
			buttonStyle();
			
		}
		
		/**
		 * keyboard view
		 */
		 
		private function keyboardView(e:KeyboardEvent):void{
			switch(e.keyCode) {
				case Keyboard.RIGHT:
					if (id_loader < vecText.length-1){
						id_loader = id_loader + 1;
					}
				break;
				case Keyboard.LEFT:
					if (id_loader > 0){
						id_loader = id_loader - 1;
					}
				break;
			}
			
			
			
			if(vecType[id_loader] === "photo"){
				imageLoader();
			}
			if(vecType[id_loader] === "video"){
				videoLoader();
			}
			
			buttonStyle();
		}
		
		
		/**
		 * image loader
		 */
		
		private function imageLoader():void{
			
			if(current_id != id_loader){
				/*if(VideoLoader.ns){
					VideoLoader.ns.close();
					VideoLoader.ns.togglePause();
	        		VideoLoader.ns.pause();
	        		VideoLoader.ns.close();
	        		VideoLoader.nc.close();
				}*/
				if (vidLoader) {
					vidLoader.dispose();
				}
				if(imgLoader){
					TweenMax.to(imgContainer, .2, {alpha:0, onComplete:disposeImg});
				} else {
					callNewImage();
				}
			}
			disposeVid();
			current_id = id_loader;
		}
		private var loadTf:TextField;
		private function callNewImage():void{
			/*if(VideoLoader.ns){
				VideoLoader.ns.close();
			}*/
			if (vidLoader) {
				vidLoader.dispose();
			}
			disposeVid();
			loadTf = TextFactory.addText("loading", "thumb_title");
			addChild(loadTf);
			loadTf.x = 400 - loadTf.width/2;
			loadTf.y = 225 - loadTf.height;
			loadTf.alpha = 0;
			TweenMax.to(loadTf, .2, {alpha:1, overwrite:true});
			imgLoader = new ImgLoader();
			imgLoader.loadImg(vecURL[id_loader]);
			imgLoader.addEventListener(Event.COMPLETE, imgLoaded);
		}
		
		private function disposeLoading():void{
			removeChild(loadTf);
		}
		
		private function imgLoaded(e:Event):void{
			TweenMax.to(loadTf, .2, {alpha:0, overwrite:true, onComplete:disposeLoading});
			imgContainer.addChild(imgLoader.bm);
			imgContainer.alpha = 0;
			TweenMax.to(imgContainer, .2, {alpha:1, overwrite:true});
			imgContainer.addEventListener(MouseEvent.CLICK, carrousel);
			imgContainer.buttonMode = true;
		}
		
		private function carrousel(e:MouseEvent):void{
			if (id_loader < vecText.length){
				id_loader = id_loader + 1;
				buttonStyle();
				TweenMax.to(imgContainer, .2, {alpha:0, overwrite:true, onComplete:callNew});
			}
		}
		
		private function callNew():void{
			if(vecType[id_loader] === "photo"){
				imageLoader();
			}
			if(vecType[id_loader] === "video"){
				videoLoader();
			}
		}
		
		private function disposeImg():void{
			if(getChildByName("imgContainer")){
				imgContainer.removeChildAt(0);
			}
			callNewImage();
		}
		
		/**
		 * Video Loader
		 */
		
		private function videoLoader():void{
			if(current_id != id_loader){
				/*if(VideoLoader.ns){
					VideoLoader.ns.close();
					VideoLoader.ns.togglePause();
	        		VideoLoader.ns.pause();
	        		VideoLoader.ns.close();
	        		VideoLoader.ns.client = {};
	        		VideoLoader.nc.close();
				}*/
				if (vidLoader) {
					vidLoader.dispose();
				}
				
				
				
				
				//if(imgLoader){
					//TweenMax.to(imgContainer, .2, {alpha:0, onComplete:disposeVid});
				//} else {
				callNewVideo();
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyboardView);
				//}
			}
			
			current_id = id_loader;
		}
		
	

		private var _backgroundEffect:Sprite;
		private var pattern:Shape;
		private var bmd:BitmapData;
		private var _bkgShape:Sprite;
		private var close:MCAnimation;
		
		private function callNewVideo():void{
			/*if(VideoLoader.ns){
				VideoLoader.ns.close();
			}*/
			if (vidLoader) {
				vidLoader.dispose();
				
			}
			pattern = new Shape();
			pattern.graphics.beginFill(0x4c4c4c, 1);
			pattern.graphics.drawRect(0, 0, 2, 2);
			pattern.graphics.endFill();
			
			pattern.graphics.beginFill(0x000000, 1);
			pattern.graphics.drawRect(2, 2, 2, 2);
			pattern.graphics.endFill();
			
			
			bmd = new BitmapData(4, 4);
			bmd.draw(pattern);
			
			pattern = null;
			
			_backgroundEffect = new Sprite();
			_backgroundEffect.graphics.beginBitmapFill(bmd);
			_backgroundEffect.graphics.drawRect(0, 0, 4000, 4000);
			_backgroundEffect.graphics.endFill();
			
			bmd = null;

			_backgroundEffect.blendMode = BlendMode.DARKEN;
			_backgroundEffect.name = "_backgroundEffect";
			
			stage.addChild(_backgroundEffect);
			
			
			
			_bkgShape = new Sprite();
			_bkgShape.graphics.beginFill(0x000000, .8);
			_bkgShape.graphics.drawRect(0, 0, 810, 500);
			_bkgShape.graphics.endFill();
			_bkgShape.x = stage.stageWidth/2 - _bkgShape.width/2;
			_bkgShape.y = stage.stageHeight/2 - _bkgShape.height/2;
			
			stage.addChild(_bkgShape);
			_bkgShape.name = "_bkgShape";
			_bkgShape.alpha = 0;
			stage.addEventListener(Event.RESIZE, resizeVideo);
			TweenMax.to(_bkgShape, .3, {alpha:1, overwrite:true});
			
			
			
			vidLoader = new VideoLoader();
			
			vidLoader.loadVid(vecURL[id_loader], 790, 442);
			
			vidLoaded();
			
			id_loader = id_loader - 1;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardView);
		}
		
		private function openVideo(e:Event):void{
			bottomBar = new Sprite();
			bottomBar.graphics.beginFill(0x000000, .4);
			bottomBar.graphics.drawRect(10, _bkgShape.height - 50, 790, 40);
			bottomBar.graphics.endFill();
			_bkgShape.addChild(bottomBar);
			bottomBar.alpha = 0;
			bottomBar.mouseChildren = false;
			bottomBar.mouseEnabled = false;
			TweenMax.to(bottomBar, .4, {alpha:1, delay:.4, overwrite:true});
			TweenMax.to(play_btn._currentObj, .4, {alpha:0});
			TweenMax.to(close._currentObj, .4, {alpha:0});
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardView);
			stateVid = true;
		}
		
		private function resizeVideo(e:Event = null):void{
			if(stage.getChildByName("_bkgShape")){
				_bkgShape.x = stage.stageWidth/2 - _bkgShape.width/2;
				_bkgShape.y = stage.stageHeight/2 - _bkgShape.height/2;
			}
			
			if(stage.getChildByName("fsScreen")){
				if(stage.getChildByName("_bkgShape")){
					fscreen._currentObj.x = stage.stageWidth/2 - _bkgShape.width/2 + _bkgShape.width - 50;
					fscreen._currentObj.y = stage.stageHeight/2 - _bkgShape.height/2 + _bkgShape.height - 45;
				}
			}
			
		}
		private var shadow:MCAnimation;
		private var play_btn:MCAnimation;
		private var pause_btn:MCAnimation;
		private var fscreen:MCAnimation;
		private var bottomBar:Sprite;
		
		private function vidLoaded():void{
			
			_bkgShape.addChild(vidLoader.video);
			vidLoader.addEventListener(Event.INIT, openVideo);
			imgContainer.alpha = 1;
			
			vidLoader.video.x = 10;
			vidLoader.video.y = 10;
			
			vidLoader.mouseChildren = false;
			vidLoader.mouseEnabled = false;
			
			shadow = new MCAnimation();
			shadow.getMCName(Globals.arrAssets[1]);
			_bkgShape.addChild(DisplayObject(shadow._currentObj));
			shadow._currentObj.blendMode = BlendMode.OVERLAY;
			shadow._currentObj.x = 10;
			shadow._currentObj.y = 10;
			shadow._currentObj.mouseChildren = false;
			shadow._currentObj.mouseEnabled = false;
			close = new MCAnimation();
			close.getMCName(Globals.arrAssets[2]);
			
			close._currentObj.x = _bkgShape.width - close._currentObj.width - 15;
			close._currentObj.y = 15;
			
			close._currentObj.addEventListener(MouseEvent.CLICK, disposeVid);
			close._currentObj.buttonMode = true;
			close._currentObj.alpha = 1;
			_bkgShape.addChild(DisplayObject(close._currentObj));
			
			fscreen = new MCAnimation();
			fscreen.getMCName(Globals.arrAssets[5]);
			
			fscreen._currentObj.x = stage.stageWidth/2 - _bkgShape.width/2 + _bkgShape.width - 50;
			fscreen._currentObj.y = stage.stageHeight/2 - _bkgShape.height/2 + _bkgShape.height - 45;
			
			fscreen._currentObj.addEventListener(MouseEvent.CLICK, fullscreenVid);
			fscreen._currentObj.buttonMode = true;
			fscreen._currentObj.alpha = 1;
			fscreen._currentObj.name = "fsScreen";
			stage.addChild(DisplayObject(fscreen._currentObj));
			
			
			play_btn = new MCAnimation();
			play_btn.getMCName(Globals.arrAssets[3]);

			play_btn._currentObj.x = _bkgShape.width / 2 - play_btn._currentObj.width / 2;
			play_btn._currentObj.y = _bkgShape.height / 2 - play_btn._currentObj.height / 2;
			
			pause_btn = new MCAnimation();
			pause_btn.getMCName(Globals.arrAssets[4]);

			pause_btn._currentObj.x = _bkgShape.width / 2 - pause_btn._currentObj.width / 2;
			pause_btn._currentObj.y = _bkgShape.height / 2 - pause_btn._currentObj.height / 2;
			
			_bkgShape.addChild(DisplayObject(play_btn._currentObj));
			_bkgShape.addChild(DisplayObject(pause_btn._currentObj));
			
			play_btn._currentObj.alpha = 1;
			pause_btn._currentObj.alpha = 0;
			
			
			_bkgShape.addEventListener(MouseEvent.MOUSE_OVER, statePauseStopOver);
			_bkgShape.addEventListener(MouseEvent.ROLL_OUT, statePauseStopOut);
			_bkgShape.addEventListener(MouseEvent.CLICK, statePauseStop);
			_bkgShape.buttonMode = true;
			
			
			
			
			
			resizeVideo();
		}
		
		
		
		public function fullScrHandler(event:FullScreenEvent):void {
			
		       if (stage.displayState == StageDisplayState.FULL_SCREEN) {
				 //stage.displayState = StageDisplayState.FULL_SCREEN;
		        
				_bkgShape.x = 0;
		        _bkgShape.y = 0;
		        _bkgShape.width = stage.stageWidth;
				_bkgShape.height = stage.stageHeight;
				_bkgShape.removeEventListener(MouseEvent.ROLL_OUT, statePauseStopOut);
				_bkgShape.removeEventListener(MouseEvent.MOUSE_OVER, statePauseStopOver);
		        TweenMax.to(pause_btn._currentObj, .4, {alpha:0, delay:.4, overwrite:true});
				TweenMax.to(play_btn._currentObj, .4, {alpha:0, delay:.4, overwrite:true});
				TweenMax.to(close._currentObj, .4, {alpha:0, delay:.4, overwrite:true});
				
				fscreen._currentObj.x = stage.stageWidth - 80;
				fscreen._currentObj.y = stage.stageHeight - 75;
				stage.removeEventListener(FullScreenEvent.FULL_SCREEN, fullScrHandler);
			} else {
				_bkgShape.addEventListener(MouseEvent.ROLL_OUT, statePauseStopOut);
    			_bkgShape.addEventListener(MouseEvent.MOUSE_OVER, statePauseStopOver);
        		stage.displayState = StageDisplayState.NORMAL;
        		
        		
        		
		        _bkgShape.width = 810;
		        _bkgShape.height = 500;
		        _bkgShape.x = stage.stageWidth / 2 - _bkgShape.width / 2;
		        _bkgShape.y = stage.stageHeight / 2 - _bkgShape.height / 2;
		        
		        fscreen._currentObj.x = stage.stageWidth/2 - _bkgShape.width/2 + _bkgShape.width - 50;
				fscreen._currentObj.y = stage.stageHeight/2 - _bkgShape.height/2 + _bkgShape.height - 45;
				stage.removeEventListener(FullScreenEvent.FULL_SCREEN, fullScrHandler);
			}
		}
		
		/**
		 * fullscreen vid	
		 */
		 
		private function fullscreenVid(e:MouseEvent):void{
			if (stage.displayState == StageDisplayState.NORMAL) {
		        stage.displayState = StageDisplayState.FULL_SCREEN;
		        
				_bkgShape.x = 0;
		        _bkgShape.y = 0;
		        _bkgShape.width = stage.stageWidth;
				_bkgShape.height = stage.stageHeight;
				_bkgShape.removeEventListener(MouseEvent.ROLL_OUT, statePauseStopOut);
				_bkgShape.removeEventListener(MouseEvent.MOUSE_OVER, statePauseStopOver);
		        TweenMax.to(pause_btn._currentObj, .4, {alpha:0, delay:.4, overwrite:true});
				TweenMax.to(play_btn._currentObj, .4, {alpha:0, delay:.4, overwrite:true});
				TweenMax.to(close._currentObj, .4, {alpha:0, delay:.4, overwrite:true});
				
				fscreen._currentObj.x = stage.stageWidth - 80;
				fscreen._currentObj.y = stage.stageHeight - 75;
		        stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullScrHandler);
    		} else {
    			_bkgShape.addEventListener(MouseEvent.ROLL_OUT, statePauseStopOut);
    			_bkgShape.addEventListener(MouseEvent.MOUSE_OVER, statePauseStopOver);
        		stage.displayState = StageDisplayState.NORMAL;
        		
        		
        		
		        _bkgShape.width = 810;
		        _bkgShape.height = 500;
		        _bkgShape.x = stage.stageWidth / 2 - _bkgShape.width / 2;
		        _bkgShape.y = stage.stageHeight / 2 - _bkgShape.height / 2;
		        
		        fscreen._currentObj.x = stage.stageWidth/2 - _bkgShape.width/2 + _bkgShape.width - 50;
				fscreen._currentObj.y = stage.stageHeight/2 - _bkgShape.height/2 + _bkgShape.height - 45;
				stage.removeEventListener(FullScreenEvent.FULL_SCREEN, fullScrHandler);
		    }	
		}
		
		private var stateVid:Boolean = false;
		
		private function statePauseStop(e:MouseEvent = null):void{
			if(stateVid == true){
				TweenMax.to(pause_btn._currentObj, .4, {alpha:0});
				TweenMax.to(play_btn._currentObj, .4, {alpha:1});
				vidLoader.ns.pause();
				stateVid = false;
			} else {
				TweenMax.to(play_btn._currentObj, .4, {alpha:0});
				TweenMax.to(pause_btn._currentObj, .4, {alpha:1});
				vidLoader.ns.resume();
				stateVid = true;
			}
			
			
		}
		
		private function statePauseStopOver(e:MouseEvent = null):void{
			TweenMax.to(close._currentObj, .4, {alpha:1});
			if(stateVid){
				TweenMax.to(pause_btn._currentObj, .4, {alpha:1});
				TweenMax.to(play_btn._currentObj, .4, {alpha:0});
			} else {
				TweenMax.to(play_btn._currentObj, .4, {alpha:1});
				TweenMax.to(pause_btn._currentObj, .4, {alpha:0});
			}
		}
		private function statePauseStopOut(e:MouseEvent):void{
			TweenMax.to(close._currentObj, .4, {alpha:0});
			TweenMax.to(play_btn._currentObj, .4, {alpha:0});
			TweenMax.to(pause_btn._currentObj, .4, {alpha:0});
		}
		
		private function disposeVid(e:MouseEvent = null):void{
			/*if(VideoLoader.ns){
				VideoLoader.ns.close();
				
			}*/
			if (vidLoader) {
				vidLoader.dispose();
			}
			
			/*for(;imgContainer.numChildren;){
				imgContainer.removeChildAt(0); 
			}*/
			if(stage.getChildByName("_bkgShape")){
				stage.removeChild(_bkgShape);
			}
			
			if(stage.getChildByName("_backgroundEffect")){
				stage.removeChild(_backgroundEffect);
			}
			if(stage.getChildByName("fsScreen")){
				stage.removeChild(DisplayObject(fscreen._currentObj));
			}
			
			stage.removeEventListener(Event.RESIZE, resizeVideo);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardView);
		
			//callNewVideo();
		}
		
	}
}
