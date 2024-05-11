---
--- Created by shimin.
--- DateTime: 2022/6/14 15:11
--- 英雄委托
---

local UIHeroEntrustView = BaseClass("UIHeroEntrustView", UIBaseView)
local base = UIBaseView
local UIHeroEntrustCell = require 'UI.UIHeroEntrust.Component.UIHeroEntrustCell'

local panel_path = "panel"
local close_path = "Bg/CloseBtn"
local des_text_path = "Bg/DesText"
local content_path = "Bg/Content"
local submit_btn_path = "Bg/SubmitBtn"
local submit_btn_text_path = "Bg/SubmitBtn/BtnName"
local gray_img_path = "GrayImg"

local AllSubmitIndex = 0 --表示全部提交

function UIHeroEntrustView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIHeroEntrustView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroEntrustView:ComponentDefine()
    self.content = self:AddComponent(UIBaseContainer, content_path)
    self.des_text = self:AddComponent(UIText, des_text_path)
    self.close = self:AddComponent(UIButton, close_path)
    self.close:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        EventManager:GetInstance():Broadcast(EventId.CloseGuideMoveArrow)
        self.ctrl:CloseSelf()
    end)
    self.panel = self:AddComponent(UIButton, panel_path)
    self.panel:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        EventManager:GetInstance():Broadcast(EventId.CloseGuideMoveArrow)
        self.ctrl:CloseSelf()
    end)
    self.submit_btn = self:AddComponent(UIButton, submit_btn_path)
    self.submit_btn_text = self:AddComponent(UIText, submit_btn_text_path)
    self.submit_btn:SetOnClick(function()
        self:OnSubmitBtnClick()
    end)
    self.gray_img = self:AddComponent(UIImage, gray_img_path)
end

function UIHeroEntrustView:ComponentDestroy()
    self.content = nil
    self.des_text = nil
    self.panel = nil
    self.submit_btn = nil
    self.submit_btn_text = nil
    self.gray_img = nil
end


function UIHeroEntrustView:DataDefine()
    self.gray = self.gray_img:GetMaterial()
    self.id = nil
    self.cells = {}
    self.dubId = nil
    self.template = nil
    self.isFinger = nil
end

function UIHeroEntrustView:DataDestroy()
    self.gray = nil
    self:StopDub()
    self.id = nil
    self.cells = {}
    self.dubId = nil
    self.template = nil
    EventManager:GetInstance():Broadcast(EventId.CloseGuideMoveArrow)
end

function UIHeroEntrustView:OnEnable()
    base.OnEnable(self)
end

function UIHeroEntrustView:OnDisable()
    base.OnDisable(self)
end

function UIHeroEntrustView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshHeroEntrust, self.RefreshHeroEntrustSignal)
    self:AddUIListener(EventId.ResourceUpdated, self.RefreshCountSignal)
    self:AddUIListener(EventId.RefreshItems, self.RefreshCountSignal)
end

function UIHeroEntrustView:OnRemoveListener()
    self:RemoveUIListener(EventId.RefreshHeroEntrust, self.RefreshHeroEntrustSignal)
    self:RemoveUIListener(EventId.ResourceUpdated, self.RefreshCountSignal)
    self:RemoveUIListener(EventId.RefreshItems, self.RefreshCountSignal)
    base.OnRemoveListener(self)
end

function UIHeroEntrustView:ReInit()
    self.id = self:GetUserData()
    self.submit_btn_text:SetLocalText(tonumber(GameDialogDefine.SUBMIT_ORDER))
    self:ShowCells()
    self:CheckSubmit()
end

function UIHeroEntrustView:RefreshHeroEntrustSignal(id)
    self:Refresh()
end

function UIHeroEntrustView:ShowCells()
    for k,v in ipairs(self.cells) do
        v:SetActive(false)
    end
    self.cells = {}
    self.template = DataCenter.HeroEntrustTemplateManager:GetHeroEntrustTemplate(self.id)
    if self.template ~= nil then
        for k,v in ipairs(self.template.need) do
            local param = {}
            param.id = self.id
            param.index = k
            param.needType = v.needType
            param.needId = v.needId
            param.count = v.count
            param.template = self.template
            self:GameObjectInstantiateAsync(UIAssets.UIHeroEntrustCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.content:AddComponent(UIHeroEntrustCell, nameStr)
                model:ReInit(param)
                self.cells[k] = model
                self:CheckRecommend(param,k)
            end)
        end
        if self.template.dub ~= nil and self.template.dub ~= "" and self.template.dub ~= 0 then
            self.dubId = SoundUtil.PlayDub(tostring(self.template.dub))
        end
        self.des_text:SetLocalText(self.template.Description)
    end
end

function UIHeroEntrustView:Refresh()
    for k,v in ipairs(self.cells) do
        v:Refresh()
    end
    self:CheckSubmit()
end

function UIHeroEntrustView:RefreshCountSignal()
    self:Refresh()
end

function UIHeroEntrustView:StopDub()
    if self.dubId ~= nil then
        CS.GameEntry.Sound:StopSound(self.dubId)
        self.dubId = nil
    end
end

function UIHeroEntrustView:OnSubmitBtnClick()
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
    if self.template:IsSubmit() then
        local info = DataCenter.HeroEntrustManager:GetHeroEntrustById(self.id)
        if info ~= nil then
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Bill)
            DataCenter.HeroEntrustManager:SendPayForHeroEntrust(self.id, AllSubmitIndex)
            DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.HeroEntrustComplete,tostring(self.id))
            if self.ctrl ~= nil then
                self.ctrl:CloseSelf()
            end
        end
    end
end

function UIHeroEntrustView:CheckRecommend(temp,index)
    if not DataCenter.GuideManager:InGuide() then
        local isComplete = temp.template:HaveEnoughGoods(temp.index)
        if not isComplete then
            if self.isFinger then
                return
            end
            self.isFinger = true
            local param = {}
            param.pointList = {}
            local startParam = {}
            startParam.pointType = PositionType.Screen
            startParam.pointObj = self.cells[index]:GetFingerObj()
            table.insert(param.pointList,startParam)
            local endParam = {}
            endParam.pointType = PositionType.Screen
            endParam.pointObj = startParam.pointObj
            table.insert(param.pointList,endParam)
            param.arrowtype = GuideArrowStyle.Finger
            param.arrowdirection = 0
            if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideMoveArrow) then
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideMoveArrow,{ anim = false ,playEffect  = false}, param)
            else
                EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim, param)
            end
        end
    end
end

function UIHeroEntrustView:CheckSubmit()
    if self.template:IsSubmit() then
        self.submit_btn:SetInteractable(true)
        self.submit_btn:SetMaterial(nil)
    else
        self.submit_btn:SetInteractable(false)
        self.submit_btn:SetMaterial(self.gray)
    end
end

return UIHeroEntrustView