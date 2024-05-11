
---@class DispatchTaskStarTip : UIBaseContainer
local DispatchTaskStarTip = BaseClass("DispatchTaskStarTip",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local DispatchTaskStarTipItem = require "UI.UIActivityCenterTable.Component.DispatchTask.DispatchTaskStarTipItem"

local from_path = "TipBox/from"
local to_path = "TipBox/to"
local condition_text_path = "TipBox/condition/conditionText"
local btn_close_tip_path = "BtnCloseTip"

function DispatchTaskStarTip:OnCreate()
    base.OnCreate(self)
    self.tip_root = self:AddComponent(UICanvasGroup, "")
    self.from = self:AddComponent(DispatchTaskStarTipItem, from_path)
    self.to = self:AddComponent(DispatchTaskStarTipItem, to_path)
    self.desc_txt = self:AddComponent(UITextMeshProUGUIEx,"TipBox/DescText")
    self.desc_txt:SetLocalText(140024)
    self.condition_text = self:AddComponent(UITextMeshProUGUIEx, condition_text_path)
    self.btn_close_tip = self:AddComponent(UIButton, btn_close_tip_path)
    self.btn_close_tip:SetOnClick(function()
        self.tip_root:SetAlpha(0)
        self.tip_root:SetActive(false)
    end)
    self.tip_root:SetAlpha(0)
    self.tip_root:SetActive(false)
end

function DispatchTaskStarTip:OnDestroy()
    base.OnDestroy(self)
end

function DispatchTaskStarTip:ShowIt()
    local starLevel = DataCenter.ActDispatchTaskDataManager:GetCurrentStarLevel()
    if starLevel < 1 or starLevel >= 5 then
        -- 456279
        UIUtil.ShowTipsId(461065)
        return
    end
    local cityLevel = DataCenter.ActDispatchTaskDataManager:GetMinLevelForStarLevel(starLevel + 1)
    -- 456285=基地等级
    -- 390922={0}达到Lv.{1}
    local str = Localization:GetString('390900', Localization:GetString('470094'), cityLevel)
    self.condition_text:SetText(str)
    self.from:ReInit(starLevel)
    self.to:ReInit(starLevel + 1)
    self.tip_root:SetAlpha(1)
    self.tip_root:SetActive(true)
    --self.tip_root:FadeIn(0.2)
end

return DispatchTaskStarTip
