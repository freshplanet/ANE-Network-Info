
/*

ADOBE SYSTEMS INCORPORATED
Copyright 2011 Adobe Systems Incorporated
All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.

*/


package
{

	import com.adobe.nativeExtensions.Networkinfo.InterfaceAddress;
	import com.adobe.nativeExtensions.Networkinfo.NetworkInfo;
	import com.adobe.nativeExtensions.Networkinfo.NetworkInterface;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class NetworkInfoUsageApp extends Sprite
	{
		private var info:TextField;
		public function NetworkInfoUsageApp()
		{
			super();	
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			var ntf:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
			info = makeTextField(50, 50);
			
			for each (var interfaceObj:NetworkInterface in ntf)
			{
				trace("Interface Name:" + interfaceObj.name + "\n" );
				trace("MTU:" + interfaceObj.mtu.toString + "\n" );
				trace("Display Name of the Interface:" + interfaceObj.displayName + "\n" );
				trace ("Active ?" + interfaceObj.active.toString() + "\n" );
				trace("Hardware Address:" + interfaceObj.hardwareAddress + "\n");
				
				
				
				info.appendText("Interface Name:" + interfaceObj.name + "\n" );
				info.appendText("MTU:" + interfaceObj.mtu.toString() + "\n" );
				info.appendText("Display Name of the Interface:" + interfaceObj.displayName + "\n" );
				info.appendText("Active ?" + interfaceObj.active.toString()+ "\n");
				info.appendText("Hardware Address:" + interfaceObj.hardwareAddress + "\n");
				
				for each(var address:InterfaceAddress in interfaceObj.addresses)
				{
					trace("Address" + address.address + "\n");
					trace("broadcast address" + address.broadcast + "\n");
					trace("ipversion" + address.ipVersion + "\n")
					trace("prefixlength" + address.prefixLength +"\n")
					
					info.appendText("Address" + address.address + "\n" );
					info.appendText("broadcast address" + address.broadcast + "\n" );
					info.appendText("ipversion" + address.ipVersion + "\n");
					info.appendText("prefixlength" + address.prefixLength +"\n" );

				}
				
				
			}
			
			
		}
		private function makeTextField(x:Number, y:Number):TextField
		{
			var tf:TextField = new TextField();
			
			tf.x = x;
			tf.y = y;
			tf.border=true;
			this.stage.addChild(tf);
			tf.height = 800;
			tf.width = 450;
			tf.type = "input";
			var tff:TextFormat=new TextFormat();
			tff.size=18;
		
			tff.color=0x0000ff;
			tf.defaultTextFormat=tff;
			tf.setTextFormat(tff);
			
			tf.text="hello";
			return tf;
		}
	}
}