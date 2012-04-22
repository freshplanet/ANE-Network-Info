package com.freshplanet.nativeExtensions
{
	import flash.external.ExtensionContext;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.system.Capabilities;
	
	// The NetworkInfo class provides information about the network interfaces on a device. 
	// It is analogous to the NetworkInfo class that is part of ActionScript 3.0. However, that
	// class does not support all mobile devices.
	
	// The AirNetworkInfo object is a singleton. 
	// To get the single NetworkInfo object, use the static NetworkInfo.networkInfo property. 
	// Do not call the class constructor by calling new NetworkInfo().
	
	public class AirNetworkInfo
	{
		private static var extContext:ExtensionContext = null;
		
		private static var _instance:AirNetworkInfo = null;
		
		public function AirNetworkInfo()
		{
			// The NetworkInfo object is a singleton. 
			// To get the single NetworkInfo object, use the static NetworkInfo.networkInfo property. 
			// Do not use new NetworkInfo() in the application that uses this class.			
			trace("Extension Context Created Constructor");
			extContext = ExtensionContext.createExtensionContext("com.freshplanet.AirNetworkInfo", "net");
			_instance = this;
		}
		
		public static function get networkInfo():AirNetworkInfo {
			
			return _instance != null ? _instance : new AirNetworkInfo()
		} 
		
		public function isConnected():Boolean
		{
			if (this.useNativeExtension())
			{
				return hasNativeActiveConnection();
			} else
			{
				return hasActiveConnection();
			}
		}
		
		private function hasNativeActiveConnection():Boolean
		{
			var interfaces:Vector.<NativeNetworkInterface> = this.findInterfaces();
			if(interfaces.length==0)
			{
				return true;
			}

			for(var i:uint = 0; i < interfaces.length; i++)
			{
				trace(interfaces[i].name.toLowerCase(), interfaces[i].active)
				if (interfaces[i].active)
				{
					return true;
				}
			}			
			
			return false;
		}
		
		
		private function hasActiveConnection():Boolean
		{
			var interfaces:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
			
			for(var i:uint = 0; i < interfaces.length; i++)
			{
				trace(interfaces[i].name.toLowerCase(), interfaces[i].active)
				if (interfaces[i].active)
				{
					return true;
				}
			}
			return false;
		}
		
		
		// findInterfaces() finds the network interfaces on the device.
		public function findInterfaces():Vector.<NativeNetworkInterface>
		{  
			var rarr:Vector.<NativeNetworkInterface>;
			var arr:Array = extContext.call("getInterfaces") as Array ;
			var i:int = 0;
			rarr = Vector.<NativeNetworkInterface>(arr);
			
			return rarr;		
		}
		
		private function useNativeExtension():Boolean
		{
			return Capabilities.manufacturer.indexOf("iOS") > -1;
		}
		
	}
}





