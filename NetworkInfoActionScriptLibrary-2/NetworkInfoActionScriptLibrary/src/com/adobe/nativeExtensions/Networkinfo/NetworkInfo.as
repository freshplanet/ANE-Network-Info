
/*

ADOBE SYSTEMS INCORPORATED
Copyright 2011 Adobe Systems Incorporated
All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.

*/


package com.adobe.nativeExtensions.Networkinfo
{
	import flash.external.ExtensionContext;
	
	import mx.core.mx_internal;
	
	// The NetworkInfo class provides information about the network interfaces on a device. 
	// It is analogous to the NetworkInfo class that is part of ActionScript 3.0. However, that
	// class does not support all mobile devices.
	
	// The NetworkInfo object is a singleton. 
	// To get the single NetworkInfo object, use the static NetworkInfo.networkInfo property. 
	// Do not call the class constructor by calling new NetworkInfo().
	
	public class NetworkInfo
	{
		private static var extContext:ExtensionContext = null;
		
		private static var _instance:NetworkInfo = null;
		private static var _shouldCreateInstance:Boolean = false;
		
		public function NetworkInfo()
		{
			// The NetworkInfo object is a singleton. 
			// To get the single NetworkInfo object, use the static NetworkInfo.networkInfo property. 
			// Do not use new NetworkInfo() in the application that uses this class.
			
			if (_shouldCreateInstance)
			{
				trace("Extension Context Created Constructor");
				extContext = ExtensionContext.createExtensionContext("com.adobe.Networkinfo", "net");
			}
			else
			{
				throw new Error("ERROR!!");  
			}		
		}
		
		public static function get networkInfo():NetworkInfo {
			
			if(_instance == null)
			{
				_shouldCreateInstance = true; 
				_instance = new NetworkInfo();
				_shouldCreateInstance = false;
			}
			
			return _instance;
		} 
		
		// findInterfaces() finds the network interfaces on the device.
		public function findInterfaces():Vector.<NetworkInterface>
		{  
			trace ("Entering findInterfaces()");
			var arr:Array = extContext.call("getInterfaces") as Array ;
			var i:int = 0;
			var rarr:Vector.<NetworkInterface> = Vector.<NetworkInterface>(arr);
			return rarr;		
		}
	}
}





