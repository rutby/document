local UserBindManager = BaseClass("UserBindManager")
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

local function __init(self)
	self.param = {}
end

local function __delete(self)
	self.param = nil
end

local function SetParam(self,param)
	self.param = param
end

local function UserBindHandle(self,message)
	if message["errorCode"] == nil then
		local gameUid = message["gameUid"]
		if gameUid ~= nil and gameUid ~= "" then
			--登录的账号 之前绑定过一个游戏账号， 返回该游戏账号数据了
			if self.param.optType == AccountBindType.Change then
				--切换账号 提示 是否覆盖数据
				local tmpInfo = Localization:GetString("280058").."\n          "..Localization:GetString("208186")
						.."  "..message["gameUserName"].."\n          "..Localization:GetString("280060").."  "..message["id"].."\n"
						..Localization:GetString("280051").."\n"
				UIUtil.ShowMessage(tmpInfo
				,function()
							UIUtil.ShowMessage(Localization:GetString("280056"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
								self:ChangeAccountSecondOKCallback(message)
							end, function() end);
						end
				,function() end)
			elseif self.param.optType == AccountBindType.Bind then
				--提示绑定失败
				UIUtil.ShowMessage(Localization:GetString("280080"))
			end
		else
			--如果是绑定账号，就是绑定成功
			--如果是切换账号，就提示切换失败
			local status = message["status"]
			if status == nil then
				if self.param.optType == AccountBindType.Bind then
					--绑定成功
					local fbUid = Setting:GetString("tmpFaceBook_uid","")
					if (self.param.facebook ~= "" or fbUid ~= "") and self.param.googlePlay == "" and self.param.weixin == "" then
						if self.param.facebook ~= "" then
							Setting:SetString(SettingKeys.FB_USERID, self.param.facebook)
						else
							Setting:SetString(SettingKeys.FB_USERID, fbUid)
						end
						local fbName = Setting:GetString("tmpFaceBook_Name","")
						if fbName ~= "" then
							Setting:SetString(SettingKeys.FB_USERNAME, fbName)
						end
					end

					local gpUid = Setting:GetString("tmpGooglePlay_uid","")
					if (self.param.googlePlay ~= "" or gpUid ~= "") and self.param.facebook == "" and self.param.weixin == "" then
						if self.param.googlePlay ~= "" then
							Setting:SetString(SettingKeys.GP_USERID, self.param.googlePlay)
						else
							Setting:SetString(SettingKeys.GP_USERID, gpUid)
						end
						local gpName = Setting:GetString("tmpGooglePlayName","")
						if gpName ~= "" then
							Setting.SetString(SettingKeys.GP_USERNAME, gpName)
						end
					end
					LuaEntry.Player.bindFlag = true

					local picUrl = Setting:GetString("tmpFaceBook_picUrl","")
					if picUrl == "" then
						picUrl = "https://graph.facebook.com/%"..fbUid.."/picture"
						CS.GameEntry.Setting:SetPrivateString("tmpFaceBook_picUrl", picUrl)
					end
					EventManager:GetInstance():Broadcast(EventId.MSG_USER_BIND_OK)
					CS.GameEntry.GlobalData.showFaceBookUi = false
					UIUtil.ShowTipsId(280053) 
				else
					--切换账号失败
					UIUtil.ShowMessage(Localization:gETstring("280061"))
				end
			else
				Setting.SetString(SettingKeys.CUSTOM_UID, "")
				if status == 1 then
					UIUtil.ShowTipsId("email not confirm!") 
					EventManager:GetInstance():Broadcast(EventId.MSG_USER_BIND_OK)
				elseif status == 2 then
					UIUtil.ShowTipsId("passsword error!") 
					EventManager:GetInstance():Broadcast(EventId.MSG_USER_BIND_OK)
				end
			end
		end
	else
		local temp = message["errorCode"]
		if temp == "E100200" then
			local userName = ""
			local userServerId = ""
			local reason = ""
			local bantime = 0
			if message["gameUserName"] ~= nil then
				userName = message["gameUserName"]
			end
			if message["serverId"] ~= nil then
				userServerId = message["serverId"]
			end
			if message["banMsgId"] ~= nil then
				reason = message["banMsgId"]
			end
			if message["banTime"] ~= nil then
				bantime = message["banTime"]
			end
			--todo 打开账号禁止页面
		else
			if self.param.optType == AccountBindType.Bind then
				UIUtil.ShowTipsId(280054) --绑定失
			elseif self.param.optType == AccountBindType.Change then
				local accountName = ""
				if self.param.facebook ~= nil and self.param.facebook ~= "" then
					accountName = Localization:GetString("280046")
				elseif self.param.googlePlay ~= nil and self.param.googlePlay ~= "" then
					if CS.SDKManager.IS_UNITY_IPHONE() then
						accountName = Localization:GetString("120058")
					else
						accountName = Localization:GetString("280047")
					end
				elseif self.param.weixin ~= nil and self.param.weixin ~= "" then
					accountName = Localization:GetString("100466")
				end
				UIUtil.ShowTips(Localization:GetString("280048", accountName))
			end
		end
	end
	EventManager:GetInstance():Broadcast(EventId.AccountBindOKEvent)
end

local function ChangeAccountSecondOKCallback(self,message)
	Setting:SetString(SettingKeys.FB_USERNAME, Setting:GetString("tmpFaceBook_Name"))
	Setting:SetString(SettingKeys.FB_USERID, self.param.facebook)
	Setting:SetString(SettingKeys.GP_USERID, self.param.googlePlay)
	Setting:SetString(SettingKeys.WX_APPID_CACHE, self.param.weixin)
	if self.param.facebook ~= "" or self.param.googlePlay ~= "" or self.param.weixin ~= "" then
		Setting:SetBool("bindLogin", true)
	end
	Setting:SetString(SettingKeys.UUID, message["uuid"])
	Setting:SetString(SettingKeys.GAME_UID, message["gameUid"])
	Setting:SetPrivateInt(SettingKeys.ACCOUNT_STATUS, AccountBandState.Band)
	Setting:SetString(SettingKeys.SERVER_IP, message["ip"])
	Setting:SetInt(SettingKeys.SERVER_PORT, message["port"])
	Setting:SetString(SettingKeys.SERVER_ZONE, message["zone"])
	--发送UserCleanPostMessage消息
	SFSNetwork.SendMessage(MsgDefines.UserCleanPostMessage)
end

local function UserBindCancelHandle(self,message)
	if message["errorCode"] == nil then
		UIUtil.ShowTipsId(280055) 
		if self.param.bindType == BIND_TYPE.DEVICE then
			Setting:SetString(SettingKeys.DEVICE_UID, "")
			EventManager:GetInstance():Broadcast(EventId.AccountBindOKEvent,"de")
		elseif self.param.bindType == BIND_TYPE.FACEBOOK then
			Setting:SetPrivateString(SettingKeys.FB_USERID, "")
			Setting:SetString(SettingKeys.FB_USERNAME, "")
			EventManager:GetInstance():Broadcast(EventId.AccountBindOKEvent,"fb")
		elseif self.param.bindType == BIND_TYPE.GOOGLEPLAY then
			Setting:SetPrivateString(SettingKeys.GP_USERID, "")
			Setting:SetString(SettingKeys.GP_USERNAME, "")
			EventManager:GetInstance():Broadcast(EventId.AccountBindOKEvent,"gp")
		elseif self.param.bindType == BIND_TYPE.CUSTOM then
			Setting:SetString(SettingKeys.CUSTOM_UID, "")
			EventManager:GetInstance():Broadcast(EventId.AccountBindOKEvent,"cu")
		elseif self.param.bindType == BIND_TYPE.APPSTORE then
			Setting:SetPrivateString(SettingKeys.GP_USERID, "")
			Setting:SetString(SettingKeys.GP_USERNAME, "")
			EventManager:GetInstance():Broadcast(EventId.AccountBindOKEvent,"gp")
		end
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
	end
end

UserBindManager.__init = __init
UserBindManager.__delete = __delete
UserBindManager.UserBindHandle = UserBindHandle
UserBindManager.ChangeAccountSecondOKCallback = ChangeAccountSecondOKCallback
UserBindManager.UserBindCancelHandle = UserBindCancelHandle
UserBindManager.SetParam = SetParam

return UserBindManager