---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/1/13 17:39
---
local UIDesertForceListCtrl = BaseClass("UIDesertForceListCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertForceList)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetDesertForceList(self)
    local showList = {}
    local tempList = DataCenter.DesertTemplateManager:GetSortList()
    if tempList~=nil then
        for k,v in pairs(tempList) do
            local oneData = {}
            oneData.level = k
            oneData.forceNum = v
            table.insert(showList,oneData)
        end
        table.sort(showList,function(a,b)
            return a.level<b.level
        end)
    end
    return showList
end

UIDesertForceListCtrl.CloseSelf = CloseSelf
UIDesertForceListCtrl.Close = Close
UIDesertForceListCtrl.GetDesertForceList = GetDesertForceList
return UIDesertForceListCtrl