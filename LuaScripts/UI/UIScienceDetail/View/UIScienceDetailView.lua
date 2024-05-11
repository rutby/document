--- Created by shimin.
--- DateTime: 2023/12/19 22:04
--- 科技属性详情界面

local UIScienceDetailView = BaseClass("UIScienceDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIScienceDetailCell = require "UI.UIScienceDetail.Component.UIScienceDetailCell"
local UIScienceDetailTitleCell = require "UI.UIScienceDetail.Component.UIScienceDetailTitleCell"

local title_text_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local title_content_path = "bg/title_content"
local scroll_view_path = "bg/ScrollView"
local select_go_path = "select_go"

--创建
function UIScienceDetailView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

-- 销毁
function UIScienceDetailView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIScienceDetailView:ComponentDefine()
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
end

function UIScienceDetailView:ComponentDestroy()
    self:ResetSelectGo()
end


function UIScienceDetailView:DataDefine()
    self.scienceId = 0
    self.list = {}
    self.cells = {}
    self.titleList = {}
    self.titleCells = {}
    self.selectIndex = 0
end

function UIScienceDetailView:DataDestroy()
 
end

function UIScienceDetailView:OnEnable()
    base.OnEnable(self)
end

function UIScienceDetailView:OnDisable()
    base.OnDisable(self)
end

function UIScienceDetailView:OnAddListener()
    base.OnAddListener(self)
end


function UIScienceDetailView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIScienceDetailView:ReInit()
    self.scienceId = self:GetUserData()
    local curTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.scienceId, 1)
    if curTemplate ~= nil then
        self.title_text:SetLocalText(curTemplate.name)
    end
    self.selectIndex = DataCenter.ScienceManager:GetScienceLevel(self.scienceId)
    self:ShowTitleCells()
    self:ShowCells()
end

function UIScienceDetailView:GetDataList()
    self.list = {}
    local maxLevel = DataCenter.ScienceManager:GetScienceMaxLevel(self.scienceId)
    if maxLevel > 0 then
        local template = nil
        for i = 1, maxLevel, 1 do
            template = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.scienceId, i)
            if template ~= nil then
                local param = {}
                param.list = {}
                param.showLine = (i % 2 == 0) and (self.selectIndex ~= i)
                table.insert(param.list, {des = i})
                if template.show ~= nil then
                    for k, v in ipairs(template.show) do
                        table.insert(param.list, {des = DataCenter.BuildManager:GetEffectNumWithType(v[3], tonumber(v[2]))})
                    end
                end
                if param.list[2] == nil then
                    --没有配置show字段时才显示effect
                    if template.effect ~= nil then
                        for k,v in ipairs(template.effect) do
                            local type = toInt(GetTableData(TableName.EffectNumDesc, v[1], 'type'))
                            table.insert(param.list, {des = UIUtil.GetEffectNumWithType(v[2], type)})
                        end
                    end
                end

                if DataCenter.BuildManager:CanShowPower() then
                    table.insert(param.list, {des = "+" .. string.GetFormattedSeperatorNum(template.power)})
                end
                
                table.insert(self.list, param)
            end
        end
    end
end

function UIScienceDetailView:ClearScroll()
    self:ResetSelectGo()
    self.cells = {}
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIScienceDetailCell)--清循环列表gameObject
end

function UIScienceDetailView:OnCreateCell(itemObj, index)
    itemObj.name = tostring(index)
    local cell = self.scroll_view:AddComponent(UIScienceDetailCell, itemObj)
    cell:ReInit(self.list[index])
    self.cells[index] = cell
    if self.selectIndex == index then
        cell:SetSelect(self.select_go)
    end
end

function UIScienceDetailView:OnDeleteCell(itemObj, index)
    self.cells[index] = nil
    self.scroll_view:RemoveComponent(itemObj.name, UIScienceDetailCell)
    if self.selectIndex == index then
        self:ResetSelectGo()
    end
end

function UIScienceDetailView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = #self.list
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

function UIScienceDetailView:ShowTitleCells()
    self:GetTitleList()
    local count = #self.titleList
    for k,v in ipairs(self.titleList) do
        if self.titleCells[k] == nil then
            self.titleCells[k] = v
            v.visible = true
            v.req = self:GameObjectInstantiateAsync(UIAssets.UIScienceDetailTitleCell, function(request)
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
                local model = self.title_content:AddComponent(UIScienceDetailTitleCell, nameStr)
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

function UIScienceDetailView:GetTitleList()
    self.titleList = {}
    local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.scienceId, 1)
    if template ~= nil then
        table.insert(self.titleList, {des = Localization:GetString(GameDialogDefine.LEVEL)})
        if template.show ~= nil then
            for k,v in ipairs(template.show) do
                table.insert(self.titleList, {des = Localization:GetString(v[1])})
            end
        end
        if self.titleList[2] == nil then
            --没有配置show字段时才显示effect
            if template.effect ~= nil then
                for k,v in ipairs(template.effect) do
                    local effectId = v[1]
                    local nameStr = GetTableData(TableName.EffectNumDesc, effectId, 'des')
                    table.insert(self.titleList, {des = Localization:GetString(nameStr)})
                end
            end
        end

        if DataCenter.BuildManager:CanShowPower() then
            table.insert(self.titleList, {des = Localization:GetString(GameDialogDefine.POWER)})
        end
    end
end

function UIScienceDetailView:ResetSelectGo()
    self.select_go:SetActive(false)
    self.select_go.transform:SetParent(self.transform)
end


return UIScienceDetailView