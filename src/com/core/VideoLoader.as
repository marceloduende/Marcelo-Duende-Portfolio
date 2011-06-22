package com.core {
	import com.greensock.TweenMax;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/**
	 * @author marcelosantos
	 */
	public class VideoLoader extends MovieClip {
		
		public var url:String;
		public var _w:Number;
		public var _h:Number;
		public var nc:NetConnection;
		public var ns:NetStream;
		
		
		
		public function loadVid($url:String, $w:Number, $h:Number):void {
			url = $url;
			_w = $w;
			_h = $h;
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			nc.connect(null);
		}
		
		public function netStatusHandler(event:NetStatusEvent):void {
            switch (event.info.code) {
                case "NetConnection.Connect.Success":
                    connectStream();
                    break;
                case "NetStream.Play.StreamNotFound":
                    trace("Stream not found: " + url);
                    break;
                 case "NetStream.Play.Start":
                 	dispatchEvent(new Event(Event.INIT));
                    break;
            }
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
        }
		public var video:Video;

		private function connectStream() : void {
			
            ns = new NetStream(nc);
            ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            ns.client = new CustomClient();
           	video = new Video();
           	video.name = "videoReel";
            video.attachNetStream(ns);
            video.smoothing = true;
            video.width = _w;
            video.height = _h;
            ns.play(url);
            video.alpha = 0;
            TweenMax.to(video, .4, {alpha:1, delay:1});
            
            
            
        }
        
        public function dispose():void{
        	if(ns){
        		ns.togglePause();
        		ns.pause();
        		ns.close();
        		nc.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        		nc.close();
        		ns.client = {};
        		
        	}
        }
    }
}

class CustomClient {
    public function onMetaData(info:Object):void {
        trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
    }
    public function onCuePoint(info:Object):void {
        trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
    }
    public function onXMPData(infoObject:Object):void 
    { 
        trace("onXMPData Fired\n"); 
         //trace("raw XMP =\n"); 
         //trace(infoObject.data); 
        var cuePoints:Array = new Array(); 
        var cuePoint:Object; 
        var strFrameRate:String; 
        var nTracksFrameRate:Number; 
        var strTracks:String = ""; 
        var onXMPXML:XML = new XML(infoObject.data); 
        // Set up namespaces to make referencing easier 
        var xmpDM:Namespace = new Namespace("http://ns.adobe.com/xmp/1.0/DynamicMedia/"); 
        var rdf:Namespace = new Namespace("http://www.w3.org/1999/02/22-rdf-syntax-ns#"); 
        for each (var it:XML in onXMPXML..xmpDM::Tracks) 
        { 
             var strTrackName:String = it.rdf::Bag.rdf::li.rdf::Description.@xmpDM::trackName; 
             var strFrameRateXML:String = it.rdf::Bag.rdf::li.rdf::Description.@xmpDM::frameRate; 
             strFrameRate = strFrameRateXML.substr(1,strFrameRateXML.length); 
             
             nTracksFrameRate = Number(strFrameRate);  
             
             strTracks += it; 
        } 
        var onXMPTracksXML:XML = new XML(strTracks); 
        var strCuepoints:String = ""; 
        for each (var item:XML in onXMPTracksXML..xmpDM::markers) 
        { 
            strCuepoints += item; 
        } 
        trace(strCuepoints); 
    } 
}