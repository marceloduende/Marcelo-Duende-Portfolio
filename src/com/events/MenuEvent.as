package com.events {
	import flash.events.Event;

	/**
	 * @author Marcelo
	 */
	public class MenuEvent extends Event {
		public static const MENU_RELEASED:String = "menu_released";
		public function MenuEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
