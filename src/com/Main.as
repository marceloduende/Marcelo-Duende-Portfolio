package com {
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.core.Modules;
	import com.sections.Layout;

	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * @author Marcelo
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="1256", height="803")] 
	public class Main extends Modules {
		
		public var _layout:Layout;
		
		public function Main() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		private function addedToStage(e:Event = null):void{
			if(stage){
				removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
				initMain();
			} else {
				addedToStage();
			}
		}
		
		private function initMain() : void {
			Globals.addressID = "";
			Globals.stageReference = stage;
			/**
			 * init layout
			 */
			_layout = new Layout();
			_layout.name = "_layout";
			stage.addChild(_layout);
			
			
			/**
			 * detecting address
			 */
			SWFAddress.addEventListener(SWFAddressEvent.INIT, startApp);
			// SWFAddress.addEventListener(SWFAddressEvent.INTERNAL_CHANGE, handleSWFAddress);
			SWFAddress.addEventListener(SWFAddressEvent.EXTERNAL_CHANGE, handleSWFAddress);
			
		}
		
		/**
		 * SWF Address handling 
		 */
		
		
		public function handleSWFAddress(e:SWFAddressEvent):void{
			//trace(e.target)
			var title:String = 'Marcelo Duende - Creative Flash Developer';	
			for (var i:int = 0; i < e.pathNames.length; i++) {
				title += ' / ' + e.pathNames[i].substr(0,1).toUpperCase() + e.pathNames[i].substr(1);
				 
			}
			Globals.addressID = e.pathNames[e.pathNames.length-1];
			Globals.simpleAddressID = e.pathNames[0];
			
			if(Globals.addressID == Globals.simpleAddressID){
				Globals.addressID = "";
			}
			
			trace(title + "  titles")
			
			 
			SWFAddress.setTitle(title);
			var url:String = e.path;
			url = url.split("/").join("");
			
			if(e.path == "" || e.path == "/"){
				SWFAddress.setValue("home");
				Globals.simpleAddressID = "home";
				
			} 
			parseURL(Globals.simpleAddressID, "com.sections");
			
			
		}
		public function startApp(e:SWFAddressEvent):void{
			var url:String = e.path;	
			url = url.split("/").join("");
			
			if(e.path == "" || e.path == "/"){
				SWFAddress.setValue("home");
				Globals.simpleAddressID = "home";
			} 
			parseURL(Globals.simpleAddressID, "com.sections");
			trace(Globals.simpleAddressID + "  url")
			//parseURL(url, "com.sections");
		}
	}
}
