---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/1/10 12:05
---
local LuckyShopItemData = BaseClass("LuckyShopItemData")

local function __init(self)
    self.id = 0
    self.goodsId = 0
    self.goodsNum = 0
    self.costType = 1
    self.costId = 0
    self.order = 0
    self.isBuy = 0
    self.costNum = 0
end

local function __delete(self)
    self.id = 0
    self.goodsId = 0
    self.goodsNum = 0
    self.costType = 1
    self.costId = 0
    self.order = 0
    self.isBuy = 0
end

local function ParseData(self, param)
    self.id = param["id"]
    self.goodsId = toInt(param["goodsId"])
    self.goodsNum = toInt(param["goodsNum"])
    self.costType = param["costType"]
    self.costId = toInt(param["costId"])
    self.order = param["order"]
    self.isBuy = param["buy"]
    self.costNum = param["costNum"]
end

local function IsBuy(self)
    return self.isBuy ~= 0
end

LuckyShopItemData.__init = __init
LuckyShopItemData.__delete = __delete

LuckyShopItemData.ParseData = ParseData
LuckyShopItemData.IsBuy = IsBuy

return LuckyShopItemData