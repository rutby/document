---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/2/1 15:29
---
local UIHeroTipView = require "UI.UIHero2.UIHeroTip.View.UIHeroTipView"
local SeasonGatherResItem = BaseClass("SeasonGatherResItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

-- 创建
function SeasonGatherResItem:OnCreate()
    base.OnCreate(self)
    self._des_txt = self:AddComponent(UIText,"Text_des")
    self._des_txt:SetLocalText("110479")
    self.btn = self:AddComponent(UIButton,"btn")
    self.btn:SetOnClick(function()
        self:OnGetRewardClick()
    end)
    self.res_icon_1 = self:AddComponent(UIImage,"resIcon1")
    self.res_icon_2 = self:AddComponent(UIImage,"resIcon2")
    self.res_num_1 = self:AddComponent(UIText,"resNum1")
    self.res_num_2 = self:AddComponent(UIText,"resNum2")
    --self.red_dot = self:AddComponent(UIBaseContainer,"img/red_dot")
    self.btn_detail = self:AddComponent(UIButton,"btn_detail")
    self.btn_detail:SetOnClick(function()
        self:OnDesClick()
    end)
    self.gasNum = 0
    self.flintNum = 0
    self.refreshTime = LuaEntry.DataConfig:TryGetNum("season1_desert", "k2")
    if self.refreshTime<=0 then
        self.refreshTime = 300
    end
    self.timer_action = function(temp)
        self:RefreshNum()
    end
    self.isUpdate = false
end

-- 销毁
function SeasonGatherResItem:OnDestroy()
    self:DeleteTimer()
    base.OnDestroy(self)
end

-- 显示
function SeasonGatherResItem:OnEnable()
    base.OnEnable(self)
    self:InitData()
end

-- 隐藏
function SeasonGatherResItem:OnDisable()
    base.OnDisable(self)
end
function SeasonGatherResItem:InitData()
    local iconStr1 = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Oil)
    self.res_icon_1:LoadSprite(iconStr1)
    local iconStr2 = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.FLINT)
    self.res_icon_2:LoadSprite(iconStr2)
    self:RefreshSpeed()
    self:RefreshNum()
    self.isUpdate = true
    self:AddTimer()
end

function SeasonGatherResItem:RefreshSpeed()
    self.totalGasSpeed = self.view.ctrl:GetSeasonResourceCollectSpeed(ResourceType.Oil)
    self.totalFlintSpeed = self.view.ctrl:GetSeasonResourceCollectSpeed(ResourceType.FLINT)
end

function SeasonGatherResItem:AddTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(self.refreshTime, self.timer_action , self, false,false,false)
        self.timer:Start()
    end
end

function SeasonGatherResItem:DeleteTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function SeasonGatherResItem:OnGetRewardClick()
    if (self.gasNum>=1 or self.flintNum>=1) then
        SFSNetwork.SendMessage(MsgDefines.UserCollectDesertRes)
        self.view:DoFlyRes(self.btn.gameObject.transform.position,self.gasNum,self.flintNum)
    else
        UIUtil.ShowTipsId(110481)
    end
end

function SeasonGatherResItem:RefreshNum()
    
    if self.view.isSeasonFinish~=nil and self.view.isSeasonFinish ==true then
        self.gasNum = 0
        self.flintNum = 0
        self.deltaTime = 0
    else
        local gasNum,flintNum,deltaTime = self.view.ctrl:GetCanGatherResNum(self.totalGasSpeed,self.totalFlintSpeed)
        self.gasNum = gasNum
        self.flintNum = flintNum
        self.deltaTime = deltaTime
    end
    
    if (self.gasNum>=1 or self.flintNum>=1)then
        --self.red_dot:SetActive(true)
        self.res_num_1:SetText(string.GetFormattedStr(math.floor(self.gasNum)))
        self.res_num_2:SetText(string.GetFormattedStr(math.floor(self.flintNum)))
    else
        self.res_num_1:SetText("0")
        self.res_num_2:SetText("0")
        --self.red_dot:SetActive(false)
    end
end
function SeasonGatherResItem:OnDesClick()
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.btn_detail.gameObject.transform.position + Vector3.New(20, 0, 0) * scaleFactor
    local param = UIHeroTipView.Param.New()
    param.content = Localization:GetString("110483")
    
    param.dir = UIHeroTipView.Direction.RIGHT
    param.defWidth = 300
    param.pivot = 0.3
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end
return SeasonGatherResItem