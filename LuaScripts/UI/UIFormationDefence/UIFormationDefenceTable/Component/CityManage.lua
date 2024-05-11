--- Created by shimin.
--- DateTime: 2021/7/29 3:59
--- 迁城界面

local CityManage = BaseClass("CityManage", UIBaseContainer)
local base = UIBaseContainer
local UICityManageCell = require("UI.UIFormationDefence.UIFormationDefenceTable.Component.UICityManageCell")

local Localization = CS.GameEntry.Localization
--local title_txt_Path = "UICommonPopUpTitle/bg_mid/titleText"
local scroll_view_path = "ScrollView"
local svContent_path = "ScrollView/Viewport/Content"


--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)

    self.scroll_view = self:AddComponent(UIBaseContainer, scroll_view_path)
    self.svContentN = self:AddComponent(UIBaseContainer, svContent_path)
    self.itemList ={}
    self.cells = {}
    
end

local function ComponentDestroy(self)
    --self.title_txt = nil
    self.itemList =nil
    self.cells = nil
    self.scroll_view = nil
end


local function DataDefine(self)

end

local function DataDestroy(self)
  
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.ScrollViewContentChange, self.ForceRepositionSv)
end


local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.ScrollViewContentChange, self.ForceRepositionSv)
    base.OnRemoveListener(self)
end



local function ReInit(self)
    --self.title_txt:SetLocalText(129024)
    self.itemList = self.view.ctrl:GetAllCityManageData()
    self:RefreshCityManageCell()
end


local function RefreshCityManageCell(self)
    self:SetAllCellDestroy()
    local list = self.itemList
    self.model = {}
    if list ~= nil then
        for i = 1, table.length(list) do
            --复制基础prefab，每次循环创建一次
            self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICityManageCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.svContentN.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.name ="item" .. i
                local cell = self.svContentN:AddComponent(UICityManageCell,go.name)
                cell:ReInit(list[i])
            end)
        end
    end
end
 
local function SetAllCellDestroy(self)
    self.svContentN:RemoveComponents(UICityManageCell)
    if self.model~=nil then
        for k,v in pairs(self.model) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
end


local function SwitchContent(self,param)
    
    --self.returnUp_btn.gameObject:SetActive(true)
    --self.warFever_content.gameObject:SetActive(false)
    --self.warGuard_content.gameObject:SetActive(false)
    --self.scroll_view.gameObject:SetActive(false)
    ----self.close_btn.gameObject:SetActive(false)
    --self.curParam = param
    --if param.id == CityManageBuffType.CityFever  then -- 战争狂热
    --    self.warFever_content.gameObject:SetActive(true)
    --    self.warFever_content:ReInit()
    --else
    --    self.warGuard_content.gameObject:SetActive(true)
    --    self.warGuard_content:ReInit(param)
    --end
end

local function ForceRepositionSv(self)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.svContentN.rectTransform)
end

CityManage.OnCreate = OnCreate
CityManage.OnDestroy = OnDestroy
CityManage.OnEnable = OnEnable
CityManage.OnDisable = OnDisable
CityManage.ComponentDefine = ComponentDefine
CityManage.ComponentDestroy = ComponentDestroy
CityManage.DataDefine = DataDefine
CityManage.DataDestroy = DataDestroy
CityManage.OnAddListener = OnAddListener
CityManage.OnRemoveListener = OnRemoveListener
CityManage.ReInit = ReInit
CityManage.SwitchContent = SwitchContent
CityManage.ForceRepositionSv = ForceRepositionSv
CityManage.RefreshCityManageCell = RefreshCityManageCell
CityManage.SetAllCellDestroy = SetAllCellDestroy
return CityManage