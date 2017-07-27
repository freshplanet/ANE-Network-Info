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

package com.freshplanet.ane.AirNetworkInfo.functions;



import android.content.Context;
import android.telephony.TelephonyManager;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;

public class GetCarrierNameFunction extends BaseFunction {
	public FREObject call(FREContext context, FREObject[] args) {
		super.call(context, args);

		TelephonyManager manager = (TelephonyManager)context.getActivity().getSystemService(Context.TELEPHONY_SERVICE);
		String carrierName = manager.getNetworkOperatorName();
		try {
			return FREObject.newObject(carrierName);
		} catch (Exception e) {
			context.dispatchStatusEventAsync("log", "Exception occurred while trying to get carrierName " + e.getLocalizedMessage());
		}

		return null;


	}

}