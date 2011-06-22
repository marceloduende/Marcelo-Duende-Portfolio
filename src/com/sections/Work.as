package com.sections {
	import com.Globals;
	import com.asual.swfaddress.SWFAddress;
	import com.core.Modules;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	import com.utils.TextFactory;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author Marcelo
	 */
	public class Work extends Modules {
		
		public const ID:String = "work"; // setting ID to get in SWFAddresManager
		
		private var queueWorkXML:LoaderMax;
		private var xml:XML;
		private var thumbnailImageContent:MovieClip;
		private var thumbnailImageColoredContent:MovieClip;
		private var arrThumbs:Vector.<MovieClip> = new Vector.<MovieClip>();
		private var arrColoredThumbs:Vector.<MovieClip> = new Vector.<MovieClip>();
		
		private var counterY:Number = 0;
		private var counterX:Number = 0;
		private var counter:Number = 0;
		private var controler:int = 0;
		private var _delay:Number = 0;
		
		private var sp:Sprite;
		private var spMask:Sprite;
		private var tfMask:Sprite;
		private var tfMask2:Sprite;
		
		public function Work() {
			super();
			pageID = ID;
			
			init();
			
		}
		/** 
		 * loading XML and Images
		 */
		private var tf:TextField;
		private var thumbBkg:Sprite;
		private var fakeloaders:MovieClip;
		public function init():void{
			handleProgress(Number(0));
			
			
			LoaderMax.activate([XMLLoader,ImageLoader]);
			queueWorkXML = new LoaderMax({name:"work"});
			queueWorkXML.append(new XMLLoader(Globals.confContent.child("sections").child("section")[2].@xmlURL, {name:"workXML", onComplete:onXMLComplete}));
			queueWorkXML.load();
			
			
		}
		
		private function onXMLComplete(e:LoaderEvent):void{
			xml = new XML(LoaderMax.getContent("workXML"));
			
			
			var queueWork : LoaderMax = new LoaderMax({name:"imgWork", onComplete:handleComplete, onProgress:_onProgress});
			queueWork.skipFailed = true;
			queueWork.skipPaused = true;
			
			for(var i:int = 0; i<xml.child("register").length(); i++){
				queueWork.append(new ImageLoader(xml.child("register")[i].child("sephia").toString(), {name:"s_"+i, parameters:[i], alpha:1}));
				queueWork.append(new ImageLoader(xml.child("register")[i].child("colored").toString(), {name:"c_"+i, parameters:[i], alpha:1}));
				
			}
			queueWork.load();
		}
		
		private function _onProgress(e:LoaderEvent):void{
			handleProgress(Number(e.target.progress * 100));
		}
		
		
		private var arrHREF:Vector.<String> = new Vector.<String>();
		private var spLayer:Sprite;
		
		private function handleComplete(e:LoaderEvent):void{
			
			
		
			/**
			 * adding inner content
			 */
			
			spLayer = new Sprite();
			spLayer.graphics.beginFill(0x000000, 0);
			spLayer.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			spLayer.graphics.endFill();
			
			stage.addChild(spLayer);
				
			for(var i:int = 0; i<xml.child("register").length(); i++){
				
				arrHREF.push(xml.child("register")[i].@href);
				
				
				thumbnailImageContent = new MovieClip();
				addChild(thumbnailImageContent);
				thumbnailImageContent.name = "thumbnailImageContent";
				thumbnailImageContent.addChild(LoaderMax.getContent("s_"+i));
				arrThumbs.push(thumbnailImageContent);
				if(counter > 4){
					counterX = 0;
					counter = 0;
					counterY += 145;
				}
				counterX = counter * 250;
				thumbnailImageContent.x = counterX;
				thumbnailImageContent.y = counterY + 100;
				
				thumbnailImageContent.alpha = 0;
				thumbnailImageContent.rotationX = 50;
				if (!Globals.addressID == ""){
					thumbnailImageContent.alpha = 0;
					thumbnailImageContent.y = counterY;
					thumbnailImageContent.rotationX = 0;
					//TweenMax.to(thumbnailImageContent, 0, {alpha:0 ,y:counterY, rotationX:0});
				} else {
					TweenMax.to(thumbnailImageContent, speed, {alpha:1, delay:_delay ,y:counterY, rotationX:0, ease:Quint.easeOut});
				}
				
				_delay += .1;
				thumbnailImageContent["index"] = i;
				thumbnailImageContent.addEventListener(MouseEvent.ROLL_OVER, over);
				thumbnailImageContent.buttonMode = true;
				

				// colored thumbnails

				thumbnailImageColoredContent = new MovieClip();
	
				sp = new Sprite();
				
				sp.graphics.beginFill(0x000000);
				sp.graphics.drawRoundRect(-6, -6, 254, 242, 10);
				sp.graphics.endFill();
				sp.name = "sp";
				
				spMask = new Sprite();
				spMask.graphics.beginFill(0x000000);
				spMask.graphics.drawRect(0, 0, 242, 136);
				spMask.graphics.endFill();
				
				tfMask = new Sprite();
				tfMask.graphics.beginFill(0xffffff);
				tfMask.graphics.drawRect(0, 0, 170, 90);
				tfMask.graphics.endFill();
				
				tfMask2 = new Sprite();
				tfMask2.graphics.beginFill(0xffffff);
				tfMask2.graphics.drawRect(0, 0, 170, 90);
				tfMask2.graphics.endFill();
				
				
				addChild(thumbnailImageColoredContent);
				thumbnailImageColoredContent.visible = false;
				thumbnailImageColoredContent.addChild(sp);
				thumbnailImageColoredContent.addChild(spMask);
				thumbnailImageColoredContent.addChild(tfMask);
				thumbnailImageColoredContent.addChild(tfMask2);
				thumbnailImageColoredContent.addChild(LoaderMax.getContent("c_"+i));
				LoaderMax.getContent("c_"+i).name = "image";
				LoaderMax.getContent("c_"+i).mask = spMask;
				
				
				
				
				tfMask.y = 145;
				tfMask.name = "tfMask";
				tfMask2.y = 145;
				tfMask2.name = "tfMask2";
				arrColoredThumbs.push(thumbnailImageColoredContent);
				
			
				counter++;
				controler++;
				
				// dispatch menu event
				
				if (controler >= xml.child("register").length()) {
					trace("Time to dispatch")
					releaseMenu();
				} 
				
				
			
				
			}
			
			TweenMax.to(spLayer, 0, {alpha:0, delay:_delay, onComplete:disposeBlocker});
			if (Globals.addressID != "") {
				slideShowSWFAddress(Globals.simpleAddressID + "/" + Globals.addressID);
			}
		}
		
		private function disposeBlocker():void{
			if(spLayer)
				stage.removeChild(spLayer);
				
			
		}
		
		
		private function errorHandler(e:LoaderEvent):void{
			
		}
		
		/**
		 * saving icon
		 */
		private var vecIcon:Vector.<MovieClip> = new Vector.<MovieClip>();
		private var icons:MovieClip;
		private function saveIcon(e:LoaderEvent):void{
			icons = new MovieClip();
			icons.addChild(LoaderMax.getContent(e.target.vars.name));
			vecIcon.push(icons);
		}
		
		
		/**
		 * create rollOver functions
		 */
		private var title:TextField;
		private var body:TextField;
		private function over(e : MouseEvent) : void {
			for (var i : int = 0; i < arrColoredThumbs.length; i++){
				
				//TweenMax.to(arrThumbs[i], .3, {alpha:.8});
				if(arrColoredThumbs[i].visible == true){
					//arrColoredThumbs[i].visible = false;
					if(arrColoredThumbs[i].getChildByName("title")){
						arrColoredThumbs[i].removeChild(arrColoredThumbs[i].getChildByName("title"));
					}
					if(arrColoredThumbs[i].getChildByName("body")){
						arrColoredThumbs[i].removeChild(arrColoredThumbs[i].getChildByName("body"));
					}
					TweenMax.to(arrColoredThumbs[i].getChildByName("image"), speed-.2, {y:250,ease:Quint.easeIn});
					TweenMax.to(arrColoredThumbs[i].getChildByName("sp"), speed-.2, {alpha:0, overwrite:true, y:-20, ease:Quint.easeIn, onComplete:visibleFalse, onCompleteParams:[i]});
				}
				arrColoredThumbs[temp].removeEventListener(MouseEvent.ROLL_OUT, out);
			}
			
			//arrColoredThumbs[e.currentTarget.index].addChild(vecIcon[0]);
			
			title = TextFactory.addText(xml.child("register")[e.currentTarget.index].child("title").toString(), xml.child("register")[e.currentTarget.index].child("title").@cssClass);
			arrColoredThumbs[e.currentTarget.index].addChild(title);
			title.y = 145;
			title.x = -170;
			title.name = "title";
			
			body = TextFactory.addText(xml.child("register")[e.currentTarget.index].child("client").toString() + "<br/>" + xml.child("register")[e.currentTarget.index].child("agency").toString(),   xml.child("register")[e.currentTarget.index].child("client").@cssClass, 165,50, false);
			arrColoredThumbs[e.currentTarget.index].addChild(body);
			body.y = 190;
			body.x = -170;
			body.name = "body";
			arrColoredThumbs[e.currentTarget.index]["index"] = e.currentTarget.index;
			arrColoredThumbs[e.currentTarget.index].getChildByName("tfMask").mask = title;
			arrColoredThumbs[e.currentTarget.index].getChildByName("tfMask2").mask = body;
			
			arrColoredThumbs[e.currentTarget.index].getChildByName("sp").y = -20;
			arrColoredThumbs[e.currentTarget.index].getChildByName("image").y = 250;
			arrColoredThumbs[e.currentTarget.index].getChildByName("sp").alpha = 0;
			arrColoredThumbs[e.currentTarget.index].x = e.currentTarget.x;
			arrColoredThumbs[e.currentTarget.index].y = e.currentTarget.y;
			arrColoredThumbs[e.currentTarget.index].visible = true;
			setChildIndex(arrColoredThumbs[e.currentTarget.index], numChildren-1);
			
			
			
			
			arrColoredThumbs[e.currentTarget.index].buttonMode = true;
			TweenMax.to(arrColoredThumbs[e.currentTarget.index].getChildByName("image"), speed-.2, {y:0});
			TweenMax.to(arrColoredThumbs[e.currentTarget.index].getChildByName("sp"), speed, {alpha:1, y:0, overwrite:true, ease:Quint.easeOut});
			TweenMax.to(title, speed, {x:0, delay:speed-.3, overwrite:true, ease:Quint.easeOut});
			TweenMax.to(body, speed, {x:0, delay:speed-.2, overwrite:true, ease:Quint.easeOut});
			temp = e.currentTarget.index;
			arrColoredThumbs[e.currentTarget.index].addEventListener(MouseEvent.ROLL_OUT, out);
			arrColoredThumbs[e.currentTarget.index].addEventListener(MouseEvent.CLICK, slideShow);
			
		}
		private var temp:int;
		private function out(e:MouseEvent):void{
			for (var i : int = 0; i < arrColoredThumbs.length; i++){
				//arrThumbs[i].alpha = 1;
				//TweenMax.to(arrThumbs[i], .3, {alpha:1});
			}
			arrColoredThumbs[temp].removeChild(title);
			arrColoredThumbs[temp].removeChild(body);
			arrColoredThumbs[temp].removeEventListener(MouseEvent.ROLL_OUT, out);						
			TweenMax.to(arrColoredThumbs[temp].getChildByName("image"), speed-.2, {y:250,ease:Quint.easeIn});
			TweenMax.to(arrColoredThumbs[temp].getChildByName("sp"), speed-.2, {alpha:0, overwrite:true, y:-20, ease:Quint.easeIn, onComplete:visibleFalse, onCompleteParams:[temp]});
		}
		private function visibleFalse(_temp:int):void{
			arrColoredThumbs[_temp].visible = false;
			
		}
		
		/**
		 * inner part of work
		 */
		
		public var innerContainer:MovieClip;
		public var innerPage:InnerWork;
		private var tfac:MovieClip;
		public function slideShow(e:MouseEvent):void{
			innerContainer = new MovieClip();
			addChild(innerContainer);
			innerContainer.name = "innerContainer";
			tfac = TextFactory.addButton("[x] Back", "back_button");
			tfac.y = -20;
			clearBackground();
			
			
			
			// trace(arrHREF[e.currentTarget.index] + " ID DA PAGINA");
			if (Globals.addressID != ""){
				SWFAddress.setValue(arrHREF[e.currentTarget.index]);
			} else {
				SWFAddress.setValue(arrHREF[e.currentTarget.index] + "/" + Globals.addressID);
			}
			innerPage = new InnerWork();
			innerPage.init(arrHREF[e.currentTarget.index].toString());
			innerContainer.addChild(innerPage);
			innerContainer.addChild(tfac);
			tfac.addEventListener(MouseEvent.CLICK, drawBackground);
		}
		
		public function slideShowSWFAddress($id:String):void{
			
			if (Globals.addressID != ""){
				SWFAddress.setValue($id);
			} else {
				SWFAddress.setValue($id + "/" + Globals.addressID);
			}
			
			innerContainer = new MovieClip();
			addChild(innerContainer);
			innerContainer.name = "innerContainer";
			tfac = TextFactory.addButton("[x] Back", "back_button");
			tfac.y = -20;
			clearBackground();
			
			//trace(arrHREF[$id] + " ID DA PAGINA");
			/*var tf:TextField = new TextField();
			tf.width =1000;
			tf.text = $id + " trying to get into work";
			addChild(tf);*/ 
			innerPage = new InnerWork();
			innerPage.init($id);
			innerContainer.addChild(innerPage);
			innerContainer.addChild(tfac);
			tfac.addEventListener(MouseEvent.CLICK, drawBackground);
			
			/*tf.text = $id + " pass the action";
			tf.y = -40;
			addChild(tf);*/ 
		}
		
		/**
		 * enable/disable work main pge
		 */
		
		private function clearBackground():void{
			for (var i : int = 0; i < arrColoredThumbs.length; i++){
				TweenMax.to(arrThumbs[i], .3, {alpha:0, onComplete:disableBackground, onCompleteParams:[i]});
				TweenMax.to(arrColoredThumbs[i], .3, {alpha:0});
			}
		}
		private function disableBackground(i:int):void{
			arrThumbs[i].visible = false;
			arrColoredThumbs[i].visible = false;
		}
		
		private function drawBackground(e:MouseEvent):void{
			_delay = 0;
			SWFAddress.setValue("work");
			Globals.addressID = "";
			
			for (var i : int = 0; i < arrColoredThumbs.length; i++){
				arrThumbs[i].visible = true;
				arrColoredThumbs[i].visible = false;
				TweenMax.to(arrThumbs[i], .3, {alpha:1});
				arrColoredThumbs[i].alpha = 1;
			}
			
			

			if (innerPage.vidLoader){
				innerPage.vidLoader.ns.close();
			}
			
			for(;innerContainer.numChildren;){
				innerContainer.removeChildAt(0);
			}
			
			removeChild(innerContainer);
			
		/*	if(VideoLoader.ns){
				VideoLoader.ns.close();
			}*/
		}
		
		public function disposeVideo():void{
			if (innerPage.vidLoader.ns){
				innerPage.vidLoader.ns.close();
			}
		}
		
		
	}
}
