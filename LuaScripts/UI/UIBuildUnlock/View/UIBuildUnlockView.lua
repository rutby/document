---
--- 商业中心界面
--- Created by shimin.
--- DateTime: 2021/6/16 15:12
---
local UIBuildUnlockCell = require "UI.UIBuildUnlock.Component.UIBuildUnlockCell"
local UIBuildUnlockView = BaseClass("UIBuildUnlockView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local return_btn_path = "Return"
local close_btn_path = "panel/CloseBtn"
local title_path ="panel/title_main34"
local des_text_path = "panel/DesText"
local enter_btn_path ="panel/SendBtn"
local enter_btn_name_path ="panel/SendBtn/btnTxt_yellow_big_new"
local scroll_view_path = "panel/ScrollView"
local select_go_path ="SelectGo"
local select_title_path ="SelectGo/SelectTitleText"
local select_des_path ="SelectGo/SelectDesText"

local SelectPositionDelta = Vector3.New(180, -80, 0)


--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.submit_btn = self:AddComponent(UIButton, enter_btn_path)
    self.submit_btn_name = self:AddComponent(UIText, enter_btn_name_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.des_text = self:AddComponent(UIText, des_text_path)
    self.title = self:AddComponent(UIText, title_path)
    self.select_go = self:AddComponent(UIAnimator, select_go_path)
    self.select_title = self:AddComponent(UIText, select_title_path)
    self.select_des = self:AddComponent(UIText, select_des_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
    
    self.close_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    self.return_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)

    self.submit_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
end

local function ComponentDestroy(self)
    self.return_btn = nil
    self.need_item_list = nil
    self.submit_btn = nil
    self.submit_btn_name = nil
    self.close_btn = nil
    self.end_time_text = nil
    self.title = nil
    self.select_go = nil
    self.scroll_view = nil
    self.des_text = nil
    self.select_title = nil
    self.select_des = nil
end


local function DataDefine(self)
    self.list = {}
    self.template = nil
    self.selectTimer = nil
    self.isShow = nil
end

local function DataDestroy(self)
    if self.selectTimer ~= nil then
        self.selectTimer:Stop()
        self.selectTimer = nil
    end
    self.list = nil
    self.template = nil
    self.isShow = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self)
    local tempId = tonumber(self:GetUserData())
    local buildId = DataCenter.BuildManager:GetBuildId(tempId)
    local level = DataCenter.BuildManager:GetBuildLevel(tempId)
    self.select_go:SetActive(false)
    self.title:SetLocalText(GameDialogDefine.UPGRADE_LA) 
    self.submit_btn_name:SetLocalText(GameDialogDefine.CONFIRM) 
    local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId,level)
    if buildLevelTemplate ~= nil then
        local template = DataCenter.BuildTemplateManager:GetLevelUpTemplate(buildLevelTemplate.level_up)
        if template ~= nil then
            self.list = template.unlockList
            self:ShowCells()
            self.des_text:SetText(Localization:GetString(template.describe,
                    Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), buildId + level,"name")),level))
        end
    end
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function ShowCells(self)
    self:ClearScroll()
    local count = table.count(self.list)
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

local function ClearScroll(self)
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIBuildUnlockCell)--清循环列表gameObject
end

local function OnCreateCell(self,itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIBuildUnlockCell, itemObj)
    local param = {}
    param.unlockInfo = self.list[index]
    param.index = index
    param.callBack = function(isShow,indexI,position) self:CellCallBack(isShow,indexI,position) end
    item:ReInit(param)
end

local function OnDeleteCell(self,itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIBuildUnlockCell)
end

local function CellCallBack(self,isShow,index,position)
    self.isShow = isShow
    if isShow then
        self.select_go:SetActive(true)
        self.select_go.transform.position = position + SelectPositionDelta
        self.select_go:Play("CommonPopup_movein",0,0)
        local param = self.list[index]
        if param ~= nil then
            if param.unlockType == BuildLevelUpUnlockType.Build then
                self.select_title:SetLocalText(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), param.id + 0,"name"))
                self.select_des:SetLocalText(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), param.id + 0,"description"))
            end
        end
    else
        local ret,time = self.select_go:PlayAnimationReturnTime("CommonPopup_moveout")
        if ret then
            if self.selectTimer == nil then
                self.selectTimer = TimerManager:GetInstance():GetTimer(time, function()
                    if self.selectTimer ~= nil then
                        self.selectTimer:Stop()
                        self.selectTimer = nil
                    end
                    if not self.isShow then
                        self.select_go:SetActive(false)
                    end
                end , self, true,false,false)
                self.selectTimer:Start()
            end
        end
    end
end

UIBuildUnlockView.OnCreate= OnCreate
UIBuildUnlockView.OnDestroy = OnDestroy
UIBuildUnlockView.OnEnable = OnEnable
UIBuildUnlockView.OnDisable = OnDisable
UIBuildUnlockView.OnAddListener = OnAddListener
UIBuildUnlockView.OnRemoveListener = OnRemoveListener
UIBuildUnlockView.ComponentDefine = ComponentDefine
UIBuildUnlockView.ComponentDestroy = ComponentDestroy
UIBuildUnlockView.DataDefine = DataDefine
UIBuildUnlockView.DataDestroy = DataDestroy
UIBuildUnlockView.ReInit = ReInit
UIBuildUnlockView.ShowCells = ShowCells
UIBuildUnlockView.ClearScroll = ClearScroll
UIBuildUnlockView.OnCreateCell = OnCreateCell
UIBuildUnlockView.OnDeleteCell = OnDeleteCell
UIBuildUnlockView.CellCallBack = CellCallBack

return UIBuildUnlockView