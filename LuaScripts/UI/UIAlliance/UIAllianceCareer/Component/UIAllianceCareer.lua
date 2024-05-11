---
--- Created by shimin.
--- DateTime: 2022/3/10 20:53
--- 联盟职业界面
---

local UIAllianceCareer = BaseClass("UIAllianceCareer",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local UIHeroTipView = require "UI.UIHero2.UIHeroTip.View.UIHeroTipView"
local UIAllianceCareerRow = require "UI.UIAlliance.UIAllianceCareer.Component.UIAllianceCareerRow"
local UIAllianceCareerEffectCell = require "UI.UIAlliance.UIAllianceCareer.Component.UIAllianceCareerEffectCell"

local career_effect_content_path = "CareerEffectContent"
local scroll_view_content_path = "CareerLayout/ScrollView/Viewport/Content"
local career_manager_btn_go_path = "CareerLayout/CareerManagerBtnGo"
local career_manager_btn_path = "CareerLayout/CareerManagerBtnGo/CareerManagerBtn"
local career_manager_btn_name_path = "CareerLayout/CareerManagerBtnGo/CareerManagerBtn/CareerManagerBtnName"
local tip_btn_path = "TipBtn"
local career_manager_btn_red_go_path = "CareerLayout/CareerManagerBtnGo/ImgWarn"
local career_manager_btn_red_text_path = "CareerLayout/CareerManagerBtnGo/ImgWarn/TxtNum"
local careerLocked_path = "CareerLayout/CareerLocked"
local careerLockedTip_path = "CareerLayout/CareerLocked/CareerLockedTip"
local careerLockedBtn_path = "CareerLayout/CareerLocked/careerLockBtn"

local TipDelta = Vector3.New(30, 0, 0)

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
    self.career_manager_btn_go = self:AddComponent(UIBaseContainer, career_manager_btn_go_path)
    self.career_manager_btn = self:AddComponent(UIButton, career_manager_btn_path)
    self.careerLockedN = self:AddComponent(UIBaseContainer, careerLocked_path)
    self.careerLockedTipN = self:AddComponent(UITextMeshProUGUIEx, careerLockedTip_path)
    self.careerLockedBtnN = self:AddComponent(UIButton, careerLockedBtn_path)
    self.careerLockedBtnN:SetOnClick(function()
        local alTaskConf, targetIndex = DataCenter.AllianceTaskManager:GetTaskConfByFuncType(AllianceTaskFuncType.AllianceCareer)
        if alTaskConf then
            if targetIndex then
                self.view.ctrl:CloseSelf()
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceTask, targetIndex)
            else
                UIUtil.ShowTipsId(390994)
            end
        end
    end)
    self.career_manager_btn_name = self:AddComponent(UITextMeshProUGUIEx, career_manager_btn_name_path)
    self.career_manager_btn_red_go = self:AddComponent(UIBaseContainer, career_manager_btn_red_go_path)
    self.career_manager_btn_red_text = self:AddComponent(UITextMeshProUGUIEx, career_manager_btn_red_text_path)
    self.career_manager_btn:SetOnClick(function()
        self:OnManagerClick()
    end)
    self.tip_btn = self:AddComponent(UIButton, tip_btn_path)
    self.tip_btn:SetOnClick(function()
        self:OnTipClick()
    end)
end

local function ComponentDestroy(self)
    self.career_effect_content = nil
    self.scroll_view_content = nil
    self.career_manager_btn_go = nil
    self.career_manager_btn = nil
    self.career_manager_btn_name = nil
    self.career_manager_btn_red_go = nil
    self.career_manager_btn_red_text = nil
    self.tip_btn = nil
end


local function DataDefine(self)
    self.model = {}
    self.req = {}
    self.modelEffect = {}
    self.effectReq = {}
end

local function DataDestroy(self)
    self.model = nil
    self.req = nil
    self.modelEffect = nil
    self.effectReq = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self)
    self.view.ctrl:InitAllianceMemberData()
    self:RefreshShowManagerBtn()
    self:ShowCareerCells()
    self:ShowCareerEffectCells()
end

local function OnTipClick(self)
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.tip_btn.transform.position + TipDelta * scaleFactor
    
    local param = UIHeroTipView.Param.New()
    param.content = Localization:GetString(GameDialogDefine.ALLIANCE_CAREER_TIP_1) .. "\n" 
            .. Localization:GetString(GameDialogDefine.ALLIANCE_CAREER_TIP_2) .. "\n" ..
            Localization:GetString(GameDialogDefine.ALLIANCE_CAREER_TIP_3)
    param.dir = UIHeroTipView.Direction.RIGHT
    param.defWidth = 360
    param.pivot = 0.8
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end

local function OnManagerClick(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCareerEdit)
end

local function ShowCareerCells(self)
    self:ClearReq()
    local list = DataCenter.AllianceCareerManager:GetCareerMaxNumList()
    if list ~= nil then
        for k,v in ipairs(list) do
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
                local cell = self.scroll_view_content:AddComponent(UIAllianceCareerRow,nameStr)
                local param = {}
                param.careerType = v.careerType
                param.max = v.max
                param.cellCallBack = function(info,x,y)
                    self:OnCellClick(info,x,y)
                end
                cell:ReInit(param)
                self.model[v.careerType] = cell
            end)
        end
    end
end

local function RefreshShowManagerBtn(self)
    if not DataCenter.AllianceBaseDataManager:CheckIfAllianceFuncOpen(AllianceTaskFuncType.AllianceCareer) then
        self.career_manager_btn_go:SetActive(false)
        self.careerLockedN:SetActive(true)
        local alTaskTemplate, tempIndex = DataCenter.AllianceTaskManager:GetTaskConfByFuncType(AllianceTaskFuncType.AllianceCareer)
        self.careerLockedTipN:SetText(Localization:GetString("391010", "<u>" .. Localization:GetString(alTaskTemplate.name) .. "</u>"))
    else
        self.careerLockedN:SetActive(false)
        if DataCenter.AllianceCareerManager:IsCanSetCareer() then
            self.career_manager_btn_go:SetActive(true)
            self.career_manager_btn_name:SetText(Localization:GetString(GameDialogDefine.MANAGER_CAREER))
            self:RefreshRed()
        else
            self.career_manager_btn_go:SetActive(false)
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
                param.effectCallBack = function(effectParam)
                    self:OnEffectClick(effectParam)
                end
                param.data = v
                param.count = count
                param.index = k
                local cell = self.career_effect_content:AddComponent(UIAllianceCareerEffectCell,nameStr)
                cell:ReInit(param)
                self.modelEffect[v.id] = cell
            end)
        end
    end
end

local function OnRefresh(self)
    if self.model ~= nil then
        for k,v in pairs(self.model) do
            v:RefreshPanel()
        end
    end
    if self.modelEffect ~= nil then
        for k,v in pairs(self.modelEffect) do
            v:RefreshPanel()
        end
    end
end

local function OnAllianceMemberSignal(self)
    self:RefreshShowManagerBtn()
    self:OnRefresh()
end

local function OnRefreshAllianceCareerSignal(self)
    self:OnRefresh()
    self:RefreshRed()
end

local function OnEffectClick(self,effectParam)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCareerEffectTip, { anim = true },effectParam)
end

local function RefreshRed(self)
    if DataCenter.AllianceBaseDataManager:CheckIfAllianceFuncOpen(AllianceTaskFuncType.AllianceCareer) then
        if DataCenter.AllianceCareerManager:IsCanSetCareer() then
            local count = DataCenter.AllianceCareerManager:GetRedNum()
            if count > 0 then
                self.career_manager_btn_red_go:SetActive(true)
                self.career_manager_btn_red_text:SetText(count)
            else
                self.career_manager_btn_red_go:SetActive(false)
            end
        else
            self.career_manager_btn_red_go:SetActive(false)
        end
    else
        self.career_manager_btn_red_go:SetActive(false)
    end
end

local function OnCellClick(self,info,x,y)
    if info.uid ~= LuaEntry.Player.uid then
        self.view:OnShowAllianceMemberTips(info.uid,info.rank,x,y,info.name)
    end
end

UIAllianceCareer.OnCreate = OnCreate
UIAllianceCareer.OnDestroy = OnDestroy
UIAllianceCareer.ComponentDefine = ComponentDefine
UIAllianceCareer.ComponentDestroy = ComponentDestroy
UIAllianceCareer.DataDefine = DataDefine
UIAllianceCareer.DataDestroy = DataDestroy
UIAllianceCareer.OnEnable = OnEnable
UIAllianceCareer.OnDisable = OnDisable
UIAllianceCareer.OnAllianceMemberSignal = OnAllianceMemberSignal
UIAllianceCareer.OnRefreshAllianceCareerSignal = OnRefreshAllianceCareerSignal
UIAllianceCareer.ReInit = ReInit
UIAllianceCareer.OnTipClick = OnTipClick
UIAllianceCareer.OnManagerClick = OnManagerClick
UIAllianceCareer.ShowCareerCells = ShowCareerCells
UIAllianceCareer.RefreshShowManagerBtn = RefreshShowManagerBtn
UIAllianceCareer.ClearReq = ClearReq
UIAllianceCareer.ShowCareerEffectCells = ShowCareerEffectCells
UIAllianceCareer.ClearEffectReq = ClearEffectReq
UIAllianceCareer.OnRefresh = OnRefresh
UIAllianceCareer.OnEffectClick = OnEffectClick
UIAllianceCareer.RefreshRed = RefreshRed
UIAllianceCareer.OnCellClick = OnCellClick

return UIAllianceCareer