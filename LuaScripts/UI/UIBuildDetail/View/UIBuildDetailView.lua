--- Created by shimin.
--- DateTime: 2024/1/8 18:05
--- 建筑属性详情界面

local UIBuildDetailView = BaseClass("UIBuildDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIBuildDetailCell = require "UI.UIBuildDetail.Component.UIBuildDetailCell"
local UIBuildDetailTitleCell = require "UI.UIBuildDetail.Component.UIBuildDetailTitleCell"

local title_text_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local title_content_path = "bg/title_content"
local scroll_view_path = "bg/ScrollView"
local select_go_path = "select_go"
local des_text_path = "bg/des_text"

--创建
function UIBuildDetailView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

-- 销毁
function UIBuildDetailView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIBuildDetailView:ComponentDefine()
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.title_content = self:AddComponent(UIBaseContainer, title_content_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
    self.select_go = self:AddComponent(UIBaseContainer, select_go_path)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
end

function UIBuildDetailView:ComponentDestroy()
    self:ResetSelectGo()
end


function UIBuildDetailView:DataDefine()
    self.buildId = 0
    self.list = {}
    self.cells = {}
    self.titleList = {}
    self.titleCells = {}
    self.selectIndex = 0
end

function UIBuildDetailView:DataDestroy()
 
end

function UIBuildDetailView:OnEnable()
    base.OnEnable(self)
end

function UIBuildDetailView:OnDisable()
    base.OnDisable(self)
end

function UIBuildDetailView:OnAddListener()
    base.OnAddListener(self)
end


function UIBuildDetailView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIBuildDetailView:ReInit()
    self.buildId = self:GetUserData()
    local level = 0
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.buildId)
    if buildData ~= nil then
        self.selectIndex = buildData.level
        level = buildData.level
    end
    self.title_text:SetLocalText(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), self.buildId + level,"name"))
    self.des_text:SetLocalText(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), self.buildId + level,"description"))
    self:ShowTitleCells()
    self:ShowCells()
end

function UIBuildDetailView:GetDataList()
    self.list = {}
    local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildId)
    if desTemplate ~= nil then
        local maxLevel = desTemplate:GetBuildMaxLevel()
        if maxLevel > 0 then
            local template = nil
            for i = 1, maxLevel, 1 do
                template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildId, i)
                if template ~= nil then
                    local param = {}
                    param.list = {}
                    param.showLine = (i % 2 == 0) and (self.selectIndex ~= i)
                    table.insert(param.list, {des = i})
                    local maxCount = #template.local_num
                    if maxCount > 0 then
                        for j = 1, maxCount, 1 do
                            local showParam = desTemplate:GetShowLocalEffect(j)
                            if showParam ~= nil then
                                local type = showParam[2]
                                if type == EffectLocalType.Dialog then
                                    table.insert(param.list, {des = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(template.local_num[j], type)})
                                else
                                    table.insert(param.list, {des = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(tonumber(template.local_num[j]) or 0, type)})
                                end
                            end
                        end
                    end

                    if DataCenter.BuildManager:CanShowPower() then
                        table.insert(param.list, {des = string.GetFormattedSeperatorNum(template.power)})
                    end

                    table.insert(self.list, param)
                end
            end
        end
    end
end

function UIBuildDetailView:ClearScroll()
    self:ResetSelectGo()
    self.cells = {}
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIBuildDetailCell)--清循环列表gameObject
end

function UIBuildDetailView:OnCreateCell(itemObj, index)
    itemObj.name = tostring(index)
    local cell = self.scroll_view:AddComponent(UIBuildDetailCell, itemObj)
    cell:ReInit(self.list[index])
    self.cells[index] = cell
    if self.selectIndex == index then
        cell:SetSelect(self.select_go)
    end
end

function UIBuildDetailView:OnDeleteCell(itemObj, index)
    self.cells[index] = nil
    self.scroll_view:RemoveComponent(itemObj.name, UIBuildDetailCell)
    if self.selectIndex == index then
        self:ResetSelectGo()
    end
end

function UIBuildDetailView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = #self.list
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

function UIBuildDetailView:ShowTitleCells()
    self:GetTitleList()
    local count = #self.titleList
    for k,v in ipairs(self.titleList) do
        if self.titleCells[k] == nil then
            self.titleCells[k] = v
            v.visible = true
            v.req = self:GameObjectInstantiateAsync(UIAssets.UIBuildDetailTitleCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.title_content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.title_content:AddComponent(UIBuildDetailTitleCell, nameStr)
                model:ReInit(self.titleCells[k])
                self.titleCells[k].model = model
            end)
        else
            v.req = self.titleCells[k].req
            v.model = self.titleCells[k].model
            self.titleCells[k] = v
            v.visible = true
            if v.model ~= nil then
                v.model:ReInit(v)
            end
        end
    end
    local cellCount = #self.titleCells
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.titleCells[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end
end

function UIBuildDetailView:GetTitleList()
    self.titleList = {}
    local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildId)
    if desTemplate ~= nil then
        table.insert(self.titleList, {des = Localization:GetString(GameDialogDefine.LEVEL)})
        local maxCount = #desTemplate.effect_local
        if maxCount > 0 then
            for i = 1, maxCount, 1 do
                local showParam = desTemplate:GetShowLocalEffect(i)
                if showParam ~= nil then
                    table.insert(self.titleList, {des = Localization:GetString(showParam[1])})
                end
            end
        end
        if DataCenter.BuildManager:CanShowPower() then
            table.insert(self.titleList, {des = Localization:GetString(GameDialogDefine.POWER)})
        end
    end
end

function UIBuildDetailView:ResetSelectGo()
    self.select_go:SetActive(false)
    self.select_go.transform:SetParent(self.transform)
end


return UIBuildDetailView