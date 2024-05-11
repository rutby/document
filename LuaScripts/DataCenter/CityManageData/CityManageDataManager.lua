local CityManageDataManager = BaseClass("CityManageDataManager");

local function __init(self)
    self.itemList = {}
    self.Cell = {}
end

local function __delete(self)
    self.itemList = nil
    self.Cell = nil
end


--得到需要显示的数据
local function GetAllCityManageData(self)
    self.itemList = {}
    LocalController:instance():visitTable(TableName.CityManage,function(id,lineData)
        local item  = CityManageData.New()
        item:InitData(lineData)
        if self.itemList[item.group] == nil then
            self.itemList[item.group] = {}
            --  self.itemList[item.group].title = item.name1
        end
        table.insert(self.itemList[item.group],item)
    end)
    for _, v in pairs(self.itemList) do
        table.sort(v, function(a, b)
            local sA = tonumber(a.status) or IntMaxValue
            local sB = tonumber(b.status) or IntMaxValue
            local fA = tonumber(a.formStatus) or IntMaxValue
            local fB = tonumber(b.formStatus) or IntMaxValue
            if sA ~= sB then
                return sA < sB
            else
                return fA < fB
            end
        end)
    end
    
	return self.itemList
end


CityManageDataManager.__init = __init
CityManageDataManager.__delete = __delete
CityManageDataManager.GetAllCityManageData =  GetAllCityManageData

return CityManageDataManager