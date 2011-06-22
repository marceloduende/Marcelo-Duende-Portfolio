package com {
	import flash.display.Stage;
	import flash.text.StyleSheet;
	/**
	 * @author Marcelo
	 */
	public class Globals {
		static public var confURL:String;
		static public var confContent:XML; // XML CONTENT
		static public var initAssetsURL:String;
		static public var assetsURL:String;
		static public var fontsURL:String;
		static public var cssURL:String;
		static public var css:StyleSheet; // CSS CONTENT
		static public var mainSWFURL:String;
		static public var arrAssets:Vector.<Class> = new Vector.<Class>();
		static public var stageReference:Stage;
		static public var globalPageControler:int = 0; // check if the page was loaded
		static public var addressID:String;
		static public var simpleAddressID:String;
	}
	///// http://www.facebook.com/sharer.php?u=http%3A//marceloduende.com.br/2011%3fwork/museum_of_power
	//http://ianserlin.com/index.php/2009/12/18/adding-facebook-twitter-myspace-digg-reddit-bitly-share-functionality-to-your-actionscript-3flex-application/
}
