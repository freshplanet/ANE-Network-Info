/*
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
package com.freshplanet.ane.AirNetworkInfo {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
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
	 */
	public class AirNetworkInfo extends EventDispatcher {
		
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									   PUBLIC API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		/**
		 * Determine use native implementation or AIR - use native on iOS only
		 */
		public static function get isSupported():Boolean {
			return isIOS || isAndroid;
		}
		
		/**
		 * AirNetworkInfo instance
		 */
		public static function get instance():AirNetworkInfo {
			return _instance != null ? _instance : new AirNetworkInfo();
		}
		
		/**
		 * If <code>true</code>, logs will be displayed at the ActionScript and native level.
		 */
		public function setLogging(value:Boolean):void {
			_doLogging = value;
		}
		
		/**
		 * Check the current connectivity of the device
		 * @return True if the device is connected to internet, false otherwise.
		 */
		public function get isConnected():Boolean {
			
			return isIOS ? _hasNativeActiveConnection() : _hasActiveConnection();
		}
		
		/**
		 * Check the current WIFI connection
		 * @return True if the device is connected to internet via WIFI, false otherwise.
		 */
		public function get isConnectedWithWIFI():Boolean {
			
			return isIOS ? _checkWifiConnectionNative() : _checkWifiConnectionAS3();
		}
		
		/**
		 * Finds the network interfaces on the device.
		 */
		public function findInterfaces():Vector.<NativeNetworkInterface> {
			
			var interfacesVector:Vector.<NativeNetworkInterface> = null;
			
			if (isIOS) {
				
				var interfacesArray:Array = _context.call("getInterfaces") as Array;
				trace("GOT INTERFACES ", interfacesArray);
				interfacesVector = Vector.<NativeNetworkInterface>(interfacesArray);
			}
			else {
				
				var results:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
				interfacesVector = new <NativeNetworkInterface>[];
				
				for (var i:int = 0; i < results.length; i++) {
					
					var networkInterface:NetworkInterface = results[i];
					var nativeNetworkInterface:NativeNetworkInterface = new NativeNetworkInterface(
							networkInterface.name, networkInterface.displayName, networkInterface.mtu,
							networkInterface.active, networkInterface.hardwareAddress, null);
				
					interfacesVector.push(nativeNetworkInterface);
				}
			}
			
			return interfacesVector;
		}

		public function get carrierName():String {
			if (isSupported)
				return _context.call("getCarrierName") as String;

			return null;
		}
		
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									 	PRIVATE API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		private static const EXTENSION_ID:String                = "com.freshplanet.ane.AirNetworkInfo";
		private static const IOS_NOT_CONNECTED_STATUS:int       = 0;
		private static const IOS_CONNECTED_WITH_WIFI_STATUS:int = 1;
		private static const IOS_CONNECTED_WITH_WMAN_STATUS:int = 2;
		
		private static var _instance:AirNetworkInfo = null;
		
		private var _context:ExtensionContext = null;
		private var _doLogging:Boolean        = false;
		
		/**
		 * "private" singleton constructor
		 */
		public function AirNetworkInfo() {
			
			super();
			
			if (_instance)
				throw Error("this is a singleton, use .instance, do not call the constructor directly");
			
			_instance = this;
			
			if (isAndroid)
				NetworkInfo.networkInfo.addEventListener("networkChange", _onNetworkChange);

			if(isSupported) {
				
				_context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
				
				if (!_context)
					trace("ERROR", "Extension context is null. Please check if extension.xml is setup correctly.");
				else
					_context.addEventListener(StatusEvent.STATUS, _onStatusEvent);
			}
		}
		
		/**
		 * Status event listener
		 * @param e
		 */
		private function _onStatusEvent(e:StatusEvent):void {
			
			this.dispatchEvent(new Event(e.code));
		}
		
		/**
		 * Network changed listener
		 * @param e
		 */
		private function _onNetworkChange(e:Event):void {
			
			this.dispatchEvent(e);
		}
		
		/**
		 * Helper function for checking wifi connectivity natively
		 */
		private function _checkWifiConnectionNative():Boolean {
			
			var status:int = _context.call("getConnectivityStatus") as int;
			return status == IOS_CONNECTED_WITH_WIFI_STATUS;
		}
		
		/**
		 * Helper function for checking wifi connectivity via AIR
		 */
		private function _checkWifiConnectionAS3():Boolean {
			
			var interfaces:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
			
			for (var i:uint = 0; i < interfaces.length; i++) {
				
				if (_doLogging)
					trace("[Network Info]", interfaces[i].name.toLowerCase(), interfaces[i].active);
				
				if (interfaces[i].active && ["en0", "wifi"].indexOf(interfaces[i].name.toLocaleLowerCase()) > -1)
					return true;
			}
			
			return false;
		}
		
		/**
		 * Helper function for checking internet connectivity natively
		 */
		private function _hasNativeActiveConnection():Boolean {
			
			var status:int     = _context.call("getConnectivityStatus") as int;
			var active:Boolean = status == IOS_CONNECTED_WITH_WMAN_STATUS || status == IOS_CONNECTED_WITH_WIFI_STATUS;
			
			return active;
		}
		
		/**
		 * Helper function for checking internet connectivity via AIR
		 */
		private function _hasActiveConnection():Boolean {
			
			var interfaces:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
			
			for (var i:uint = 0; i < interfaces.length; i++) {
				
				if (_doLogging)
					trace("[Network Info]", interfaces[i].name.toLowerCase(), interfaces[i].displayName, interfaces[i].active);
				
				if (interfaces[i].active)
					return true;
			}
			
			return false;
		}

		private static function get isIOS():Boolean {
			return Capabilities.manufacturer.indexOf("iOS") > -1;
		}

		private static function get isAndroid():Boolean {
			return Capabilities.manufacturer.indexOf("Android") > -1;
		}
	}
}





