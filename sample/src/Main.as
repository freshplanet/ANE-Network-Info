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
package {

import com.freshplanet.nativeExtensions.AirNetworkInfo;
import com.freshplanet.nativeExtensions.NativeNetworkInterface;

import con.freshplanet.ui.ScrollableContainer;
import con.freshplanet.ui.TestBlock;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.events.Event;

public class Main extends Sprite {

    public static var stageWidth:Number = 0;
    public static var indent:Number = 0;

    private var _scrollableContainer:ScrollableContainer = null;

    public function Main() {
        this.addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
    }

    private function _onAddedToStage(event:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
        this.stage.align = StageAlign.TOP_LEFT;

        stageWidth = this.stage.stageWidth;
        indent = stage.stageWidth * 0.025;

        _scrollableContainer = new ScrollableContainer(false, true);
        this.addChild(_scrollableContainer);


        var blocks:Array = [];

        blocks.push(new TestBlock("isConnected", function():void {
            trace("isConnected", AirNetworkInfo.networkInfo.isConnected());
        }));
        blocks.push(new TestBlock("isConnectedWithWIFI", function():void {
            trace("isConnectedWithWIFI ", AirNetworkInfo.networkInfo.isConnectedWithWIFI());
        }));
        blocks.push(new TestBlock("findInterfaces", function():void {
            var interfaces:Vector.<NativeNetworkInterface> = AirNetworkInfo.networkInfo.findInterfaces();
            for (var i:int = 0; i < interfaces.length; i++) {
                var networkInterface:NativeNetworkInterface = interfaces[i];
                trace("Network interface : ");
                trace("Active : ", networkInterface.active);
                trace("Display Name : ", networkInterface.displayName);
                trace("Hardware Address : ", networkInterface.hardwareAddress);
                trace("MTU : ", networkInterface.mtu);
                trace("Name : ", networkInterface.name);
                trace("-----------------------");
            }
        }));


        /**
         * add ui to screen
         */

        var nextY:Number = indent;

        for each (var block:TestBlock in blocks) {

            _scrollableContainer.addChild(block);
            block.y = nextY;
            nextY +=  block.height + indent;
        }
    }
}
}
