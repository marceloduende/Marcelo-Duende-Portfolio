/**
 * var lala:XMLList = XmlListDispatcher.getXmlList(DataSource._xml, "name", "section1");
 * trace(lala);
 */
package com.utils {
	import flash.display.Sprite;

	/**
	 * @author Marcelo
	 */
	public class XmlListDispatcher extends Sprite {
		private static var sections:XML;
		private static var tagName:*;
		private static var tagValue:String;
		private static var _parent:String;
		
		public static var arrSearchTerms	: Array = new Array();				
		public static var arrSearchResults	: Array = new Array();
		public static var searchResults	: XMLList = new XMLList();
		
		
		public function XmlListDispatcher();

        public static function getXmlList($sections:XML, $tagName:*, $tagValue:String, $parent:String = ""):XMLList {
            sections = $sections;
            _parent = $parent;
            tagName = $tagName;
            tagValue = $tagValue;
            trace(sections.sections.section + "        sections")
            
            searchResults = sections.sections.section.(@name == tagValue);
            
            
            var item:XML;
            for each(item in searchResults) {
                //trace("item: " + item.toXMLString());
            }
           // trace(searchResults)
           trace(searchResults + " search results")
            return searchResults;
        }
	}
}
