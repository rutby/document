
local BookMarkManager = BaseClass("BookMarkManager")
local Localization = CS.GameEntry.Localization

local WorldResource = CS.WorldPointType.WorldResource
local PlayerBuilding = CS.WorldPointType.PlayerBuilding
local WorldCollectResource = CS.WorldPointType.WorldCollectResource

local function __init(self)
	
end

local function __delete(self)
	
end

--获取收藏点名字
local function GetBookMarkName(self,index)
	return Localization:GetString(self:GetBookMarkNameId(index))
end

--获取收藏点名字ID
local function GetBookMarkNameId(self,index)
	local info = DataCenter.WorldPointManager:GetPointInfo(index)
	if info ~= nil then
		if info.pointType == WorldResource then
			return GameDialogDefine.RESOURCE_POINT
		elseif info.pointType == PlayerBuilding then
			return GameDialogDefine.BUILDING
		elseif info.pointType == WorldCollectResource then
			return GameDialogDefine.RESOURCE_COLLECT
		end
	end
	return GameDialogDefine.TILE
end

BookMarkManager.__init = __init
BookMarkManager.__delete = __delete
BookMarkManager.GetBookMarkName = GetBookMarkName
BookMarkManager.GetBookMarkNameId = GetBookMarkNameId

return BookMarkManager