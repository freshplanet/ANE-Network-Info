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
	// The NetworkInterface class describes a network interface. 
	// It is analogous to the NetworkInfo class that is part of ActionScript 3.0.
	
	public class NativeNetworkInterface
	{   
		
		private var _name:String = "";
		private var _displayName:String = "";
		private var _mtu:int = -1;
		private var _hardwareAddress:String = "";
		private var _active:Boolean = false;
		
		
		
		public function NativeNetworkInterface(nm:String,dName:String,mt:int,active:Boolean ,hwaddrs:String,addrs:Array):void
		{		
			_name = nm;
			_displayName = dName;
			_mtu = mt;
			_hardwareAddress = hwaddrs;
			_active= active;
			
		}
		
		
		public function get name():String
		{
			return (_name);
		}
		
		public function get displayName():String
		{
			return (_displayName);
		}
		
		public function get mtu():int
		{
			return (_mtu);
		}
		
		public function get hardwareAddress():String
		{
			return (_hardwareAddress);
		}
		
		public function get active():Boolean
		{
			return (_active);
		}
		
	}
}



