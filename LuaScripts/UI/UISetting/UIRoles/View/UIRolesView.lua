---
--- 角色管理
--- Created by zzl.
--- DateTime: 
---
local UIRolesCell = require "UI.UISetting.UIRoles.Component.UIRolesCell"
local UIRolesView = BaseClass("UIRolesView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path ="UICommonMidPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local goback_btn_path = "UICommonMidPopUpTitle/Btn_GoBack"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local layout_path = "layout"
local scroll_view_path = "layout/ScrollView"
local des_txt_path = "layout/desText"

--创建
function UIRolesView:OnCreate()
    base.OnCreate(self)
    local checkType =  self:GetUserData()
    self.checkType = tonumber(checkType) --0显示自己邮箱内包含的角色，1显示获取其他邮箱内包含的角色
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIRolesView:OnDestroy()
    self:SetAllCellsDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIRolesView:ComponentDefine()
    self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.goback_btn = self:AddComponent(UIButton, goback_btn_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.des_txt = self:AddComponent(UITextMeshProUGUIEx, des_txt_path)
    self.des_txt:SetLocalText(208238)
    self.layout = self:AddComponent(UIBaseContainer, layout_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)

    self.close_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    self.goback_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.return_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
end

function UIRolesView:ComponentDestroy()
    self.txt_title = nil
    self.close_btn = nil
    self.return_btn = nil
    self.scroll_view = nil
end


function UIRolesView:DataDefine()
    self.list = {}
    if self.checkType ==0 then
        self.des_txt:SetActive(false)
        SFSNetwork.SendMessage(MsgDefines.AccountLoginNew)
    else
        self.des_txt:SetActive(true)
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.rectTransform)
end

function UIRolesView:DataDestroy()
    self.list = nil
end

function UIRolesView:OnEnable()
    base.OnEnable(self)
    if self.checkType ==1 then
        self:ShowCells()
    end
end

function UIRolesView:OnDisable()
    base.OnDisable(self)
end

function UIRolesView:ReInit()
    self.txt_title:SetLocalText(208225)
end

-- 表现销毁
function UIRolesView:SetAllCellsDestroy()
    self:ClearScroll()
end

function UIRolesView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RolesRefresh, self.ShowCells)
end

function UIRolesView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RolesRefresh, self.ShowCells)
end

function UIRolesView:ShowCells()
    self:ClearScroll()
    self.list = DataCenter.AccountManager:GetRolesList()
    if self.checkType ==0 then
        local empty = {}
        empty.isEmpty = true
        table.insert(self.list,1,empty)
    end
    local tempCount = table.count(self.list)
    if tempCount > 0 then
        self.scroll_view:SetTotalCount(tempCount)
        self.scroll_view:RefillCells()
    end
end

function UIRolesView:OnCellMoveIn(itemObj, index)
    local tempType = self.list[index]
    itemObj.name = NameCount
    NameCount = NameCount + 1
    local cellItem = self.scroll_view:AddComponent(UIRolesCell, itemObj)
    cellItem:ReInit(tempType)
    cellItem:SetActive(true)
end


function UIRolesView:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIRolesCell)
end

function UIRolesView:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIRolesCell)--清循环列表gameObject
end

function UIRolesView:CountryFlagChangedSignal()
    self.scroll_view:RefreshCells()
end


return UIRolesView