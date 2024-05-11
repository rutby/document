--[[
	付费相关的一些静态常量
]]


local BillingResponseCode = 
{
	-- The request has reached the maximum timeout before Google Play responds.
	SERVICE_TIMEOUT = -3,
	
	-- Requested feature is not supported by Play Store on the current device. 
	FEATURE_NOT_SUPPORTED = -2,
	
	--[[
	* Play Store service is not connected now - potentially transient state.
	*
	* <p>E.g. Play Store could have been updated in the background while your app was still
	* running. So feel free to introduce your retry policy for such use case. It should lead to a
	* call to {@link #startConnection} right after or in some time after you received this code.
	*]]
	SERVICE_DISCONNECTED = -1,
		
	-- Success 
	OK = 0,
			
	-- User pressed back or canceled a dialog 
	USER_CANCELED = 1,
			
	-- Network connection is down 
	SERVICE_UNAVAILABLE = 2,
	
	-- Billing API version is not supported for the type requested 
	BILLING_UNAVAILABLE = 3,
	
	-- Requested product is not available for purchase 
	ITEM_UNAVAILABLE = 4,
	
	--[[
	* Invalid arguments provided to the API. This error can also indicate that the application was
	* not correctly signed or properly set up for In-app Billing in Google Play, or does not have
	* the necessary permissions in its manifest
	]]
	DEVELOPER_ERROR = 5,
	
	-- Fatal error during the API action
	ERROR = 6,
	
	-- Failure to purchase since item is already owned 
	ITEM_ALREADY_OWNED = 7,
	
	-- Failure to consume since item is not owned 
	ITEM_NOT_OWNED = 8,
}


