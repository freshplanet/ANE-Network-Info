/**
 * Copyright 2017 FreshPlanet
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.freshplanet.nativeExtensions
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
import flash.net.InterfaceAddress;
import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.system.Capabilities;

	/**
	 *   The NetworkInfo class provides information about the network interfaces on a device.
	 *   It is analogous to the NetworkInfo class that is part of ActionScript 3.0. However, that
	 *   class does not support all mobile devices.
	 *
	 *   The AirNetworkInfo object is a singleton.
	 *   To get the single NetworkInfo object, use the static NetworkInfo.networkInfo property.
	 *   Do not call the class constructor by calling new NetworkInfo().
	 *
	 */

	
	public class AirNetworkInfo extends EventDispatcher
	{
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									   PUBLIC API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//

		/**
		 * AirNetworkInfo instance
		 */
		public static function get networkInfo():AirNetworkInfo {

			return _instance != null ? _instance : new AirNetworkInfo()
		}

		/**
		 * If <code>true</code>, logs will be displayed at the ActionScript and native level.
		 */
		public function setLogging(value:Boolean):void
		{
			_doLogging = value;
			if(this.useNativeExtension()) {
				_extContext.call("setLogging", _doLogging);
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

		/**
		 * Check the current WIFI connection
		 * @return True if the device is connected to internet via WIFI, false otherwise.
		 */
		public function isConnectedWithWIFI():Boolean
		{
			if (this.useNativeExtension())
			{
				return checkWifiConnectionNative();
			} else
			{
				return checkWifiConnectionAS3();
			}
		}

		/**
		 * Finds the network interfaces on the device.
		 */
		public function findInterfaces():Vector.<NativeNetworkInterface>
		{
			var interfacesVector:Vector.<NativeNetworkInterface>;
			if(useNativeExtension())
			{
				var interfacesArray:Array = _extContext.call("getInterfaces") as Array;
				interfacesVector = Vector.<NativeNetworkInterface>(interfacesArray);

			}
			else
			{
				interfacesVector = new <NativeNetworkInterface>[];

				var results:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
				for (var i:int = 0; i < results.length; i++) {
					var networkInterface:NetworkInterface = results[i];
					interfacesVector.push(
							new NativeNetworkInterface(
									networkInterface.name,
									networkInterface.displayName,
									networkInterface.mtu,
									networkInterface.active,
									networkInterface.hardwareAddress,
									null
							));

				}

			}

			return interfacesVector;
		}


		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									 	PRIVATE API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//



		private static var _doLogging:Boolean = false;
		private static var _extContext:ExtensionContext = null;
		private static var _instance:AirNetworkInfo = null;

		/**
		 * "private" singleton constructor
		 */
		public function AirNetworkInfo()
		{
			// The NetworkInfo object is a singleton. 
			// To get the single NetworkInfo object, use the static NetworkInfo.networkInfo property. 
			// Do not use new NetworkInfo() in the application that uses this class.			
			_extContext = ExtensionContext.createExtensionContext("com.freshplanet.AirNetworkInfo", "net");
			if(!useNativeExtension()) {
				NetworkInfo.networkInfo.addEventListener("networkChange", onNetworkChange);
			} else if (_extContext) {
				_extContext.addEventListener(StatusEvent.STATUS, onStatusEvent);
			}
			_instance = this;
		}

		/**
		 * Status event listener
		 * @param e
		 */
		private function onStatusEvent(e:StatusEvent):void 
		{
			this.dispatchEvent(new Event(e.code));
		}

		/**
		 * Network changed listener
		 * @param e
		 */
		private function onNetworkChange(e:Event):void 
		{
			this.dispatchEvent(e);
		}

		/**
		 * Helper function for checking wifi connectivity natively
		 */
		private function checkWifiConnectionNative():Boolean
		{
			var status:int = _extContext.call("getConnectivityStatus") as int;
			return status == IOS_CONNECTED_WITH_WIFI_STATUS;
		}

		/**
		 * Helper function for checking wifi connectivity via AIR
		 */
		private function checkWifiConnectionAS3():Boolean
		{
			var interfaces:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
			
			for(var i:uint = 0; i < interfaces.length; i++)
			{
				if(_doLogging)
					trace("[Network Info]", interfaces[i].name.toLowerCase(), interfaces[i].active);
				
				if (interfaces[i].active && ["en0", "wifi"].indexOf(interfaces[i].name.toLocaleLowerCase()) > -1)
				{
					return true;
				}
			}
			return false;
			
		}

		
		private static const IOS_NOT_CONNECTED_STATUS:int = 0;
		private static const IOS_CONNECTED_WITH_WIFI_STATUS:int = 1;
		private static const IOS_CONNECTED_WITH_WMAN_STATUS:int = 2;

		/**
		 * Helper function for checking internet connectivity natively
		 */
		private function hasNativeActiveConnection():Boolean
		{
			var status:int = _extContext.call("getConnectivityStatus") as int ;
			if (status == IOS_CONNECTED_WITH_WMAN_STATUS || status == IOS_CONNECTED_WITH_WIFI_STATUS)
			{
				return true;
			}
			return false;
		}

		/**
		 * Helper function for checking internet connectivity via AIR
		 */
		private function hasActiveConnection():Boolean
		{
			var interfaces:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
			
			for(var i:uint = 0; i < interfaces.length; i++)
			{
				if(_doLogging)
					trace("[Network Info]", interfaces[i].name.toLowerCase(), interfaces[i].displayName, interfaces[i].active);
				
				if (interfaces[i].active)
				{
					return true;
				}
			}
			return false;
		}

		/**
		 * Determine use native implementation or AIR - use native on iOS only
		 */
		private function useNativeExtension():Boolean
		{
			return Capabilities.manufacturer.indexOf("iOS") > -1;
		}
		
	}
}





