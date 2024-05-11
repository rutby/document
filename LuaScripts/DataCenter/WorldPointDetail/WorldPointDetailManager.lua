---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/8/5 14:19
---
local WorldPointDetailManager = BaseClass("WorldPointDetailManager");
local function __init(self)
    self.worldPointDetailList = {}
    self.worldAllianceCityList = {}
end

local function __delete(self)
    self.worldPointDetailList = nil
    self.worldAllianceCityList = nil
end

local function UpdateDetail(self,message)
    local detailData = WorldPointDetailData.New()
    detailData:ParseData(message)
    if detailData.pointId>0 then
        self.worldPointDetailList[detailData.pointId] = detailData
    end
end

local function UpdateAllianceCity(self,message)
    local detail = WorldAllianceCityData.New()
    detail:ParseData(message)
    if detail.cityId~=nil then
        self.worldPointDetailList[detail.cityId] = detail
    end
end

local function GetAllianceCityData(self,cityId)
    return self.worldPointDetailList[cityId]
end
local function GetDetailByPointId(self,pointId)
    return self.worldPointDetailList[pointId]
end

WorldPointDetailManager.__init = __init
WorldPointDetailManager.__delete = __delete
WorldPointDetailManager.UpdateDetail = UpdateDetail
WorldPointDetailManager.GetDetailByPointId = GetDetailByPointId
WorldPointDetailManager.UpdateAllianceCity = UpdateAllianceCity
WorldPointDetailManager.GetAllianceCityData = GetAllianceCityData
return WorldPointDetailManager