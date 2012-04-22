
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
	// The NetworkInterface class describes a network interface. 
	// It is analogous to the NetworkInfo class that is part of ActionScript 3.0.
	
	public class NetworkInterface
	{   
		
		private var _name:String = "";
		private var _displayName:String = "";
		private  var _addresses:Vector.<InterfaceAddress> = new Vector.<InterfaceAddress> ;
		private var _mtu:int = -1;
		private var _hardwareAddress:String = "";
		private var _active:Boolean = false;
		
		
		
		public function NetworkInterface(nm:String,dName:String,mt:int,active:Boolean ,hwaddrs:String,addrs:Array):void
		{		
			_name = nm;
			_addresses =  Vector.<InterfaceAddress>(addrs);	
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
		
		public function get addresses():Vector.<InterfaceAddress>
		{   
			return (_addresses);
		}
	}
}



