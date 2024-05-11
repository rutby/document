---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/3/27 17:19
---

local UIDesertOperateItem = BaseClass("UIDesertOperateItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local icon_path = "Icon"
local mask_path = "Icon/Mask"
local mask_desc_bg_path = "Icon/Mask/MaskDescBg"
local mask_desc_path = "Icon/Mask/MaskDescBg/MaskDesc"
local title_path = "Title"
local desc_path = "Desc"
local btn_path = "Btn"
local btn_text_path = "Btn/BtnText"
local btn_detail_path = "Title/btn_detail"
local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.icon_image = self:AddComponent(UIImage, icon_path)
    self.mask_image = self:AddComponent(UIImage, mask_path)
    self.mask_desc_bg_go = self:AddComponent(UIBaseContainer, mask_desc_bg_path)
    self.mask_desc_text = self:AddComponent(UIText, mask_desc_path)
    self.title_text = self:AddComponent(UIText, title_path)
    self.desc_text = self:AddComponent(UIText, desc_path)
    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function()
        self:OnClick()
    end)
    self.btn_text = self:AddComponent(UIText, btn_text_path)
    self.btn_detail = self:AddComponent(UIButton, btn_detail_path)
    self.btn_detail:SetOnClick(function()
        self:OnBtnDetailClick()
    end)
    self.btn_detail:SetActive(false)
end

local function ComponentDestroy(self)
    self.icon_image = nil
    self.mask_image = nil
    self.mask_desc_bg_go = nil
    self.mask_desc_text = nil
    self.title_text = nil
    self.desc_text = nil
    self.btn = nil
    self.btn_text = nil
end

local function DataDefine(self)
    self.op = nil
end

local function DataDestroy(self)
    self.op = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function SetData(self, op)
    self.op = op
    self:Refresh()
end

local function Refresh(self)
    self.icon_image:LoadSprite(self.op:GetIcon())
    self.title_text:SetText(self.op:GetTitle())
    self.desc_text:SetText(self.op:GetDesc())
    self.btn_text:SetText(self.op:GetBtnText())
    if self.op.masteryId~=nil and self.op.masteryId~=0 then
        self.btn_detail:SetActive(true)
    else
        self.btn_detail:SetActive(false)
    end
    self:SetBtnState(self.op:GetBtnState())

    self:TimerAction()
end

local function TimerAction(self)
    local maskPercent = self.op:GetMaskPercent()
    if maskPercent == 0 then
        self.mask_image:SetActive(false)
    else
        self.mask_image:SetActive(true)
        self.mask_image:SetFillAmount(maskPercent)
        local maskDesc = self.op:GetMaskDesc()
        if string.IsNullOrEmpty(maskDesc) then
            self.mask_desc_bg_go:SetActive(false)
        else
            self.mask_desc_bg_go:SetActive(true)
            self.mask_desc_text:SetText(maskDesc)
        end
    end
    self.op:TimerAction(self.view, self)
end

local function SetBtnState(self, btnState)
    self.btn:SetActive(btnState ~= DesertOperateBtnState.None)
    if btnState == DesertOperateBtnState.Green then
        self.btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_green101"))
        UIGray.SetGray(self.btn.transform, false, true)
    elseif btnState == DesertOperateBtnState.Yellow then
        self.btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_yellow101"))
        UIGray.SetGray(self.btn.transform, false, true)
    elseif btnState == DesertOperateBtnState.Gray then
        self.btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_yellow101"))
        UIGray.SetGray(self.btn.transform, true, false)
    end
end

local function SetBtnText(self, text)
    self.btn_text:SetText(text)
end

local function OnClick(self)
    self.op:OnClick(self.view, self)
end

local function OnBtnDetailClick(self)
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.btn_detail.gameObject.transform.position  + Vector3.New(210, -50, 0) * scaleFactor
    local endTime = 0
    -- + Vector3.New(-19, 30, 0) * scaleFactor
    local curNum = DataCenter.DesertOperateManager:GetCurDesertMineCount()
    local maxNum = DataCenter.DesertOperateManager:GetMaxMineCount()

    local title = Localization:GetString("111217",(math.floor(curNum).."/"..math.floor(maxNum)))
    local k3 = LuaEntry.DataConfig:TryGetNum("desert_talent_mine", "k3")
    local content0 = Localization:GetString("111218",math.floor(k3/60))
    local content1 = Localization:GetString("111219","")
    local content2 = Localization:GetString("111220")
    if curNum < maxNum and self.op.endTime~=nil and self.op.endTime > 0 then
        endTime = self.op.endTime
    end
    local param = {}
    param.title = title
    param.content0 = content0
    param.content1 = content1
    param.content2 = content2
    param.endTime = endTime
    param.position = position
    param.isLeft  = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationTip, { anim = false }, param)
end

UIDesertOperateItem.OnCreate = OnCreate
UIDesertOperateItem.OnDestroy = OnDestroy
UIDesertOperateItem.ComponentDefine = ComponentDefine
UIDesertOperateItem.ComponentDestroy = ComponentDestroy
UIDesertOperateItem.DataDefine = DataDefine
UIDesertOperateItem.DataDestroy = DataDestroy
UIDesertOperateItem.OnEnable = OnEnable
UIDesertOperateItem.OnDisable = OnDisable
UIDesertOperateItem.OnAddListener = OnAddListener
UIDesertOperateItem.OnRemoveListener = OnRemoveListener

UIDesertOperateItem.SetData = SetData
UIDesertOperateItem.Refresh = Refresh
UIDesertOperateItem.TimerAction = TimerAction
UIDesertOperateItem.SetBtnState = SetBtnState
UIDesertOperateItem.SetBtnText = SetBtnText

UIDesertOperateItem.OnClick = OnClick
UIDesertOperateItem.OnBtnDetailClick = OnBtnDetailClick
return UIDesertOperateItem