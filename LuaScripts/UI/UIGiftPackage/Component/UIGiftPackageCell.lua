--[[
    礼包
--]]

local UIGiftItem = require "UI.UIGiftPackage.Component.UIGiftItem"
local UIGiftPackageCell = BaseClass("UIGiftPackageCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local item_path = "IconNode/UIGiftItem"
local item_name_path = "TxtName"
local item_num_path = "TxtNum"

local Param = DataClass("Param", ParamData)
local ParamData =  {
    itemId,
    count,
    --联盟礼物
    iconName,
    itemName,
    itemDes,
    itemColor,
   -- 英雄部分
    heroId,
}

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


--控件的定义
local function ComponentDefine(self)
	self.item = self:AddComponent(UIGiftItem, item_path)
	self.item_name = self:AddComponent(UITextMeshProUGUIEx, item_name_path)
	self.item_num = self:AddComponent(UITextMeshProUGUIEx, item_num_path)
end

--控件的销毁
local function ComponentDestroy(self)
	self.item = nil
	self.item_name = nil
	self.item_num = nil
end

--变量的定义
local function DataDefine(self)
	self.param = {}
    self.itemName = ""
    self.itemNum = ""
end

--变量的销毁
local function DataDestroy(self)
	self.param = nil
    self.itemName = nil
    self.itemNum = nil
end

local function ReInit(self, ...)
    self.param = ...
    if self.param.count ~= nil then
        self:SetItemNum(self.param.count)
    end
    
    if self.param.itemId == nil then
        if self.param.itemName ~= nil then -- 联盟礼物
            self:SetItemName(Localization:GetString(self.param.itemName))
        elseif self.param.heroId ~= nil then -- 英雄
            local heroName = HeroUtils.GetHeroNameByConfigId(self.param.heroId)
            self:SetItemName(heroName)
            self.item:ReInit({heroConfigId = self.param.heroId})
            return
        end
    else
        self:SetItemName(DataCenter.ItemTemplateManager:GetName(self.param.itemId))
    end
    self.item:ReInit({itemId = self.param.itemId,iconName = self.param.iconName, itemColor = self.param.itemColor,itemName = self.param.itemName
    ,itemDes = self.param.itemDes})
end


local function OnItemClick(self, userdata, tf)
	
end

local function SetItemName(self,value)
    if self.itemName ~= value then
        self.itemName = value
        self.item_name:SetText(value)
    end 
end

local function SetItemNum(self,value)
    if self.itemNum ~= value then
        self.itemNum = value
        self.item_num:SetText(value)
    end
end


UIGiftPackageCell.OnCreate = OnCreate
UIGiftPackageCell.OnDestroy = OnDestroy
UIGiftPackageCell.ReInit = ReInit
UIGiftPackageCell.ComponentDefine = ComponentDefine
UIGiftPackageCell.ComponentDestroy = ComponentDestroy
UIGiftPackageCell.DataDefine = DataDefine
UIGiftPackageCell.DataDestroy = DataDestroy
UIGiftPackageCell.Param = Param
UIGiftPackageCell.OnItemClick = OnItemClick
UIGiftPackageCell.SetItemName = SetItemName
UIGiftPackageCell.SetItemNum = SetItemNum


return UIGiftPackageCell 