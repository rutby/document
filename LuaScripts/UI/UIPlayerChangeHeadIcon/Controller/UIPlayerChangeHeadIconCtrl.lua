
local UIPlayerChangeHeadIconCtrl = BaseClass("UIPlayerChangeHeadIconCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization


local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerChangeHeadIcon)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitData(self,uid)
    if uid ~=nil then
        self.uid = uid
    else
        self.uid = LuaEntry.Player.uid
    end
 --   SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo,self:GetUid())
    
end
local function GetUid(self)
    return self.uid
end
--得到全部的list信息
local function GetAllHeadIconInfo()
    local showList = {}
    for i = 1, 3 do
        local data = {} 
        data.id = i
        data.picName = "player_head_"..i
        showList[i] = data
    end
    return showList
end


local function OnGotoClick(self,id)
    if id == 1 then
        --Logger.LogError(" 弹出照相界面")
        if LuaEntry.Player.modfiyPicStatus == true then
            --检查自定义头像上传cd
            local timeStamp = tonumber(Setting:GetPrivateString("nextUpdateHeadPicTime", "0"))
            local now = UITimeManager:GetInstance():GetServerTime()
            local leftMin = math.ceil((timeStamp - now) / 60000) 
            if leftMin > 0 then
                UIUtil.ShowTips(Localization:GetString('280066', leftMin))
                return
            end

            UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerHeadIconSelect,{anim = true},uuid)
        else
            UIUtil.ShowMessage(Localization:GetString("320301"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL,function()
                local isOpen = LuaEntry.DataConfig:CheckSwitch("first_pay_choosen") -- 开关
                if isOpen then
                    local k1 = LuaEntry.DataConfig:TryGetNum("first_pay_choosen", "k3")
                    if DataCenter.BuildManager.MainLv >= k1 then
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFirstCharge, { anim = true, UIMainAnim = UIMainAnimType.AllHide })
                    else
                        UIUtil.ShowTipsId(320190)
                    end
                else
                    if not DataCenter.PayManager:CheckIfFirstPayOpen() then
                        UIUtil.ShowTipsId(320190)
                        return
                    end
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFirstPay, { anim = false, UIMainAnim = UIMainAnimType.AllHide })
                end
            end, function()
            end)
        end
    else
      --  Logger.LogError(" 点击头像按钮")
    end

end

local function OnPhotoClick(self)
   -- Logger.LogError(" 点击相册按钮")
end
local function OnCameraClick(self)
   -- Logger.LogError(" 点击照相机按钮")
end
--更换头像
local function OnUseClick(self,picName)

	UIUtil.ShowMessage(Localization:GetString("129002"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
			SFSNetwork.SendMessage(MsgDefines.UserChangePic,picName)
		end)
end

local function OnFrameClick(self)
    DecorationUtil.OpenDecorationPanel(DecorationType.DecorationType_Head_Frame)
end

UIPlayerChangeHeadIconCtrl.CloseSelf = CloseSelf
UIPlayerChangeHeadIconCtrl.Close = Close
UIPlayerChangeHeadIconCtrl.InitData =InitData
UIPlayerChangeHeadIconCtrl.GetAllHeadIconInfo =GetAllHeadIconInfo
UIPlayerChangeHeadIconCtrl.GetUid = GetUid
UIPlayerChangeHeadIconCtrl.OnGotoClick = OnGotoClick
UIPlayerChangeHeadIconCtrl.OnPhotoClick = OnPhotoClick
UIPlayerChangeHeadIconCtrl.OnCameraClick = OnCameraClick
UIPlayerChangeHeadIconCtrl.OnUseClick = OnUseClick
UIPlayerChangeHeadIconCtrl.OnFrameClick = OnFrameClick

return UIPlayerChangeHeadIconCtrl