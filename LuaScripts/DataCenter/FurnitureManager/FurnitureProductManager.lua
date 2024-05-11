--- Created by shimin.
--- DateTime: 2024/3/26 16:25
--- 家具生产管理器

local FurnitureProductManager = BaseClass("FurnitureProductManager")
local FurnitureProductInfo = require "DataCenter.FurnitureManager.FurnitureProductInfo"

function FurnitureProductManager:__init()
    self.allProduct = {}--所有家具<uuid, FurnitureProductInfo>
    self:AddListener()
end

function FurnitureProductManager:__delete()
    self.allProduct = {}--所有家具<uuid, FurnitureProductInfo>
    self:RemoveListener()
end

function FurnitureProductManager:Startup()
end

function FurnitureProductManager:AddListener()
end

function FurnitureProductManager:RemoveListener()
end

--更新一个信息
function FurnitureProductManager:SetTime(fUuid, startTime, endTime)
    if startTime == nil or startTime == 0 or endTime == nil or endTime == 0 then
        self.allProduct[fUuid] = nil
    else
        local info = self:GetFurnitureProductByUuid(fUuid)
        if info == nil then
            info = FurnitureProductInfo.New()
            self.allProduct[fUuid] = info
        end
        info:SetTime(fUuid, startTime, endTime)
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshFurnitureProduct, fUuid)
end

function FurnitureProductManager:RemoveTime(fUuid)
    self:SetTime(fUuid)
end

--通过uuid获取家具信息
function FurnitureProductManager:GetFurnitureProductByUuid(fUuid)
    return self.allProduct[fUuid]
end

function FurnitureProductManager:SetStopTime(fUuid, stopTime)
    local info = self:GetFurnitureProductByUuid(fUuid)
    if info ~= nil then
        info:SetStopTime(stopTime)
        EventManager:GetInstance():Broadcast(EventId.RefreshFurnitureProduct, fUuid)
    end
end

return FurnitureProductManager
