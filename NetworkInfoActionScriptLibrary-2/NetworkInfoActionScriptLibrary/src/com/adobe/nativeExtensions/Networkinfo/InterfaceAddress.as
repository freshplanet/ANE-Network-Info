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
	// The InterfaceAddress class eports the properties of a network interface address. 
	// It is analogous to the InterfaceAddress class that is part of ActionScript 3.0.
	
	public class InterfaceAddress
	{
		private var _address:String = "";
		private var _broadcast:String = "";
		private var _prefixLength:int = -1;
		private var _ipVersion:String = "IPV4";
		
		public function InterfaceAddress(add:String, broadCast:String, prfx:int, ipVer:String)
		{
			_address = add;
			_broadcast = broadCast;
			_prefixLength = prfx;  // Not currently supported
			_ipVersion = ipVer;
		}
		
		public function get address():String
		{
			return(_address);
		}
		
		public function get broadcast():String
		{
			return(_broadcast);
		}
		
		public function get prefixLength():int
		{
			return (_prefixLength);
		}
		
		public function get ipVersion():String
		{
			return (_ipVersion);
		}
	}
}