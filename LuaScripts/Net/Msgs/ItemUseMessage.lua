---
--- Created by shimin.
--- DateTime: 2020/7/6 21:39
---
local ItemUseMessage = BaseClass("ItemUseMessage", SFSBaseMessage)
local base = SFSBaseMessage
local function OnCreate(self, param)
    base.OnCreate(self)

    self.sfsObj:PutUtfString("uuid", param.uuid)
    self.sfsObj:PutInt("num", param.num)
    if param.para1 ~= nil and param.para1 ~= "" then
        self.sfsObj:PutUtfString("para1", param.para1)
    end
    if param.heroId ~= nil and param.heroId ~= "" then
        self.sfsObj:PutInt("heroId", param.heroId)
    end
    if param.prtUid ~= nil and param.prtUid ~= "" then
        self.sfsObj:PutUtfString("prtUid", param.prtUid)
    end
    if param.commentText ~= nil and param.commentText ~= "" then
        self.sfsObj:PutUtfString("commentText", param.commentText)
    end
    if param.style ~= nil and param.style ~= 0 then
        self.sfsObj:PutInt("style", param.style)
    end
    if param.pointId ~= nil and param.pointId > 0 then
        self.sfsObj:PutInt("pointId", param.pointId)
    end
    if param.useItemFromType ~= nil and param.useItemFromType > 0 then
        self.sfsObj:PutInt("useItemFromType", param.useItemFromType)
    end
    if param.formationUuid ~= nil then
        self.sfsObj:PutLong("formationUuid", param.formationUuid)
    end
    if param.marchUuid ~= nil then
        self.sfsObj:PutLong("marchUuid", param.marchUuid)
    end
    if param.desertUuid ~= nil then
        self.sfsObj:PutLong("desertUuid", param.desertUuid)
    end
    if param.useResetItemType ~= nil then
        self.sfsObj:PutInt("useResetItemType", param.useResetItemType)
    end
    if param.targetPage  ~= nil then
        self.sfsObj:PutInt("targetPage", param.targetPage)
    end
    if param.armType then
        self.sfsObj:PutInt("armType", param.armType)
    end
    if param.callBossUseType ~= nil then
        self.sfsObj:PutInt("callBossUseType", param.callBossUseType)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.ItemManager:ItemUseHandle(t)
    if t["errorCode"] == nil then
        local itemId = t["itemId"]
        local item = DataCenter.ItemData:GetItemById(itemId)
        if item ~= nil then
            EventManager:GetInstance():Broadcast(EventId.CLICK_RESOURCE_ITEM)
        else
            EventManager:GetInstance():Broadcast(EventId.REFRESH_RESOURCE_BAG)
        end
    end
end

ItemUseMessage.OnCreate = OnCreate
ItemUseMessage.HandleMessage = HandleMessage

return ItemUseMessage