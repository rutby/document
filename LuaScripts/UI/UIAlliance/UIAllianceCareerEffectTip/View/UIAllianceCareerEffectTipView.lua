---
--- Created by shimin.
--- DateTime: 2022/3/14 18:53
---

local UIAllianceCareerEffectTipView = BaseClass("UIAllianceCareerEffectTipView", UIBaseView)
local base = UIBaseView

local panel_path = "Panel"
local name_text_path = "Root/TextSkillName"
local des_text_path = "Root/TextSkillDesc"
local require_title_text_path = "Root/TextSubTitle2"
local require_text_path = "Root/TextUnlock"
local lock_desc_path = "Root/LockDesc"
local root_anim_path = "Root"
local arrow_go_path = "Root/ImgArrow"

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.name_text = self:AddComponent(UIText, name_text_path)
    self.des_text = self:AddComponent(UIText, des_text_path)
    self.require_title_text = self:AddComponent(UIText, require_title_text_path)
    self.require_text = self:AddComponent(UIText, require_text_path)
    self.lock_desc_text = self:AddComponent(UIText, lock_desc_path)
    self.lock_desc_text:SetLocalText(395016)
    self.root_anim = self:AddComponent(UIAnimator, root_anim_path)
    self.arrow_go = self:AddComponent(UIBaseContainer, arrow_go_path)
    self.panel = self:AddComponent(UIButton, panel_path)
    self.panel:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
end

local function ComponentDestroy(self)
    self.name_text = nil
    self.des_text = nil
    self.require_title_text = nil
    self.require_text = nil
    self.lock_desc_text = nil
    self.root_anim = nil
    self.arrow_go = nil
    self.panel = nil
end


local function DataDefine(self)
    self.param = nil
end

local function DataDestroy(self)
    self.param = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self)
    self.param = self:GetUserData()
    self.name_text:SetText(self.param.name == nil and "" or self.param.name)
    self.des_text:SetText(self.param.des == nil and "" or self.param.des)
    self.require_title_text:SetText(self.param.requireTitle == nil and "" or self.param.requireTitle)
    local str = ""
    if self.param.require ~= nil then
        for k,v in ipairs(self.param.require) do
            if str == "" then
                str = v
            else
                str = str .. "\n" .. v
            end
        end
    end
    self.require_text:SetText(str)
    self.lock_desc_text:SetActive(self.param.isLock)

    local dir = self.param.dir
    local pivot = self.param.pivot
    local rootRt = self.root_anim.rectTransform
    local arrowRt = self.arrow_go.rectTransform
    if dir == UITipDirection.ABOVE then
        rootRt.pivot = Vector2.New(pivot, 0)
        arrowRt.localRotation = Quaternion.Euler(0, 0, 90)
        arrowRt.anchorMin = Vector2.New(pivot, 0)
        arrowRt.anchorMax = Vector2.New(pivot, 0)
        arrowRt.anchoredPosition = Vector2.New(0, 8)
    elseif dir == UITipDirection.BELOW then
        rootRt.pivot = Vector2.New(pivot, 1)
        arrowRt.localRotation = Quaternion.Euler(0, 0, -90)
        arrowRt.anchorMin = Vector2.New(pivot, 1)
        arrowRt.anchorMax = Vector2.New(pivot, 1)
        arrowRt.anchoredPosition = Vector2.New(0, -8)
    elseif dir == UITipDirection.RIGHT then
        rootRt.pivot = Vector2.New(0, pivot)
        arrowRt.localRotation = Quaternion.Euler(0, 0, 0)
        arrowRt.anchorMin = Vector2.New(0, pivot)
        arrowRt.anchorMax = Vector2.New(0, pivot)
        arrowRt.anchoredPosition = Vector2.New(9, 0)
    elseif dir == UITipDirection.LEFT then
        rootRt.pivot = Vector2.New(1, pivot)
        arrowRt.localRotation = Quaternion.Euler(0, 0, 180)
        arrowRt.anchorMin = Vector2.New(1, pivot)
        arrowRt.anchorMax = Vector2.New(1, pivot)
        arrowRt.anchoredPosition = Vector2.New(-9, 0)
    end
    rootRt.position = self.param.position
    self.root_anim:Play("CommonPopup_movein", 0, 0)
end

local function OnAddListener(self)
    base.OnAddListener(self)

end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

UIAllianceCareerEffectTipView.OnCreate= OnCreate
UIAllianceCareerEffectTipView.OnDestroy = OnDestroy
UIAllianceCareerEffectTipView.ComponentDefine = ComponentDefine
UIAllianceCareerEffectTipView.ComponentDestroy = ComponentDestroy
UIAllianceCareerEffectTipView.DataDefine = DataDefine
UIAllianceCareerEffectTipView.DataDestroy = DataDestroy
UIAllianceCareerEffectTipView.OnEnable = OnEnable
UIAllianceCareerEffectTipView.OnDisable = OnDisable
UIAllianceCareerEffectTipView.OnAddListener = OnAddListener
UIAllianceCareerEffectTipView.OnRemoveListener = OnRemoveListener
UIAllianceCareerEffectTipView.ReInit = ReInit

return UIAllianceCareerEffectTipView

