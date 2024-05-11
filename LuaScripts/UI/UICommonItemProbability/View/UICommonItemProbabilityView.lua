--- Created by shimin
--- 2024/02/26 16:35
---
local UICommonItemProbabilityView = BaseClass("UICommonItemProbabilityView",UIBaseView)
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

--创建
function UICommonItemProbabilityView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

-- 销毁
function UICommonItemProbabilityView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UICommonItemProbabilityView:ComponentDefine()
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


function UICommonItemProbabilityView:ComponentDestroy()
    self:ResetSelectGo()
end

function UICommonItemProbabilityView:OnEnable()
    base.OnEnable(self)
end

function UICommonItemProbabilityView:DataDefine()
    self.param = {}
    self.list = {}
    self.cells = {}
    self.titleList = {}
    self.titleCells = {}
    self.selectIndex = 0
end

function UICommonItemProbabilityView:DataDestroy()

end

function UICommonItemProbabilityView:OnDisable()
    base.OnDisable(self)
end

function UICommonItemProbabilityView:ReInit()
    self.param = self:GetUserData()
    self.title_text:SetLocalText(self.param.title)
    self.selectIndex = self.param.showIndex
    self:ShowTitleCells()
    self:ShowCells()
end

function UICommonItemProbabilityView:GetDataList()
    self.list = self.param.list
end

function UICommonItemProbabilityView:ClearScroll()
    self:ResetSelectGo()
    self.cells = {}
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIBuildDetailCell)--清循环列表gameObject
end

function UICommonItemProbabilityView:OnCreateCell(itemObj, index)
    itemObj.name = tostring(index)
    local cell = self.scroll_view:AddComponent(UIBuildDetailCell, itemObj)
    cell:ReInit(self.list[index])
    self.cells[index] = cell
    if self.selectIndex == index then
        cell:SetSelect(self.select_go)
    end
end

function UICommonItemProbabilityView:OnDeleteCell(itemObj, index)
    self.cells[index] = nil
    self.scroll_view:RemoveComponent(itemObj.name, UIBuildDetailCell)
    if self.selectIndex == index then
        self:ResetSelectGo()
    end
end

function UICommonItemProbabilityView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = #self.list
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells(self.selectIndex)
    end
end

function UICommonItemProbabilityView:ShowTitleCells()
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

function UICommonItemProbabilityView:GetTitleList()
    self.titleList = self.param.titleList
end

function UICommonItemProbabilityView:ResetSelectGo()
    self.select_go:SetActive(false)
    self.select_go.transform:SetParent(self.transform)
end

return UICommonItemProbabilityView