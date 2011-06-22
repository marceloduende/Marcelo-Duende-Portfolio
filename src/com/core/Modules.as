package com.core {
	import com.Globals;
	import com.asual.swfaddress.SWFAddress;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;

	/**
	 * @author Marcelo
	 */
	public class Modules extends MovieClip {
		public var pageID:String;
		private var _pageID:String;
		private var _packageID:String;
		public var callErrorPage:Boolean = false;
		
		public var preloader:MovieClip;
		
		public var speed:Number = .4;
		public var statePreloader:Boolean = true;
		private var sp:Sprite;
		private var spBkg:Sprite;
		
		/**
		 * handle with all application to open the right page integrate with SWFAddress
		 */
		 
		public function openPage(e:MouseEvent):void{
			Globals.addressID = "";
			_pageID = e.currentTarget.index[0];
			_packageID = e.currentTarget.index[1];
			parseURL(_pageID, _packageID);
			dispose();
		}
		private var tempMc:MovieClip;
		private var _pageName:String;
		private var pageInstance:DisplayObject;
		public function parseURL(pageName:String, packageName:String):void{
			
			blockMenu();
			
			
			
			//morphing the lowercase to uppercase
			var tmp:String = pageName;
			_pageName = pageName;
			tmp = tmp.substr(0, 1).toUpperCase();
			pageName = pageName.substr(1, pageName.length);
			pageName = tmp + pageName;
			callErrorPage = false;
			
			// checking for error page
			var i : int = 0;
			while ( i < Globals.confContent.child("sections").child("section").length()){
				if(pageName == Globals.confContent.child("sections").child("section")[i].@name){
					callErrorPage = true;
				}
				i++;
			}
			
			if(!callErrorPage){
				pageName = "ErrorPage";
			}
			
			
			
			
			var includeClasses:IncludeClasses; // pre set classes
			//var pageInstance:DisplayObject;
			var tempClass : Class = getDefinitionByName(packageName + "." + pageName) as Class;	
  			
  			for(;MovieClip(Globals.stageReference.stage.getChildByName("_contentElements")).numChildren;){
  				MovieClip(Globals.stageReference.stage.getChildByName("_contentElements")).removeChildAt(0);
  			}
  			
  			
  			pageInstance = new tempClass();
  			//pageInstance.init();
  			tempMc = new MovieClip();
  			tempMc.name = "tempMc";
  			tempMc = Globals.stageReference.stage.getChildByName("_contentElements") as MovieClip;
			
			for(;tempMc.numChildren;){
  				tempMc.removeChildAt(0);
  			}
  			tempMc.addChild(pageInstance);
			pageInstance.y = 150;
			// pageInstance.name = "pageInstance";
			
			_pageName = _pageName.toLowerCase();

			if (Globals.addressID == ""){
				SWFAddress.setValue(_pageName);
			} else {
				SWFAddress.setValue(_pageName + "/" + Globals.addressID);
			}
			
			//trace(SWFAddress.getValue());
			
		}
		
		
		/**
		 * block and release menu
		 */
		private var tempChild:MovieClip;
		private var temp:MovieClip;
		public function blockMenu():void{
			temp = Globals.stageReference.stage.getChildByName("_content") as MovieClip;
			tempChild = temp.getChildByName("menu") as MovieClip;
			
			
			tempChild.mouseChildren = false;
			tempChild.mouseEnabled = false;
			
		}
		public function releaseMenu():void{
			trace("released")
			temp = Globals.stageReference.stage.getChildByName("_content") as MovieClip;
			tempChild = temp.getChildByName("menu") as MovieClip;
			tempChild.mouseChildren = true;
			tempChild.mouseEnabled = true;
		}
		
		/**
		 * @param percentage receive percent value from loader
		 */
		public function handleProgress(percentage:Number):void{
			//trace(percentage/100)
			
			if(statePreloader){
				preloader = new MovieClip();
				addChild(preloader);
				preloader.x = 470;
				preloader.y = 220;
				preloader.alpha = 0;
				sp = new Sprite();
				sp.graphics.beginFill(0x000000);
				sp.graphics.drawRect(0, 0, 300, 1);
				sp.graphics.endFill();
				spBkg = new Sprite();
				spBkg.graphics.beginFill(0xdd0101);
				spBkg.graphics.drawRect(0, 0, 300, 1);
				spBkg.graphics.endFill();
				
				preloader.addChild(spBkg);
				preloader.addChild(sp);
				
				TweenMax.to(preloader, speed, {alpha:1, y:200,  ease:Quint.easeOut});
				
				statePreloader = false;
				
			}
			
			sp.scaleX = percentage/100;
			
			
			if(percentage == 100){
				TweenMax.to(preloader, speed, {alpha:0, y:180, onComplete:dispose,  ease:Quint.easeOut});
				statePreloader = true;
			}
		}
		
		public function dispose():void{
			if(preloader){
				preloader.removeChild(sp);
				preloader.removeChild(spBkg);
				removeChild(preloader);
			}
			
			
			
			
			/*if(VideoLoader.ns){
				VideoLoader.ns.close();
			}*/
			
		}
		
		
		
		
	}
}
