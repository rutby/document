---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/11/9 17:29
---
local UICommonMessageBarView = BaseClass("UICommonMessageBarView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local text_path = "Panel/gain/Text"
local return_btn_path = "Panel"
--local image_path ="Panel/layout1/Image"
local function OnCreate(self)
    base.OnCreate(self)
    --local msg,img,atlas = self:GetUserData()
    --self.msg = msg
    --self.img =img
    self.des_txt = self:AddComponent(UIText,text_path)
    --self.image = self:AddComponent(UIImage,image_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    self.timeDelta =0
    self.timer = nil
    self.timer_action = function(temp)
        self:RefreshTime()
    end
    self:AddTimer()
    self:RefreshData()
end

local function OnDestroy(self)
    self.msg = nil
    --self.img =nil
    self.des_txt = nil
    self.return_btn = nil
    self.timeDelta = nil
    self.timer_action = nil
    self.msgQueue = nil
    self.isPlaying = nil
    self:DeleteTimer()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)

    self.isPlaying = false
end
local function SetData(self,msg,img,showType)
    if not self.msgQueue then
        self.msgQueue = {}
    end
    local newMsg = {
        showType = showType,
        msg = msg,
    }
    table.insert(self.msgQueue, newMsg)
end

local function RefreshData(self)
    self:DisplayNext()
end

local function DisplayNext(self)
    local msg = nil
    local showType = nil
    if self.msgQueue and table.count(self.msgQueue) > 0 then
        msg = self.msgQueue[1].msg
        showType = self.msgQueue[1].showType
        self.timeDelta = 0
        table.remove(self.msgQueue, 1)
        self.isPlaying = true
    else
        self.ctrl:CloseSelf()
        return
    end
    
    if msg~=nil and msg~="" then
        self.des_txt:SetText(msg)
    else
        self.des_txt:SetLocalText(100378) 
    end
    if showType~=nil then
        if showType == MessageBarType.Cost then
            self.des_txt:SetColor(MessageBarCostColor)
        elseif showType == MessageBarType.Lack then
            self.des_txt:SetColor(MessageBarLackColor)
        else
            self.des_txt:SetColor(MessageBarGetColor)
        end
    else
        self.des_txt:SetColor(MessageBarGetColor)
    end
    --if self.img~=nil and self.img~="" then
    --    self.image:SetActive(true)
    --    self.image:LoadSprite(self.img)
    --else
    --    self.image:SetActive(false)
    --end
end

local function DeleteTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

local function AddTimer(self)
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self, false,false,false)
    end

    self.timer:Start()
end

local function RefreshTime(self)
    self.timeDelta = self.timeDelta+1
    if self.timeDelta>2 then
        if self.msgQueue and table.count(self.msgQueue) > 0 then
            self:DisplayNext()
        else
            self.ctrl:CloseSelf()
        end
    end
end

UICommonMessageBarView.OnCreate = OnCreate
UICommonMessageBarView.OnDestroy = OnDestroy
UICommonMessageBarView.OnEnable = OnEnable
UICommonMessageBarView.OnDisable = OnDisable
UICommonMessageBarView.SetData =SetData
UICommonMessageBarView.RefreshData =RefreshData
UICommonMessageBarView.DeleteTimer =DeleteTimer
UICommonMessageBarView.AddTimer =AddTimer
UICommonMessageBarView.RefreshTime =RefreshTime
UICommonMessageBarView.DisplayNext =DisplayNext
return UICommonMessageBarView