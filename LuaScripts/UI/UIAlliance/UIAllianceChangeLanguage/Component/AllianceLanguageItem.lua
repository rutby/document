---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/11/11 15:53
---
local AllianceLanguageItem = BaseClass("AllianceLanguageItem",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local name_path = "nameTxt"
local select_obj_path = "select"
local btn_path = "Button"

local function OnCreate(self)
    base.OnCreate(self)
    self.name_txt = self:AddComponent(UITextMeshProUGUIEx,name_path)
    self.select_obj = self:AddComponent(UIBaseContainer,select_obj_path)
    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClick()
    end)
end

-- 销毁
local function OnDestroy(self)
    self.name_txt = nil
    self.select_obj = nil
    self.btn = nil
    self.param = nil
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

-- 全部刷新
local function RefreshData(self,data,language)
    self.param = data
    self.name_txt:SetLocalText(self.param) 
    self:SetSelect(self.param == language)
end

local function SetSelect(self,select)
    self.select_obj:SetActive(select)
    --if select then
    --    self.name_txt:SetColor(BlueColor)
    --else
    --    self.name_txt:SetColor(WhiteColor)
    --end
end


local function OnClick(self)
    self.view:SetCurLanguage(self.param)
end

AllianceLanguageItem.OnCreate = OnCreate
AllianceLanguageItem.SetItemShow = SetItemShow
AllianceLanguageItem.OnClick = OnClick
AllianceLanguageItem.OnDestroy = OnDestroy
AllianceLanguageItem.OnEnable = OnEnable
AllianceLanguageItem.OnDisable = OnDisable
AllianceLanguageItem.RefreshData = RefreshData
AllianceLanguageItem.SetSelect = SetSelect

return AllianceLanguageItem