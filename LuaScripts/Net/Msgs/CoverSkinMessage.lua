---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/12/8 15:23
---

local CoverSkinMessage = BaseClass("CoverSkinMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, skinId, index)
    base.OnCreate(self)
    self.sfsObj:PutInt("skinId", skinId)
    self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.DecorationDataManager:CovertSkinHandler(t)
end

CoverSkinMessage.OnCreate = OnCreate
CoverSkinMessage.HandleMessage = HandleMessage

return CoverSkinMessage