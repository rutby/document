
local MysteriousActTemplate = BaseClass("MysteriousActTemplate")

local function __init(self)
    self.activityId = 0     -- 活动ID
    self.costItemType = 0   -- 抽奖道具类型
    self.costItemId = 0     -- 抽奖道具id
    self.costItemIconPath = ""  -- 抽奖道具图标
    self.oneDrawCostNum = 0     -- 单抽消耗道具数量
    self.tenDrawCostNum = 0     -- 十连消耗道具数量
end

local function __delete(self)
    self.activityId = nil     -- 活动ID
    self.costItemType = nil   -- 抽奖道具类型
    self.costItemId = nil     -- 抽奖道具id
    self.costItemIconPath = nil  -- 抽奖道具图标
    self.oneDrawCostNum = 0     -- 单抽消耗道具数量
    self.tenDrawCostNum = 0     -- 十连消耗道具数量
end

local function ParseData(self,row)
    if row ==nil then
        return
    end
    self.activityId = row:getValue("id")
    
    local para2 = row:getValue("para2")
    local spl_para2 = string.split_ss_array(para2,";")
    self.costItemType = tonumber(spl_para2[1])     -- 1 资源 2 道具
    self.costItemId = tonumber(spl_para2[2])
    if self.costItemType == 2 then
        local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.costItemId)
        if template ~= nil then
            self.costItemIconPath = string.format(LoadPath.ItemPath, template.icon)
        end
    end

    local para3 = row:getValue("para3")
    local spl_para3 = string.split_ss_array(para3,";")
    self.oneDrawCostNum = tonumber(spl_para3[1])
    self.tenDrawCostNum = tonumber(spl_para3[2])
end



MysteriousActTemplate.__init = __init
MysteriousActTemplate.__delete = __delete
MysteriousActTemplate.ParseData = ParseData

return MysteriousActTemplate