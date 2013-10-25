//////////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Freshplanet (http://freshplanet.com | opensource@freshplanet.com)
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//    http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  
//////////////////////////////////////////////////////////////////////////////////////

package com.freshplanet.nativeExtensions
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
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
	
	public class AirNetworkInfo extends EventDispatcher
	{
		private static var doLogging:Boolean = false;
		private static var extContext:ExtensionContext = null;
		
		private static var _instance:AirNetworkInfo = null;
		
		public function AirNetworkInfo()
		{
			// The NetworkInfo object is a singleton. 
			// To get the single NetworkInfo object, use the static NetworkInfo.networkInfo property. 
			// Do not use new NetworkInfo() in the application that uses this class.			
			extContext = ExtensionContext.createExtensionContext("com.freshplanet.AirNetworkInfo", "net");
			if(!useNativeExtension()) {
				NetworkInfo.networkInfo.addEventListener("networkChange", onNetworkChange);
			} else if (extContext) {
				extContext.addEventListener(StatusEvent.STATUS, onStatusEvent);
			}
			_instance = this;
		}
		
		private function onStatusEvent(e:StatusEvent):void 
		{
			this.dispatchEvent(new Event(e.code));
		}
		
		private function onNetworkChange(e:Event):void 
		{
			this.dispatchEvent(e);
		}
		
		public static function get networkInfo():AirNetworkInfo {
			
			return _instance != null ? _instance : new AirNetworkInfo()
		} 
		
		public function setLogging(value:Boolean):void
		{
			doLogging = value;
			if(this.useNativeExtension()) {
				extContext.call("setLogging", doLogging);
			}
		}
		
		/**
		 * Check the current connectivity of the device
		 * @return True if the device is connected to internet, false otherwise.
		 */
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
		
		
		public function isConnectedWithWIFI():Boolean
		{
			if (this.useNativeExtension())
			{
				return isNativeConnectedWithWIFI();
			} else
			{
				return isNotNativeConnectedWithWIFI();
			}
		}
		
		
		private function isNativeConnectedWithWIFI():Boolean
		{
			var interfaces:Vector.<NativeNetworkInterface> = this.findInterfaces();
			
			for(var i:uint = 0; i < interfaces.length; i++)
			{
				if(doLogging)
					trace("[Network Info]", interfaces[i].name.toLowerCase(), interfaces[i].active);
				
				if (interfaces[i].active && interfaces[i].name.toLocaleLowerCase() == "en0")
				{
					return true;
				}
			}
			return false;

		}
		
		
		private function isNotNativeConnectedWithWIFI():Boolean
		{
			var interfaces:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
			
			for(var i:uint = 0; i < interfaces.length; i++)
			{
				if(doLogging)
					trace("[Network Info]", interfaces[i].name.toLowerCase(), interfaces[i].active);
				
				if (interfaces[i].active && ["en0", "wifi"].indexOf(interfaces[i].name.toLocaleLowerCase()) > -1)
				{
					return true;
				}
			}
			return false;
			
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
				if(doLogging)
					trace("[Network Info]", interfaces[i].name.toLowerCase(), interfaces[i].displayName, interfaces[i].active);
				
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
				if(doLogging)
					trace("[Network Info]", interfaces[i].name.toLowerCase(), interfaces[i].displayName, interfaces[i].active);
				
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





