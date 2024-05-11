---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/4/15 17:17
---

local base = require "UI.UICityHud.Component.UICityHudBase"
local UICityHudRepair = BaseClass("UICityHudRepair", base)

local bg_path = "Root/Bg"
local cost_icon_path = "Root/Bg/CostIcon"
local cost_count_path = "Root/Bg/CostCount"

local function ComponentDefine(self)
    base.ComponentDefine(self)
    self.btn = self:AddComponent(UIButton, bg_path)
    self.btn:SetOnClick(function()
        self:OnClick()
    end)
    self.cost_icon_image = self:AddComponent(UIImage, cost_icon_path)
    self.cost_count_text = self:AddComponent(UITextMeshProUGUIEx, cost_count_path)
end

local function DataDefine(self)
    base.DataDefine(self)
    self.costs = {}
    self.repairCount = 0
    self.clicked = false
end

function UICityHudRepair:OnDestroy()
    
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.ResourceUpdated, self.Refresh)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.ResourceUpdated, self.Refresh)
    base.OnRemoveListener(self)
end

local function SetParam(self, param)
    base.SetParam(self, param)
    
    local offset = param.offset or Vector3.zero
    self.root_go.transform.localPosition = offset
    
    local resStr = LuaEntry.DataConfig:TryGetStr("safety_area", "k14")
    self.costs = {}
    for i, str in ipairs(string.split(resStr, "|")) do
        local spls = string.split(str, ";")
        if #spls == 2 then
            self.costs[i] = { resType = tonumber(spls[1]), count = tonumber(spls[2]) }
        end
    end
    self.cost_icon_image:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(self.costs[1].resType))
    self:Refresh()
end

local function Refresh(self)
    self.clicked = false
    
    self.repairCount = 0
    for _, id in ipairs(self.param.ids) do
        local wallData = DataCenter.CityWallManager:GetData(id)
        if wallData and wallData.hasHurt then
            self.repairCount = self.repairCount + 1
        end
    end
    
    local enough = true
    for i, cost in ipairs(self.costs) do
        local have = LuaEntry.Resource:GetCntByResType(cost.resType)
        if have < cost.count * self.repairCount then
            enough = false
            break
        end
    end
    self.cost_count_text:SetText(string.format("<color=%s>%s</color>", enough and "white" or "red", string.GetFormattedStr(self.costs[1].count * self.repairCount)))
end

local function OnClick(self)
    if self.clicked then
        return
    end
    self.clicked = true
    
    local lackTab = {}
    for _, cost in ipairs(self.costs) do
        local have = LuaEntry.Resource:GetCntByResType(cost.resType)
        if have < cost.count then
            local param = {}
            param.type = ResLackType.Res
            param.id = cost.resType
            param.targetNum = cost.count
            table.insert(lackTab, param)
        end
    end
    if not table.IsNullOrEmpty(lackTab) then
        GoToResLack.GoToItemResLackList(lackTab)
        return
    end

    DataCenter.CityWallManager:SendRepairWalls(self.param.ids)
    DataCenter.CityHudManager:Destroy(self.param.uuid, CityHudType.Repair)
end

UICityHudRepair.ComponentDefine = ComponentDefine
UICityHudRepair.DataDefine = DataDefine
UICityHudRepair.OnAddListener = OnAddListener
UICityHudRepair.OnRemoveListener = OnRemoveListener
UICityHudRepair.SetParam = SetParam
UICityHudRepair.Refresh = Refresh
UICityHudRepair.OnClick = OnClick

return UICityHudRepair