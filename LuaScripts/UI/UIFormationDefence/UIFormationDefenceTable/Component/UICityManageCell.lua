--- Created by shimin.
--- DateTime: 2021/7/29 3:59
--- 迁城界面

local UICityManageCell = BaseClass("UICityManageCell", UIBaseContainer)
local base = UIBaseContainer

local UICityManageCellItemCell = require("UI.UIFormationDefence.UIFormationDefenceTable.Component.UICityManageCellItemCell")
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization

local cell = ""
local title_txt_path = "Maintitlebg/Ritle_tips"
local content_path = "Content"
local root_path = ""

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
  --  self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
   -- self.cell_btn = self:AddComponent(UIButton, cell)
    self.title_txt = self:AddComponent(UITextMeshProUGUIEx, title_txt_path)
    self.content = self:AddComponent(UIBaseContainer,content_path)
    self.rootSv = self:AddComponent(UIBaseContainer, root_path)
    
    --self.cell_btn:SetOnClick(function()
    --    self:OnItemClick()
    --end)
   
end

local function ComponentDestroy(self)
  --  self.cell_btn = nil
    self.title_txt = nil
    self.rootSv = nil
end


local function DataDefine(self)
    self.cellList = {}
end

local function DataDestroy(self)
    self.cellList = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)

end


local function OnRemoveListener(self)
    base.OnRemoveListener(self)

end


local function GetSliderTime(self,type,type2)
    local param = {}
    local effectStatus = DataCenter.StatusManager:GetAllStatusItem()
    local now = UITimeManager:GetInstance():GetServerTime()
    for k,v in pairs(effectStatus) do
        local intKey = tonumber(k)
        local numValue = tonumber(v)
        local statItem = LocalController:instance():getLine(TableName.StatusTab,tostring(intKey))
        local item =  DataCenter.ItemTemplateManager:GetItemByParaAndType(intKey,type,type2)

        if item ~= nil then
            if type == item.type and type2 == item.type2 then
                local time =  numValue - now
                if  time > 0 then
                    param.endTime = numValue
                    param.totalTime = statItem.time*1000
                    param.intKey = intKey
                end
            end
            
            
        elseif  intKey >= CityWarFeverStatu.CityWarFeverMin and intKey <= CityWarFeverStatu.CityWarFeverMax and type ==0 and type2 ==0  then -- 战争狂热
            local time =  numValue - now
            if  time > 0 then
                param.endTime = numValue
                param.totalTime = statItem.time*1000
                param.intKey = intKey
            end
        elseif intKey == EffectStateDefine.NEW_PLAYER_PROTECTED  and type ==4 and type2 ==1   then -- 登录游戏中新手保护
            local time =  numValue - now
            if  time > 0 then
                param.endTime = numValue
                param.totalTime = statItem.time*1000
                param.intKey = intKey
            end
        end
    end
    return param
end


local function ReInit(self,param)
    self.param = param
    if self.param ~= nil then
       -- self.title_txt:SetLocalText(self.param.title) 
        -- 生成子item
        for i = 1, table.length(self.param) do
            self:GameObjectInstantiateAsync(UIAssets.UICityManageCellItemCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.name = "item" .. tonumber(i)
                self.title_txt:SetLocalText(self.param[i].name1)
                local cell = self.content:AddComponent(UICityManageCellItemCell,go.name)
                local temp = nil
                if self.param[i].id == CityManageBuffType.CityFever or self.param[i].id == CityManageBuffType.WarGuard then
                    temp = self:GetSliderTime(self.param[i].type,self.param[i].type2)
                else
                    temp = DataCenter.StatusManager:GetBuffTimeInfo(self.param[i].status)
                end
                local param = {}
                param.id    = self.param[i].id
                param.name  = self.param[i].name2
                param.des   = self.param[i].des
                param.icon  = self.param[i].icon
                param.type  = self.param[i].type
                param.type2 = self.param[i].type2
                if temp ~= nil then
                    param.endTime = temp.endTime
                    param.totalTime = temp.totalTime
                    param.intKey = temp.intKey
                end
                
                
                cell:ReInit(param)
                self.cellList[i] = request
                --CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rootSv.rectTransform)
                EventManager:GetInstance():Broadcast(EventId.ScrollViewContentChange)
            end)
        end
    end
end

local function OnItemClick(self)
end




UICityManageCell.OnCreate = OnCreate
UICityManageCell.OnDestroy = OnDestroy
UICityManageCell.OnEnable = OnEnable
UICityManageCell.OnDisable = OnDisable
UICityManageCell.ComponentDefine = ComponentDefine
UICityManageCell.ComponentDestroy = ComponentDestroy
UICityManageCell.DataDefine = DataDefine
UICityManageCell.DataDestroy = DataDestroy
UICityManageCell.OnAddListener = OnAddListener
UICityManageCell.OnRemoveListener = OnRemoveListener
UICityManageCell.ReInit = ReInit
UICityManageCell.OnItemClick = OnItemClick
UICityManageCell.GetSliderTime = GetSliderTime



return UICityManageCell