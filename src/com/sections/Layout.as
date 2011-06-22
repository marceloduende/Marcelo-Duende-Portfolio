package com.sections {
	import com.Globals;
	import com.asual.swfaddress.SWFAddress;
	import com.core.Modules;
	import com.greensock.TweenMax;
	import com.utils.MCAnimation;
	import com.utils.TextFactory;
	import com.utils.XmlListDispatcher;
	import com.zoo.Aligner;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;

	/**
	 * @author Marcelo
	 */
	public class Layout extends Modules {
		
		public var content:MovieClip;
		public var contentElements:MovieClip;
		
		public var menu:MovieClip;
		public var menuBottom:MovieClip;
		public var _logo : MCAnimation;
		private var arrMenu:Array = ["About","Work"];
		private var transparentSquare:Sprite;
		private var externalLinks:Array = new Array();
		
		//private var parseMenu:XmlParser;
		
		
		public function Layout() {
			super();
			init();
		}
		public function init():void{
			/**
			 * adding container mc
			 */
			content = new MovieClip();
			contentElements = new MovieClip();
		
			Globals.stageReference.addChild(content);
			Globals.stageReference.addChild(contentElements);

			
			content.name = "_content";
			contentElements.name = "_contentElements";
			
		

			
			/**
			 * creating backside square to set the middle
			 */
			transparentSquare = new Sprite();
			transparentSquare.graphics.beginFill(0x000000, 0);
			transparentSquare.graphics.drawRect(0, 0, 1256, 803);
			transparentSquare.graphics.endFill();
			content.addChild(transparentSquare);
			
			
			
			/**
			 * adding asset logo_md
			 */
			_logo = new MCAnimation();
			_logo.getMCName(Globals.arrAssets[0], true);
			content.addChild(DisplayObject(_logo._currentObj));

			_logo._currentObj.addEventListener(MouseEvent.CLICK, backHome);
			_logo._currentObj.buttonMode = true;
			
			
			/**
			 * centering with Aligner class
			 */
			Aligner.add(content, {align:Aligner.CENTER});
			
			/**
			 * Menu
			 */
			
			menu = new MovieClip();
			menuBottom = new MovieClip();
			content.addChild(menu);
			content.addChild(menuBottom);
			menu.x = 1040;
			menu.y = 40;
			menu.name = "menu";
			
			menuBottom.x = 700;
			menuBottom.y = transparentSquare.height - 20;
			
			var lastWidth:Number;
			var lastX:Number;
			var params:Object;
			for(var  i:int = 0; i < arrMenu.length; i++){
				var textMenu : XMLList = XmlListDispatcher.getXmlList(Globals.confContent, "name", arrMenu[i]);
				var tfac:MovieClip = TextFactory.addButton(textMenu.menu.toString(), textMenu.menu.@cssClass);
				menu.addChild(tfac);
				params = [ Globals.confContent.child("sections").child("section")[i+1].@name.toString(), Globals.confContent.child("sections").child("section")[i+1].@packagePath.toString()];
				tfac["index"] = params;
				
				tfac.addEventListener(MouseEvent.CLICK, openPage); // call modules to open the right page
				tfac.x = (lastX + lastWidth + 20);
				lastX = tfac.x;
				lastWidth = tfac.width;
				tfac.alpha = 0;
				TweenMax.to(tfac, .5, {alpha:1, delay:1.6 + (i/6)});
			}
			
			/**
			 * adding rodape copy
			 */

			var copyBottom : String = Globals.confContent.child("bottomCopy").@copy;
			var addBottomText:TextField = TextFactory.addText(copyBottom, Globals.confContent.child("bottomCopy").@cssClass);
			content.addChild(addBottomText);
			addBottomText.y = transparentSquare.height - addBottomText.textHeight;
			addBottomText.alpha = 0;
			TweenMax.to(addBottomText, .5, {alpha:1, delay:2.5});
			
			
			/**
			 * adding bottom links
			 */
			
			for(i = 0; i < Globals.confContent.child("bottomLinks").child("link").length(); i++){
				trace(i + " menu bottom")
				var menuLink : MovieClip = TextFactory.addButton(Globals.confContent.child("bottomLinks").child("link")[i].@name, Globals.confContent.child("bottomLinks").child("link")[i].@cssClass);
				menuBottom.addChild(menuLink);
				menuLink.addEventListener(MouseEvent.CLICK, gotoURL);
				menuLink["index"] = i;
				externalLinks.push(Globals.confContent.child("bottomLinks").child("link")[i].@link);
				menuLink.x = (lastX + lastWidth);
				lastX = menuLink.x;
				lastWidth = menuLink.width;
				menuLink.alpha = 0;
				TweenMax.to(menuLink, .5, {alpha:1, delay:2.7 + (i/6)});
			}	
			resize()
			Globals.stageReference.stage.addEventListener(Event.RESIZE, resize)
		}
		
		private function backHome(e:MouseEvent):void{
			Globals.simpleAddressID = "home";
			Globals.addressID = "";
			parseURL(Globals.simpleAddressID, "com.sections");
		}
		private function gotoURL(e:MouseEvent):void{
			navigateToURL(new URLRequest(externalLinks[e.currentTarget.index]), "_blank");
		}
		
		private function resize(e:Event = null):void{
			content.y = Globals.stageReference.stage.stageHeight/2 - content.height/2;
			
			if(content.y < 0){
				content.y = 0;
			}
			contentElements.y = content.y;
			contentElements.x = content.x;
		}
		
	}
}
