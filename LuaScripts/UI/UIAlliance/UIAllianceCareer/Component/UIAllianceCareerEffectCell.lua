---
--- Created by shimin.
--- DateTime: 2022/3/11 16:27
--- 联盟职业每一个属性效果cell
---

local UIAllianceCareerEffectCell = BaseClass("UIAllianceCareerEffectCell",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local TipDelta = Vector3.New(0, -70, 0)
local TWEEN_NUM_DURATION = 0.425
local TWEEN_NUM_DELAY = 0.3
local TWEEN_NUM_SCALE = 1.2

local this_path = ""
local bg_path = "Bg"
local icon_path = "Icon"
local name_text_path = "NameBg/EffectValue"

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.btn = self:AddComponent(UIButton, this_path)
    self.bg = self:AddComponent(UIImage, bg_path)
    self.icon = self:AddComponent(UIImage, icon_path)
    self.name_text = self:AddComponent(UITweenNumberText, name_text_path)
    self.btn:SetOnClick(function()
        self:OnBtnClick()
    end)
end

local function ComponentDestroy(self)
    self.btn = nil
    self.bg = nil
    self.icon = nil
    self.name_text = nil
end


local function DataDefine(self)
    self.param = nil
    self.des = ""
    self.num = nil
end

local function DataDestroy(self)
    self.param = nil
    self.des = nil
    self.num = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self,param)
    self.param = param
    
    local icon = ""
    if string.startswith(self.param.data.icon, "UITechnology") then
        icon = string.format(LoadPath.ScienceIcons,self.param.data.icon)
    else
        icon = string.format(LoadPath.UIAlliance,self.param.data.icon)
    end
    self.icon:LoadSprite(icon)
    self:SetLock(self:IsLock())
    
    self.name_text:SetDecimal(true)
    self:RefreshPanel()
end

local function OnAddListener(self)
    base.OnAddListener(self)

end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function RefreshPanel(self)
    local all = 0
    if self.param.data.description_value ~= nil then
        for k,v in pairs(self.param.data.description_value) do
            local list = DataCenter.AllianceCareerManager:GetAllianceMemberPosListByCareer(v.careerType)
            if list ~= nil then
                for k1,v1 in ipairs(list) do
                    all = all + v.num * v1.careerLv
                end
            end
        end
    end
    local use,prefix,suffix = self:GetEffectTypeStr(self.param.data.description_type, all)
    self.name_text:SetAffix(prefix, suffix)
    if self.num ~= use then
        self.num = use
        if self.des == "" then
            self.name_text:SetNum(use)
        else
            if use > self.name_text:GetTargetNum() then
                self.name_text:TweenToNum(use, TWEEN_NUM_DURATION, TWEEN_NUM_DELAY, TWEEN_NUM_SCALE)
            else
                self.name_text:TweenToNum(use, TWEEN_NUM_DURATION)
            end
        end
        self.des = prefix .. use .. suffix
    end
    self:SetLock(self:IsLock())
end

local function GetEffectTypeStr(self,desType,value)
    local prefix, suffix = "", ""
    local use = value
    local effectValueX,effectValueY = math.modf(value)
    if effectValueY == 0 then
        use = effectValueX
    end
    
    if desType == AllianceCareerEffectDescriptionType.AddPercent then
        prefix = "+"
        suffix = "%"
    elseif desType == AllianceCareerEffectDescriptionType.SubPercent then
        prefix = "-"
        suffix = "%"
    elseif desType == AllianceCareerEffectDescriptionType.AddCount then
        prefix = "+"
    elseif desType == AllianceCareerEffectDescriptionType.SubCount then
        prefix = "-"
    end
    return use, prefix, suffix
end

local function OnBtnClick(self)
    if self.param.effectCallBack ~= nil then
        local param = {}
        param.name = Localization:GetString(tostring(self.param.data.name))
        param.des = Localization:GetString(self.param.data.description, self.des)
        param.requireTitle = Localization:GetString(GameDialogDefine.ALLIANCE_CAREER_EFFECT_TITLE)
        param.require = {}
        if self.param.data.description_value ~= nil then
            for k,v in ipairs(self.param.data.description_value) do
                local str = ""
                local use,prefix,suffix = self:GetEffectTypeStr(self.param.data.description_type,v.num)
                str = str .. Localization:GetString(GameDialogDefine.ALLIANCE_CAREER_EFFECT_ADD, prefix .. use .. suffix)
                table.insert(param.require,str)
            end
        end
        local scaleFactor = UIManager:GetInstance():GetScaleFactor()
        param.position = self.transform.position + TipDelta * scaleFactor
        param.dir = UITipDirection.BELOW
        param.pivot = 0.5 + (self.param.index / self.param.count - 0.5) * 0.8
        param.isLock = self:IsLock()
        self.param.effectCallBack(param)
    end
end

local function IsLock(self)
    local myself = DataCenter.AllianceMemberDataManager:GetAllianceMemberMyself()
    return (not myself or myself.careerPos == AllianceCareerPosType.No)
end

local function SetLock(self, isLock)
    self.bg:SetColor(isLock and TabUnSelectColor or WhiteColor)
    self.icon:SetColor(isLock and TabUnSelectColor or WhiteColor)
end

UIAllianceCareerEffectCell.OnCreate = OnCreate
UIAllianceCareerEffectCell.OnDestroy = OnDestroy
UIAllianceCareerEffectCell.ComponentDefine = ComponentDefine
UIAllianceCareerEffectCell.ComponentDestroy = ComponentDestroy
UIAllianceCareerEffectCell.DataDefine = DataDefine
UIAllianceCareerEffectCell.DataDestroy = DataDestroy
UIAllianceCareerEffectCell.OnEnable = OnEnable
UIAllianceCareerEffectCell.OnDisable = OnDisable
UIAllianceCareerEffectCell.OnAddListener = OnAddListener
UIAllianceCareerEffectCell.OnRemoveListener = OnRemoveListener
UIAllianceCareerEffectCell.ReInit = ReInit
UIAllianceCareerEffectCell.RefreshPanel = RefreshPanel
UIAllianceCareerEffectCell.GetEffectTypeStr = GetEffectTypeStr
UIAllianceCareerEffectCell.OnBtnClick = OnBtnClick
UIAllianceCareerEffectCell.IsLock = IsLock
UIAllianceCareerEffectCell.SetLock = SetLock

return UIAllianceCareerEffectCell