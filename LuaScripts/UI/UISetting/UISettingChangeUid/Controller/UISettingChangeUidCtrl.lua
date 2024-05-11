---
--- Created by zzl.
--- DateTime: 
---
local rapidjson = require "rapidjson"
local UISettingChangeUidCtrl = BaseClass("UISettingChangeUidCtrl", UIBaseCtrl)
local Setting = CS.GameEntry.Setting
local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISettingChangeUid)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function OnClick(self,temp)
    local gameUid = temp
    local url = "http://gsl-ds.metapoint.club/gameservice/getuidinfo.php?gameuid="..gameUid
    CS.GameKit.Base.WebRequestManager.Instance:Get(url,function(request, err, userdata)
        if err == true then
            UIUtil.ShowMessage("no id", 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL,function()
            end, function()
            end)
            return
        end
        local text = request.downloadHandler.text
        if text==nil or text =="" then
            return
        end
        local jsonData = rapidjson.decode(text)
        local ip = tostring(jsonData["ip"])
        local port = tonumber(jsonData["port"])
        local server = tostring(jsonData["server"])
        local zone = "APS"..server
        
        Setting:SetString(SettingKeys.GAME_UID, gameUid);
        Setting:SetString(SettingKeys.UUID, "");
        Setting:SetString(SettingKeys.SERVER_IP, ip);
        Setting:SetInt(SettingKeys.SERVER_PORT, port);
        Setting:SetString(SettingKeys.SERVER_ZONE, zone);
        LuaEntry.DataConfig:ClearMd5()
        CS.GameEntry.Sound:StopAllSounds()
        CS.ApplicationLaunch.Instance:ReStartGame()
    end)
end

UISettingChangeUidCtrl.CloseSelf = CloseSelf
UISettingChangeUidCtrl.Close = Close
UISettingChangeUidCtrl.OnClick = OnClick
return UISettingChangeUidCtrl