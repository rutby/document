---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/11/1 15:41
---

local FormationScoutSelectTip = BaseClass("FormationScoutSelectTip", UIBaseContainer)
local base = UIBaseContainer

local content_txt_path = "Desc"
local cost_time_path = "share/Time"
local btn_txt_path = "button/InvestigateBtn/InvestigateTxt"
local elec_cost_path = "button/InvestigateBtn/Cost/CostTxt"
local btn_go_path = "button/InvestigateBtn"


-- 创建
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

-- 显示
local function OnEnable(self)
    base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end


--控件的定义
local function ComponentDefine(self)
    self.TipTxt = self:AddComponent(UITextMeshProUGUIEx, content_txt_path)
    self.CostTimeTxt = self:AddComponent(UITextMeshProUGUIEx, cost_time_path)
    self.BtnTxt = self:AddComponent(UITextMeshProUGUIEx, btn_txt_path)
    self.BtnTxt:SetLocalText(110003) 
    self.ElecCostTxt = self:AddComponent(UITextMeshProUGUIEx, elec_cost_path)
    self.InvestigateBtn = self:AddComponent(UIButton, btn_go_path)
    self.InvestigateBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickStartInvestigate()
    end)
end

--控件的销毁
local function ComponentDestroy(self)
    self.TipTxt = nil
    self.CostTimeTxt = nil
    self.BtnTxt = nil
    self.ElecCostTxt = nil
    self.InvestigateBtn = nil
end

--变量的定义
local function DataDefine(self)
    self.targetPointId = nil
    self.curSelectedIndex = nil
end

--变量的销毁
local function DataDestroy(self)
    self.targetPointId = nil
    self.curSelectedIndex = nil
end

local function InitUI(self, targetPointId, tempIndex)
    self.curSelectedIndex = tempIndex
    self.targetPointId = targetPointId
    local elecCost = self.view.ctrl:GetElecCost(self.targetPointId, self.curSelectedIndex)
    self.ElecCostTxt:SetText(elecCost)
    
    local stateTip = self.view:GetInvesFormationStateDes()
    self.TipTxt:SetLocalText(stateTip) 
    
    local timeCost = self.view:GetInvesCostTime(self.targetPointId)
    self.CostTimeTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(timeCost*1000))

end

local function RefreshUI(self, tempIndex)
    self.curSelectedIndex = tempIndex
    
    local elecCost = self.view.ctrl:GetElecCost(self.targetPointId, self.curSelectedIndex)
    self.ElecCostTxt:SetText(elecCost)
    --状态
    local stateTip = self.view:GetInvesFormationStateDes()
    self.TipTxt:SetLocalText(stateTip) 
    --消耗时间
    local timeCost = self.view:GetInvesCostTime(self.targetPointId)
    self.CostTimeTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(timeCost*1000))
end

local function ResetCosts(self, realCost, timeRealCost)
    self.ElecCostTxt:SetText(realCost)
    self.CostTimeTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(timeRealCost*1000))
end

local function OnClickStartInvestigate(self)
    self.view:OnClickStartInvestigate(self.targetPointId)
end



FormationScoutSelectTip.OnCreate = OnCreate
FormationScoutSelectTip.OnDestroy = OnDestroy
FormationScoutSelectTip.OnEnable = OnEnable
FormationScoutSelectTip.OnDisable = OnDisable
FormationScoutSelectTip.ComponentDefine = ComponentDefine
FormationScoutSelectTip.ComponentDestroy = ComponentDestroy
FormationScoutSelectTip.DataDefine = DataDefine
FormationScoutSelectTip.DataDestroy = DataDestroy
FormationScoutSelectTip.OnAddListener = OnAddListener
FormationScoutSelectTip.OnRemoveListener = OnRemoveListener

FormationScoutSelectTip.InitUI = InitUI
FormationScoutSelectTip.RefreshUI = RefreshUI
FormationScoutSelectTip.OnClickStartInvestigate = OnClickStartInvestigate
FormationScoutSelectTip.ResetCosts = ResetCosts

return FormationScoutSelectTip