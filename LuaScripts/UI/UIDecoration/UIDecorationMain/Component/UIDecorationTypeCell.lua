---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/12/5 12:07
---


local UIDecorationTypeCell = BaseClass("UIDecorationTypeCell", UIBaseContainer)
local base = UIBaseContainer

local select_path = "Selected"
local select_icon_path = "Selected/SelectedImgTabIcon"
local select_name_path = "Selected/SelectedTextTab"

local normal_path = "Normal"
local normal_icon_path = "Normal/NormalImgTabIcon"
local normal_name_path = "Normal/NormalTextTab"

local btn_path = ""
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
    self.select = self:AddComponent(UIBaseContainer, select_path)
    self.select_icon = self:AddComponent(UIImage, select_icon_path)
    self.select_name = self:AddComponent(UITextMeshProUGUIEx, select_name_path)

    self.normal = self:AddComponent(UIBaseContainer, normal_path)
    self.normal_icon = self:AddComponent(UIImage, normal_icon_path)
    self.normal_name = self:AddComponent(UITextMeshProUGUIEx, normal_name_path)

    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:ClickBtn()
    end)
end

local function ComponentDestroy(self)

end

local function DataDefine(self)

end

local function DataDestroy(self)

end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self, data, currentSelect)
    self.data = data
    self.currentSelect = currentSelect
    self:RefreshView()
end

local function RefreshView(self)
    self.normal:SetActive(self.data.id ~= self.currentSelect)
    self.select:SetActive(self.data.id == self.currentSelect)
    if self.data.id == self.currentSelect then
        self.select_icon:LoadSprite(self.data.icon2)
        self.select_name:SetLocalText(self.data.name)
    else
        self.normal_icon:LoadSprite(self.data.icon1)
        self.normal_name:SetLocalText(self.data.name)
    end
end

local function ClickBtn(self)
    --if self.data.callBack ~= nil then
    --    self.data.callBack(self.data.id)
    --end
    self.view:SetCurrentType(self.data.id)
end

UIDecorationTypeCell.OnCreate = OnCreate
UIDecorationTypeCell.OnDestroy = OnDestroy
UIDecorationTypeCell.OnEnable = OnEnable
UIDecorationTypeCell.OnDisable = OnDisable
UIDecorationTypeCell.ComponentDefine = ComponentDefine
UIDecorationTypeCell.ComponentDestroy = ComponentDestroy
UIDecorationTypeCell.DataDefine = DataDefine
UIDecorationTypeCell.DataDestroy = DataDestroy
UIDecorationTypeCell.ReInit = ReInit
UIDecorationTypeCell.RefreshView = RefreshView
UIDecorationTypeCell.ClickBtn = ClickBtn

return UIDecorationTypeCell