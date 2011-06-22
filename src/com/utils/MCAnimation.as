package com.utils {
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * @author Marcelo
	 */
	public class MCAnimation extends MovieClip{
		public var _currentObj:Object;
		public var _playMode:Boolean;
		
		
		/**
		 * @param mcName = class received from caller
		 * @example 
		 * var addLogo : MCAnimation = new MCAnimation();
		 * addLogo.getMCName(event.target.content.loaderInfo.applicationDomain.getDefinition("preloader_mushroom") as Class);
		 * addLogo.currentObj // variable to access the information
		 */
		
		public function getMCName(mcName:Class, playMode:Boolean = false):Object{
			_currentObj = new mcName();
			_playMode = playMode;
			timelineAction();
			
			return _currentObj;
		}
		
		public function timelineAction():void{
			if(_playMode == true){
				_currentObj.play();
				_currentObj.addEventListener(Event.ENTER_FRAME, animationIn);
			} else if (_playMode == false) {
				
				_currentObj.stop();
			}
		}
		
		/**
		 * @internal still working on it
		 */
		public function animationIn(e:Event):void{
			if(_currentObj.currentLabel == "stop"){
				
				_currentObj.removeEventListener(Event.ENTER_FRAME, animationIn);
				_currentObj.stop();
				trace("gotit");
			}
		}
	}
}
