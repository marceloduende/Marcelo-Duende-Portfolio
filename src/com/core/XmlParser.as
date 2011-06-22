package com.core {
	/**
	 * @author Marcelo
	 */
	public class XmlParser{
		public var xmlParsed:XMLList;
		public function parseXML(xmlUrl:XML, node:String):void{
			
			var xml:XML = xmlUrl;
			
			for each(var a:String in xml.child(node)){
				if(a == xml.child(node).toString()){
					xmlParsed = XMLList(a);
				}
			}
		}
	}
}
