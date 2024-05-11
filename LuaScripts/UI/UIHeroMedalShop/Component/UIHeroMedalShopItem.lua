-- 英雄勋章商店购买物品cell的container

local UIHeroMedalShopItem = BaseClass("UIHeroMedalShopItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroMedalShopItemCell = require "UI.UIHeroMedalShop.Component.UIHeroMedalShopItemCell"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    self.cellObjList = nil
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.cellObjList = {}
    for k = 1, 3 do
        local cell = self:AddComponent(UIHeroMedalShopItemCell, 'shopCell' .. k)
        cell:SetActive(false)
        table.insert(self.cellObjList, cell)
    end
end

local function SetData(self, data)
    for i,v in ipairs(self.cellObjList) do
        v:SetActive(data[i] ~= nil)
        if data[i] ~= nil then
            -- 英雄数量可能不填充为一整行 这里需要判空
            v:SetData(data[i], data.endTime, data.medalShopId)
        end
    end
end

UIHeroMedalShopItem.OnCreate = OnCreate
UIHeroMedalShopItem.OnDestroy = OnDestroy
UIHeroMedalShopItem.ComponentDefine = ComponentDefine
UIHeroMedalShopItem.SetData = SetData

return UIHeroMedalShopItem