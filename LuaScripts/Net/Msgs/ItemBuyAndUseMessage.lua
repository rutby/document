---
--- Created by shimin.
--- DateTime: 2020/7/6 21:39
---
local ItemUseMessage = BaseClass("ItemUseMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    
    self.sfsObj:PutUtfString("itemId", param.itemId)
    self.sfsObj:PutInt("num", param.num)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.ItemManager:ItemBuyAndUseHandle(t)
end

ItemUseMessage.OnCreate = OnCreate
ItemUseMessage.HandleMessage = HandleMessage

return ItemUseMessage