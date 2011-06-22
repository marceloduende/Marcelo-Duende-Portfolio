package com.utils {
	import com.Globals;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author Marcelo
	 */
	public class TextFactory extends Sprite {
		private static var _text:String;
		private static var _class:String;
		private static var _vars:Object;
		
		private static var tfield:TextField;
		private static var tformat:TextFormat;
		
		private static var button:MovieClip;
		
		public static function addText($text:String, $class:String, $width:Number = 0, $height:Number = 0, $selectable:Boolean = true):TextField{
			_text = $text;
			_class = $class;
			
			tformat = new TextFormat();
			tformat.leading = 5;
			tfield = new TextField();
			
			if($width == 0 || $height == 0){
				tfield.autoSize = TextFieldAutoSize.LEFT;
			} else {
				tfield.autoSize = TextFieldAutoSize.NONE;
				tfield.wordWrap = true;
				tfield.multiline = true;
			}
			tfield.antiAliasType = AntiAliasType.ADVANCED;
			tfield.defaultTextFormat = tformat;
			tfield.embedFonts = true;
			tfield.selectable = $selectable;
			tfield.styleSheet = Globals.css;
			tfield.width = $width;
			tfield.height = $height;
			tfield.htmlText = "<span class='"+_class+"'>" + _text + " </span>";
		
			return tfield;
		}
		
		
		public static function addButton($text:String, $class:String, $vars:Object = null):MovieClip{
			_text = $text;
			_class = $class;
			_vars = $vars;
			tformat = new TextFormat();
			tfield = new TextField();
			tfield.autoSize = TextFieldAutoSize.LEFT;
			tfield.antiAliasType = AntiAliasType.ADVANCED;
			tfield.defaultTextFormat = tformat;
			tfield.embedFonts = true;
			tfield.styleSheet = Globals.css;
			tfield.htmlText = "<span class='"+_class+"'> " + _text + " </span>";
			
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0x000000,0);
			sp.graphics.drawRect(tfield.x, tfield.y, tfield.textWidth, tfield.textHeight);
			sp.graphics.endFill();
			button = new MovieClip();
			button.addChild(tfield);
			button.addChild(sp);
			
			button.buttonMode = true;
			
			
			return button;
		}
		
		
	}
}
