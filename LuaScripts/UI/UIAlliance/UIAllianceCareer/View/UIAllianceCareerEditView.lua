---
--- Created by shimin.
--- DateTime: 2022/3/11 17:45
--- 联盟管理职务界面
---
local UIAllianceCareerEditView = BaseClass("UIAllianceCareerEditView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local UIAllianceCareerEditRow = require "UI.UIAlliance.UIAllianceCareer.Component.UIAllianceCareerEditRow"
local UIAllianceCareerEffectCell = require "UI.UIAlliance.UIAllianceCareer.Component.UIAllianceCareerEffectCell"
local UIAllianceCareerEditCell = require "UI.UIAlliance.UIAllianceCareer.Component.UIAllianceCareerEditCell"

local anim_path = "animObj"
local career_effect_content_path = "animObj/heroObj/UIAllianceCareer/CareerEffectContent"
local scroll_view_content_path = "animObj/heroObj/UIAllianceCareer/CareerLayout/ScrollView/Viewport/Content"
local title_text_path = "animObj/heroObj/UIAllianceCareer/UICommonPopUpTitle/bg_mid/titleText"
local close_btn_path = "animObj/heroObj/UIAllianceCareer/UICommonPopUpTitle/bg_mid/CloseBtn"
local back_btn_path = "animObj/SafeArea/FormationHeroList/btnClose"
local select_name_path = "animObj/SafeArea/FormationHeroList/Name"
local select_num_path = "animObj/SafeArea/FormationHeroList/Num"
local empty_path = "animObj/SafeArea/FormationHeroList/Empty"
local select_scroll_view_path = "animObj/SafeArea/FormationHeroList/LayoutGo/ScrollView"
local manager_btn_path = "animObj/SafeArea/FormationHeroList/LayoutGo/CareerManagerBtn"
local manager_btn_name_path = "animObj/SafeArea/FormationHeroList/LayoutGo/CareerManagerBtn/CareerManagerBtnName"
local panel_path = "panel"



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
    self.career_effect_content = self:AddComponent(UIBaseContainer, career_effect_content_path)
    self.scroll_view_content = self:AddComponent(UIBaseContainer, scroll_view_content_path)
    self.title_text = self:AddComponent(UIText, title_text_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.select_name = self:AddComponent(UIText, select_name_path)
    self.select_num = self:AddComponent(UIText, select_num_path)
    self.empty_text = self:AddComponent(UIText, empty_path)
    self.empty_text:SetLocalText(395017)
    self.scroll_view = self:AddComponent(UIScrollView, select_scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
    self.panel = self:AddComponent(UIButton, panel_path)
    self.panel:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.back_btn = self:AddComponent(UIButton, back_btn_path)
    self.back_btn:SetOnClick(function()
        self:OnBackBtnClick()
    end)
    self.animator = self:AddComponent(UIAnimator, anim_path)
    self.manager_btn = self:AddComponent(UIButton, manager_btn_path)
    self.manager_btn:SetOnClick(function()
        self:OnManagerBtnClick()
    end)
    self.manager_btn_name = self:AddComponent(UIText, manager_btn_name_path)
end

local function ComponentDestroy(self)
    self.career_effect_content = nil
    self.scroll_view_content = nil
    self.title_text = nil
    self.close_btn = nil
    self.select_name = nil
    self.select_num = nil
    self.empty_text = nil
    self.scroll_view = nil
    self.back_btn = nil
    self.animator = nil
    self.manager_btn = nil
    self.manager_btn_name = nil
end


local function DataDefine(self)
    self.model = {}
    self.req = {}
    self.modelEffect = {}
    self.effectReq = {}
    self.selectType = nil
    self.savePos = {}
    self.list = {}
    self.maxList = nil
end

local function DataDestroy(self)
    self:SavePos()
    self.model = nil
    self.req = nil
    self.modelEffect = nil
    self.effectReq = nil
    self.selectType = nil
    self.savePos = nil
    self.list = nil
    self.maxList = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self)
    self.animator:Play("select_anim_idle_soldier",0,0)
    self.back_btn:SetActive(false)
    self:ShowCareerCells()
    self:ShowCareerEffectCells()
    self:ShowManagerBtn()
    self.title_text:SetText(Localization:GetString(GameDialogDefine.MANAGER_CAREER))
end

local function OnAddListener(self)
    base.OnAddListener(self)

end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)

end

local function OnBackBtnClick(self)
    self.animator:Play("select_anim_soldier",0,0)
    self.back_btn:SetActive(false)
    self.selectType = nil
end

local function ShowCareerCells(self)
    self:ClearReq()
    self.maxList = DataCenter.AllianceCareerManager:GetCareerMaxNumList()
    if self.maxList ~= nil then
        local count = 0
        for k,v in ipairs(self.maxList) do
            self.req[v.careerType] = self:GameObjectInstantiateAsync(UIAssets.UIAllianceCareerRow, function(request)
                if request.isError then
                    return
                end
                self.req[v.careerType] = nil
                local go = request.gameObject;
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.scroll_view_content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local cell = self.scroll_view_content:AddComponent(UIAllianceCareerEditRow,nameStr)
                local param = {}
                param.careerType = v.careerType
                param.max = v.max
                param.editCallBack = function(careerType) 
                    self:EditCallBack(careerType)
                end
                param.closeCallBack = function(info)
                    self:CloseCallBack(info)
                end
                cell:ReInit(param)
                self.model[v.careerType] = cell

                count = count + 1
                if count == #self.maxList then
                    self:OnCellInitFinish()
                end
            end)
        end
    end
end

local function ClearReq(self)
    if self.req ~= nil then
        for k,v in pairs(self.req) do
            v:Destroy()
        end
    end
    self.req = {}
end

local function ClearEffectReq(self)
    if self.effectReq ~= nil then
        for k,v in pairs(self.effectReq) do
            v:Destroy()
        end
    end
    self.effectReq = {}
end

local function ShowCareerEffectCells(self)
    self:ClearEffectReq()
    local effectList = DataCenter.AllianceCareerTemplateManager:GetAlEffectList()
    if effectList ~= nil then
        local count = table.count(effectList)
        for k,v in ipairs(effectList) do
            self.effectReq[v.id] = self:GameObjectInstantiateAsync(UIAssets.UIAllianceCareerEffectCell, function(request)
                if request.isError then
                    return
                end
                self.effectReq[v.id] = nil
                local go = request.gameObject;
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.career_effect_content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local param = {}
                param.data = v
                param.effectCallBack = function(effectParam)
                    self:OnEffectClick(effectParam)
                end
                param.count = count
                param.index = k
                local cell = self.career_effect_content:AddComponent(UIAllianceCareerEffectCell,nameStr)
                cell:ReInit(param)
                self.modelEffect[v.id] = cell
            end)
        end
    end
end

local function ShowCells(self)
    self:ClearScroll()
    self.list = DataCenter.AllianceCareerManager:GetAllianceMemberListByCareer(self.selectType)
    local tempCount = table.count(self.list)
    if tempCount > 0 then
        self.scroll_view:SetTotalCount(tempCount)
        self.scroll_view:RefillCells()
    end
end

local function OnCellMoveIn(self,itemObj, index)
    local param = {}
    param.data = self.list[index]
    param.index = index
    param.selectCallBack = function(tempIndex)
        self:SelectCallBack(tempIndex)
    end
    itemObj.name = tostring(index)
    local cellItem = self.scroll_view:AddComponent(UIAllianceCareerEditCell, itemObj)
    cellItem:ReInit(param)
    self.cells[index] = cellItem
end


local function OnCellMoveOut(self,itemObj, index)
    self.cells[index] = nil
    self.scroll_view:RemoveComponent(itemObj.name, UIAllianceCareerEditCell)
end

local function ClearScroll(self)
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIAllianceCareerEditCell)--清循环列表gameObject
    self.cells = {}
end

local function SelectCallBack(self,index)
    if self.list ~= nil then
        local info = self.list[index]
        if info ~= nil then
            if info.careerPos == AllianceCareerPosType.No then
                local max = self:GetMaxNumByCareerType(info.careerType)
                local now = self:GetSelectNum()
                if now >= max then
                    UIUtil.ShowTipsId(GameDialogDefine.RANGE_CAREER_NUM)
                else
                    info.careerPos = AllianceCareerPosType.Yes
                    if self.cells[index] ~= nil then
                        self.cells[index]:SetSelect(true)
                    end
                    self:RefreshCurCount()
                    if self.model[info.careerType] ~= nil then
                        self.model[info.careerType]:RefreshPanel()
                    end
                    self:SetSavePos(info.uid,info.careerPos)
                    self:RefreshEffectValue()
                end
            elseif info.careerPos == AllianceCareerPosType.Yes then
                info.careerPos = AllianceCareerPosType.No
                if self.cells[index] ~= nil then
                    self.cells[index]:SetSelect(false)
                end
                self:RefreshCurCount()
                if self.model[info.careerType] ~= nil then
                    self.model[info.careerType]:RefreshPanel()
                end
                self:SetSavePos(info.uid,info.careerPos)
                self:RefreshEffectValue()
            end
        end
    end
end

local function GetMaxNumByCareerType(self,careerType)
    if self.maxList == nil then
        self.maxList = DataCenter.AllianceCareerManager:GetCareerMaxNumList()
    end
    if self.maxList ~= nil then
        for k,v in ipairs(self.maxList) do
            if v.careerType == careerType then
                return v.max
            end
        end
    end
    return 0
end

local function GetSelectNum(self)
    local result = 0 
    if self.list ~= nil then
        for k,v in ipairs(self.list) do
            if v.careerPos == AllianceCareerPosType.Yes then
                result = result + 1
            end
        end
    end
    return result
end

local function RefreshCurCount(self)
    self.select_name:SetText("")
    self.select_num:SetText("")
    self.empty_text:SetActive(false)
end

local function CloseCallBack(self,info)
    if info.careerPos == AllianceCareerPosType.Yes then
        info.careerPos = AllianceCareerPosType.No
        local uid = info.uid
        for k,v in ipairs(self.list) do
            if v.uid == uid then
                if self.cells[k] ~= nil then
                    self.cells[k]:SetSelect(false)
                end
                break
            end
        end
        self:RefreshCurCount()
        self:SetSavePos(info.uid,info.careerPos)
        self:RefreshEffectValue()
    end
end

local function EditCallBack(self,careerType)
    if self.selectType ~= careerType then
        if self.selectType == nil then
            self.animator:Play("select_anim_hero",0,0)
        else
            self.animator:Play("select_anim_idle_hero",0,0)
        end
        self.selectType = careerType
        self:ShowCells()
        self:RefreshCurCount()
        self.back_btn:SetActive(true)
    end
end

local function SavePos(self)
    if table.count(self.savePos) > 0 then
        DataCenter.AllianceCareerManager:SendSetPos(self.savePos)
        EventManager:GetInstance():Broadcast(EventId.RefreshAllianceCareer)
    end
end


local function SetSavePos(self,uid,pos)
    if self.savePos[uid] == nil then
        self.savePos[uid] = pos
    else
        self.savePos[uid] = nil
    end
end

local function RefreshEffectValue(self)
    if self.modelEffect ~= nil then
        for k,v in pairs(self.modelEffect) do
            v:RefreshPanel()
        end
    end
end

local function OnEffectClick(self,effectParam)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCareerEffectTip, { anim = true },effectParam)
end

local function OnManagerBtnClick(self)
    
end

local function ShowManagerBtn(self) 
    local showManagerBtn = false
    if showManagerBtn then
        self.manager_btn:SetActive(true)
        self.manager_btn_name:SetText(Localization:GetString(GameDialogDefine.MANAGER_CAREER))
    else
        self.manager_btn:SetActive(false)
    end
end

local function OnCellInitFinish(self)
    self:SelectDefault()
end

-- 默认选中职业
local function SelectDefault(self)
    local careerType = DataCenter.AllianceCareerManager:GetEditDefaultCareerType()
    if careerType then
        self:EditCallBack(careerType)
    end
end

UIAllianceCareerEditView.OnCreate = OnCreate
UIAllianceCareerEditView.OnDestroy = OnDestroy
UIAllianceCareerEditView.ComponentDefine = ComponentDefine
UIAllianceCareerEditView.ComponentDestroy = ComponentDestroy
UIAllianceCareerEditView.DataDefine = DataDefine
UIAllianceCareerEditView.DataDestroy = DataDestroy
UIAllianceCareerEditView.OnEnable = OnEnable
UIAllianceCareerEditView.OnDisable = OnDisable
UIAllianceCareerEditView.ReInit = ReInit
UIAllianceCareerEditView.OnAddListener = OnAddListener
UIAllianceCareerEditView.OnRemoveListener = OnRemoveListener
UIAllianceCareerEditView.OnBackBtnClick = OnBackBtnClick
UIAllianceCareerEditView.ShowCareerCells = ShowCareerCells
UIAllianceCareerEditView.ClearReq = ClearReq
UIAllianceCareerEditView.ClearEffectReq = ClearEffectReq
UIAllianceCareerEditView.ShowCareerEffectCells = ShowCareerEffectCells
UIAllianceCareerEditView.ShowCells = ShowCells
UIAllianceCareerEditView.OnCellMoveIn = OnCellMoveIn
UIAllianceCareerEditView.OnCellMoveOut = OnCellMoveOut
UIAllianceCareerEditView.ClearScroll = ClearScroll
UIAllianceCareerEditView.SelectCallBack = SelectCallBack
UIAllianceCareerEditView.GetMaxNumByCareerType = GetMaxNumByCareerType
UIAllianceCareerEditView.GetSelectNum = GetSelectNum
UIAllianceCareerEditView.RefreshCurCount = RefreshCurCount
UIAllianceCareerEditView.CloseCallBack = CloseCallBack
UIAllianceCareerEditView.EditCallBack = EditCallBack
UIAllianceCareerEditView.SavePos = SavePos
UIAllianceCareerEditView.SetSavePos = SetSavePos
UIAllianceCareerEditView.RefreshEffectValue = RefreshEffectValue
UIAllianceCareerEditView.OnEffectClick = OnEffectClick
UIAllianceCareerEditView.OnManagerBtnClick = OnManagerBtnClick
UIAllianceCareerEditView.ShowManagerBtn = ShowManagerBtn
UIAllianceCareerEditView.OnCellInitFinish = OnCellInitFinish
UIAllianceCareerEditView.SelectDefault = SelectDefault


return UIAllianceCareerEditView