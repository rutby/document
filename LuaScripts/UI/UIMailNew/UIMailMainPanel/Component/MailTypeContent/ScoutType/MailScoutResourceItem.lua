local MailScoutReosurceItem = BaseClass("MailScoutReosurceItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local this_path = "clickBtn"
local resource_icon_path = "clickBtn/ItemIcon"
local ImgQuality_path = "clickBtn/ImgQuality"
local FlagGo_path = "clickBtn/FlagGo"
local resource_count_path = "clickBtn/NumText"

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


--控件的定义
local function ComponentDefine(self)
    self.BtnN = self:AddComponent(UIButton, this_path)
    self.BtnN:SetOnClick(function()
        self:OnClick()
    end)
    self.ResourceIconN = self:AddComponent(UIImage, resource_icon_path)
    self.ImgQualityN = self:AddComponent(UIImage, ImgQuality_path)
    self.FlagGoN = self:AddComponent(UIImage, FlagGo_path)
    self.ResourceIconN:SetActive(true)
    self.ImgQualityN:SetActive(false)
    self.FlagGoN:SetActive(false)
    self.ResourceCountN = self:AddComponent(UITextMeshProUGUIEx, resource_count_path)
end

--控件的销毁
local function ComponentDestroy(self)
    self.BtnN = nil
    self.ResourceIconN = nil
    self.ResourceCountN = nil
end

--变量的定义
local function DataDefine(self)
    self.type = 0
    self.value = 0
end

--变量的销毁
local function DataDestroy(self)
    self.type = nil
    self.value = nil
end

local function RefreshData(self, resourceData)
    self.type = type(resourceData.type) == "number" and resourceData.type or resourceData.type.value
    self.value = type(resourceData.value) == "number" and resourceData.value or resourceData.value.value
    self.ResourceIconN:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(self.type))
    self.ResourceCountN:SetText(string.GetFormattedStr(self.value))
end

local function OnClick(self)
    if self.type == ResourceType.FarmBox then
        local param = {}
        param.type = "desc"
        param.title = ""
        param.desc = Localization:GetString("300143")
        param.alignObject = self.ResourceIconN
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
end

MailScoutReosurceItem.OnCreate = OnCreate
MailScoutReosurceItem.OnDestroy = OnDestroy
MailScoutReosurceItem.OnEnable = OnEnable
MailScoutReosurceItem.OnDisable = OnDisable
MailScoutReosurceItem.ComponentDefine = ComponentDefine
MailScoutReosurceItem.ComponentDestroy = ComponentDestroy
MailScoutReosurceItem.DataDefine = DataDefine
MailScoutReosurceItem.DataDestroy = DataDestroy

MailScoutReosurceItem.RefreshData = RefreshData
MailScoutReosurceItem.OnClick = OnClick

return MailScoutReosurceItem
