--[[
UIGiftTypeButton
--]]

local UIGiftTypeButton = BaseClass("UIGiftTypeButton", UIBaseContainer)
local base = UIBaseContainer

local type_text_path = "text"
local typeS_text_path = "checkText"
-- local icon_path = "Icon"
local this_path = "";
local red_dot_path = "RedDot"
local red_dot_text_path = "RedDot/RedDotText"
local NewDot_path = "NewDot"

local NormalSize = Vector2.New(219, 85)
local SelectSize = Vector2.New(219, 85)
local NormalBg = "Assets/Main/Sprites/UI/Common/New/Common_btn_tab_down"
local SelectBg = "Assets/Main/Sprites/UI/Common/New/Common_btn_tab_up"

local function OnCreate(self)
    base.OnCreate(self)

    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()

    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.type_text = self:AddComponent(UITextMeshProUGUIEx, type_text_path)
    self.typeS_text = self:AddComponent(UITextMeshProUGUIEx, typeS_text_path)
    -- self.icon_image = self:AddComponent(UIImage, icon_path)
    self.btn = self:AddComponent(UIButton, this_path)
    self.image = self:AddComponent(UIImage, this_path)

    self.btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClick()
    end)
    
    self.red_dot_go = self:AddComponent(UIBaseContainer, red_dot_path)
    self.red_dot_text = self:AddComponent(UIText, red_dot_text_path)
    self.NewDot = self:AddComponent(UIBaseContainer, NewDot_path)
end

local function ComponentDestroy(self)
    self.type_text = nil
    self.typeS_text = nil
    self.btn = nil
    self.image = nil
    self.red_dot_go = nil
    self.red_dot_text = nil
    self.NewDot = nil
end

local function DataDefine(self)
    self.typeText = nil
    self.typeColor = nil
end

local function DataDestroy(self)
    self.typeText = nil
    self.typeColor = nil
end

local function ReInit(self,...) 
    self.param = ...
    if self.param == nil then
        self.gameObject:SetActive(false)
        return
    end
    self:Refresh()
    if self.param.needClick then
        self:SetSelect(true)
        --self.icon_image:SetLocalScaleXYZ(1,1,1)
        -- self.icon_image:SetActive(true)
        self:OnClick()
    else
        self:SetSelect(false)
        -- self.icon_image:SetActive(false)
        --self.icon_image:SetLocalScaleXYZ(0.85,0.85,0.85)
    end
end

local function Refresh(self)
    local data = self.param.welfare_data
    self.type_text:SetLocalText(data:getName())
    self.typeS_text:SetLocalText(data:getName())
    -- self.icon_image:SetActive(false)
    -- self.icon_image:LoadSprite(string.format(LoadPath.UIGiftPackage, GetTableData("recharge", data:getID(), "tab_icon")))
    self:SetRedDot(self.param.redDotNum, self.param.newFlag)
end

local function OnClick(self)
    if self.param.callBack ~= nil then
        self.param.callBack(self.transform, self.param.welfare_data:getType(), self.param.welfare_data:getID(), self.param.index)
    end
end

local function SetSelect(self,value)
    self.rectTransform.sizeDelta = value and SelectSize or NormalSize
    self.image:LoadSprite(value and SelectBg or NormalBg)
    self.type_text:SetActive(not value)
    self.typeS_text:SetActive(value)
    -- self.icon_image:SetActive(value and true or false)
end

local function SetRedDot(self, redDotNum, newFlag)
    self.NewDot:SetActive(newFlag == true)
    if redDotNum == nil or redDotNum == 0 or newFlag then
        self.red_dot_go:SetActive(false)
    else
        self.red_dot_go:SetActive(true)
        self.red_dot_text:SetText(redDotNum)
    end
end

UIGiftTypeButton.OnDestroy = OnDestroy
UIGiftTypeButton.OnCreate = OnCreate
UIGiftTypeButton.OnClick = OnClick
UIGiftTypeButton.Refresh = Refresh
UIGiftTypeButton.ReInit = ReInit
UIGiftTypeButton.ComponentDefine = ComponentDefine
UIGiftTypeButton.ComponentDestroy = ComponentDestroy
UIGiftTypeButton.DataDefine = DataDefine
UIGiftTypeButton.DataDestroy = DataDestroy
UIGiftTypeButton.SetSelect = SetSelect
UIGiftTypeButton.SetRedDot = SetRedDot

return UIGiftTypeButton