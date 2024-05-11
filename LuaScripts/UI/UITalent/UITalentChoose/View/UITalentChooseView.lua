---
--- pve选择buff页面
--- Created by shimin.
--- DateTime: 2022/5/11 10:25
---

local UITalentChooseView = BaseClass("UITalentChooseView", UIBaseView)
local base = UIBaseView
local UITalentChooseCell =  require "UI.UITalent.UITalentChoose.Component.UITalentChooseCell"
local UIMainResourceProgress = require "UI.UIActivityCenterTable.Component.ResourceProgressItem"
local Localization = CS.GameEntry.Localization
local buff_list_go_path = "BuffListGo"
local this_path = ""
local return_btn_path = "safeArea/CloseBtn"
local UIGray = CS.UIGray
local select_path = "select"
local title_path = "title"

local select_btn_path = "select/btn"
local desc_path = "select/Root"
local desc1_path = "select/Root2"

local select_desc_path = "select/Root/desc"
local select_desc1_path = "select/Root2/desc2"

local btn_text_path = "select/btn/btnText"
local resource_path = "safeArea/UIMainTopResourceCell"
local intro_btn_path = "title/IntroBtn"
local info_btn_path = "select/InfoBtn"
local reset_btn_path = "select/ResetBtn"

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.buff_list_go = self:AddComponent(UIBaseContainer, buff_list_go_path)
    self.canvasGroup = self:AddComponent(UICanvasGroup, this_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.select = self:AddComponent(UIBaseContainer, select_path)
    self.select:SetActive(false)
    self.btn = self:AddComponent(UIButton, select_btn_path)
    self.select_desc = self:AddComponent(UITextMeshProUGUIEx, select_desc_path)
    self.select_desc1 = self:AddComponent(UITextMeshProUGUIEx, select_desc1_path)

    self.btn_text = self:AddComponent(UITextMeshProUGUIEx, btn_text_path)
    self.btn_text:SetLocalText(GameDialogDefine.CONFIRM)
    self.desc = self:AddComponent(UIBaseContainer, desc_path)
    self.desc1 = self:AddComponent(UIBaseContainer, desc1_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnSubmitBtnClick()
    end)
    self.resource = self:AddComponent(UIMainResourceProgress, resource_path)
    self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
    self.intro_btn:SetOnClick(function()
        self:OnIntroClick()
    end)
    self.info_btn = self:AddComponent(UIButton, info_btn_path)
    self.info_btn:SetOnClick(function()
        self:OnInfoClick()
    end)
    
    self.reset_btn = self:AddComponent(UIButton, reset_btn_path)
    self.reset_btn:SetOnClick(function()
        self:OnResetClick()
    end)
end

local function ComponentDestroy(self)
    self.buff_list_go:RemoveComponents(UITalentChooseCell)
    self.buff_list_go = nil
    self.canvasGroup = nil
    if self.delayTimer ~= nil then
        self.delayTimer:Stop()
        self.delayTimer = nil
    end
end

local function DataDefine(self)
    self.list = {}
    self.currentSelectIndex = -1
    self.sendingSubmit = false
    self.lastChooseId = nil
    self.needShowResult = false
end

local function DataDestroy(self)
    self.list = nil
    self.currentSelectIndex = nil
    self.sendingSubmit = false
    self.lastChooseId = nil
    self.needShowResult = false
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.TalentDataChange, self.doWhenDataRefresh)
    self:AddUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)

end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.TalentDataChange, self.doWhenDataRefresh)
    self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)

end

local function ReInit(self, showAnimation)
    self.canvasGroup:SetBlocksRaycasts(true)
    self.dataList, self.recommondTalentId = self.ctrl:GetPanelData()

    local param = {}
    param.resourceType = ResourceType.Money
    param.iconName = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Money)
    self.resource:ReInit(param)
    local totalTime = Mathf.Round(LuaEntry.Effect:GetGameEffect(EffectDefine.TALENT_REFRESH_TIME))
    if totalTime == 0 then
        self.reset_btn:SetActive(false)
    else
        self.reset_btn:SetActive(true)
        local canReset = DataCenter.TalentDataManager:LeftRefreshTalentCount() > 0
        UIGray.SetGray(self.reset_btn.transform, not canReset, canReset)
    end
    local currentNum, totalNum = DataCenter.TalentDataManager:GetChooseNum()
    if totalNum - currentNum >= 2 then
        local str = Localization:GetString("131001").."("..(totalNum - currentNum).."/"..totalNum..")"
        self.title:SetText(str)
    else
        self.title:SetLocalText(131001)
    end
    if #self.list > 0 then
        for k, v in ipairs(self.list) do
            local param = {}
            param.triggerId = self.dataList[k]
            param.index = k
            param.showAnimation = showAnimation
            param.recommondTalentId = self.recommondTalentId
            v:ReInit(param)
            if self.recommondTalentId ~= nil and toInt(self.recommondTalentId) > 0 then
                if param.triggerId == self.recommondTalentId then
                    if self.delayTimer ~= nil then
                        self.delayTimer:Stop()
                        self.delayTimer = nil
                    end
                    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
                        self.delayTimer:Stop()
                        self.delayTimer = nil
                        self:SetCurrentSelect(k, false)
                    end, 0.5)
                end
            else
                if k == 1 then
                    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
                        self.delayTimer:Stop()
                        self.delayTimer = nil
                        self:SetCurrentSelect(k, false)
                    end, 0.5)
                end
            end
        end
        return 
    end
    if totalNum - currentNum == 1 then
        self.needShowResult = true
    end

    for k,v in ipairs(self.dataList) do
        self:GameObjectInstantiateAsync(UIAssets.UITalentChooseCell, function(request)
            if request.isError then
                return
            end
            local go = request.gameObject
            go:SetActive(true)
            go.transform:SetParent(self.buff_list_go.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.transform:Set_localPosition(0, 0, 0)
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            local model = self.buff_list_go:AddComponent(UITalentChooseCell, nameStr)
            local param = {}
            param.triggerId = v
            param.index = k
            param.showAnimation = showAnimation
            param.recommondTalentId = self.recommondTalentId
            model:ReInit(param)
            self.list[k] = model
            if self.recommondTalentId ~= nil and toInt(self.recommondTalentId) > 0 then
                if param.triggerId == self.recommondTalentId then
                    if self.delayTimer ~= nil then
                        self.delayTimer:Stop()
                        self.delayTimer = nil
                    end
                    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
                        self.delayTimer:Stop()
                        self.delayTimer = nil
                        self:SetCurrentSelect(k, true)
                    end, 0.5)
                end
            else
                if k == 1 then
                    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
                        self.delayTimer:Stop()
                        self.delayTimer = nil
                        self:SetCurrentSelect(k, true)
                    end, 0.5)
                end
            end
        end)
    end
end

local function OnClick(self)
    self.canvasGroup:SetBlocksRaycasts(false)
end

local function SetCurrentSelect(self, index, isFirstShow)
    if self.delayTimer ~= nil then
        return
    end
    if index == self.currentSelectIndex then
        return
    end
    self.currentSelectIndex = index
    self:RefreshCurrentSelect(isFirstShow)
end

local function RefreshCurrentSelect(self, isFirstShow)
    for k, v in pairs(self.list) do
        v:SetSelectEffectShow(self.currentSelectIndex, isFirstShow)
    end
    if self.currentSelectIndex < 0 then
        self.select:SetActive(false)
        return
    end
    self.select:SetActive(true)
    local template = DataCenter.TalentTemplateManager:GetTemplate(self.dataList[self.currentSelectIndex])
    self.desc:SetActive(true)
    self.desc1:SetActive(true)

    if template ~= nil then
        self.select_desc:SetText(template.description)
        self.select_desc1:SetText(template.description)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.desc.rectTransform)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.desc1.rectTransform)
    end
    local pos = self.desc.transform.position
    self.desc.transform.position = Vector3.New(self.list[self.currentSelectIndex].transform.position.x, pos.y, 0)
    self.desc1.transform.position = Vector3.New(self.list[self.currentSelectIndex].transform.position.x, pos.y, 0)
    local showDesc = self.desc.rectTransform.sizeDelta.x < 530
    self.desc:SetActive(showDesc)
    self.desc1:SetActive(not showDesc)
    self:SetResourceTextColor()
end

local function OnSubmitBtnClick(self)
    if self.sendingSubmit == true then
        return
    end
    if self.ctrl:DoWhenSubmit(self.dataList[self.currentSelectIndex]) then
        self.lastChooseId = self.dataList[self.currentSelectIndex]
        self.sendingSubmit = true
    end
end

local function doWhenDataRefresh(self)
    self.sendingSubmit = false
    self:SetCurrentSelect(-1, true)
    self:ReInit(true)
    if table.count(self.dataList) == 0 then
        if self.needShowResult == true then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UITalentChooseResult, self.lastChooseId)
        end
        self.ctrl:CloseSelf()
    end
end

local function UpdateResourceSignal(self)
    self.resource:Refresh()
    self:SetResourceTextColor()
end

local function OnIntroClick(self)
    local strTitle = Localization:GetString("131000")
    local subTitle = ""
    local strContent = Localization:GetString("131007").."\n"..Localization:GetString("131008").."\n"..Localization:GetString("131009")
    UIUtil.ShowIntro(strTitle, subTitle, strContent)
end

local function OnInfoClick(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UITalentInfo)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITalentInfo, {anim = true, UIMainAnim = UIMainAnimType.AllHide})
end

local function OnResetClick(self)
    self.ctrl:ResetAll()
end

local function SetResourceTextColor(self)
    local template = DataCenter.TalentTemplateManager:GetTemplate(self.dataList[self.currentSelectIndex])
    local useRedColor = false
    if template ~= nil then
        local rsNeed = template.resourceNeed
        for k, v in pairs(rsNeed) do
            if k == ResourceType.Money then
                local currentHas = LuaEntry.Resource:GetCntByResType(ResourceType.Money)
                if v > currentHas then
                    useRedColor = true
                end
            end
        end
    end

    if useRedColor then
        self.resource:SetTextColor(RedColor)
    else
        self.resource:SetTextColor(WhiteColor)
    end
end

UITalentChooseView.OnCreate = OnCreate
UITalentChooseView.OnDestroy = OnDestroy
UITalentChooseView.ComponentDefine = ComponentDefine
UITalentChooseView.ComponentDestroy = ComponentDestroy
UITalentChooseView.DataDefine = DataDefine
UITalentChooseView.DataDestroy = DataDestroy
UITalentChooseView.OnEnable = OnEnable
UITalentChooseView.OnDisable = OnDisable
UITalentChooseView.OnAddListener = OnAddListener
UITalentChooseView.OnRemoveListener = OnRemoveListener
UITalentChooseView.ReInit = ReInit
UITalentChooseView.OnClick = OnClick
UITalentChooseView.SetCurrentSelect = SetCurrentSelect
UITalentChooseView.RefreshCurrentSelect = RefreshCurrentSelect
UITalentChooseView.OnSubmitBtnClick = OnSubmitBtnClick
UITalentChooseView.doWhenDataRefresh = doWhenDataRefresh
UITalentChooseView.UpdateResourceSignal = UpdateResourceSignal
UITalentChooseView.OnIntroClick = OnIntroClick
UITalentChooseView.OnInfoClick = OnInfoClick
UITalentChooseView.OnResetClick = OnResetClick
UITalentChooseView.SetResourceTextColor = SetResourceTextColor

return UITalentChooseView
