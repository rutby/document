
local UIUnLockSuccessView = BaseClass("UIUnLockSuccessView", UIBaseView)
local base = UIBaseView
local reward_title_path = "UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local panel_path = "UICommonRewardPopUp/Panel"
local popUp_Path = "UICommonRewardPopUp"
local root_path = "Root"
local unlockIcon_path = "Root/UnlockIcon"
local unlockQuest_path = "Root/UnlockQuest"
local unlockLight_path = "Root/UnlockLight"
local unlockIcon_txt_path = "Root/UnlockTxt"
local flyIcon_path = "Fly/FlyIcon"
local flyQuest_path = "Fly/FlyQuest"

--local scrollView_content_path = "Root/ScrollView/Viewport/Content"

local min_pic_height = 180

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.textTitle = self:AddComponent(UIText, reward_title_path)
    -- 恭喜获得
    self.panel = self:AddComponent(UIButton, panel_path)
    self.popUp = self:AddComponent(UIAnimator, popUp_Path)
    self.root = self:AddComponent(UIBaseContainer, root_path)
    self.panel:SetOnClick(function()
        self:OnClick()
    end)
    self.unlockIcon_txt = self:AddComponent(UIText, unlockIcon_txt_path)
    self.unlockIcon = self:AddComponent(UIImage, unlockIcon_path)
    self.unlockQuest = self:AddComponent(UIBaseContainer, unlockQuest_path)
    self.unlockLight = self:AddComponent(UIBaseContainer, unlockLight_path)
    self.flyIcon = self:AddComponent(UIImage, flyIcon_path)
    self.flyQuest = self:AddComponent(UIBaseContainer, flyQuest_path)
    self.anim = self:AddComponent(UIAnimator, "")
    --self.scrollView_content = self:AddComponent(UIBaseContainer, scrollView_content_path)
end

local function ComponentDestroy(self)
    self.textTitle = nil
    self.panel = nil
    self.popUp = nil
    self.root = nil
    self.unlockIcon_txt = nil
    self.unlockIcon = nil
    self.unlockQuest = nil
    self.unlockLight = nil
    self.flyIcon = nil
    self.flyQuest = nil
    self.anim = nil
end

local function DataDefine(self)
    self.btnTimer = nil
    self.timer_action = function()
        self:TimerAction()
    end
    self.unlockType = nil
end

local function DataDestroy(self)
    self:DeleteTimer()
    self.btnTimer = nil
    self.timer_action = nil
    self.unlockType = nil
end


local function OnEnable(self)
    base.OnEnable(self)
    local param = self.ctrl:GetShowData()
    self:InitData(param)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function InitData(self, param)
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Ue_Unclock)
    self.data = param
    self.textTitle:SetText(param.title)
    self:SetIcon(param)
    self.unlockType = param.type
    self.flyIcon:SetActive(false)
    self.flyQuest:SetActive(false)
    self.panel:SetInteractable(false)
    self:DeleteTimer()
    local ret,time = self.popUp:PlayAnimationReturnTime("V_ui_jiesuan_title_anim")
    if ret then
        self:AddTimer(time - 1)
    end

    self.root:SetActive(true)
    self.popUp:SetActive(true)

    self.unlockLight:SetActive(false)
    if param.type == UnlockWindowType.Product then
        self.unlockLight:SetActive(true)
    end

    self.anim:Play("CommonPopup_movein", 0, 0)
end

local function AddTimer(self,time)
    self:DeleteTimer()
    self.btnTimer = TimerManager:GetInstance():GetTimer(time, self.timer_action , self, true,false,false)
    self.btnTimer:Start()
end

local function TimerAction(self)
    self:DeleteTimer()
    self.panel:SetInteractable(true)
end

local function DeleteTimer(self)
    if self.btnTimer then
        self.btnTimer:Stop()
        self.btnTimer = nil
    end
end
local function OnClick(self)
    self.panel:SetInteractable(false)
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)

    if (self.data and self.data.flyEndPos) or self.data.type == UnlockWindowType.GuideBtn then
        self:MoveToEndPosAnim(function()
            self:TryShowNext()
        end)
    else
        self:TryShowNext()
    end
end

local function TryShowNext(self)
    self.ctrl:RemoveFirstData()
    local data = self.ctrl:GetShowData()
    if data ~= nil then
        self:InitData(data)
    else
        if self.data and self.data.type then
            if self.data.type == UnlockWindowType.Activity then
                if UIManager:GetInstance():GetWindow(UIWindowNames.UIJeepAdventureMain) == nil then
                    EventManager:GetInstance():Broadcast(EventId.OnUnlockActivityViewClose)
                end
            else
                EventManager:GetInstance():Broadcast(EventId.OnUnlockViewClose)
            end
        end
        self.ctrl:CloseSelf()
    end
end

local function SetIcon(self, param)
    self.unlockIcon:SetActive(false)
    self.unlockQuest:SetActive(false)

    -- 解锁物品或建筑
    if param.type == UnlockWindowType.Product or param.type == UnlockWindowType.Building
            or param.type == UnlockWindowType.Activity or param.type == UnlockWindowType.Item then
        self.unlockIcon:SetActive(true)
        self.unlockIcon:LoadSprite(param.icon, nil, function()
            self.unlockIcon:SetNativeSize()
        end)
        self.unlockIcon_txt:SetText(param.intro)
        local height = self.unlockIcon.rectTransform.sizeDelta.y;
        local width = self.unlockIcon.rectTransform.sizeDelta.x;
        if height < min_pic_height then
            local scale = min_pic_height / height
            self.unlockIcon.rectTransform:Set_sizeDelta(scale * width,  min_pic_height)
        end
        -- 解锁功能
    elseif param.type == UnlockWindowType.GuideBtn then
        self.unlockIcon_txt:SetText(param.intro)
        if param.icon ~= nil and param.icon ~= "" then
            self.unlockIcon:SetActive(true)
            self.unlockIcon:LoadSprite(param.icon, nil, function()
                self.unlockIcon:SetNativeSize()
            end)
            local height = self.unlockIcon.rectTransform.sizeDelta.y;
            local width = self.unlockIcon.rectTransform.sizeDelta.x;
            if height < min_pic_height then
                local scale = min_pic_height / height
                self.unlockIcon.rectTransform:Set_sizeDelta(scale * width,  min_pic_height)
            end
        end
        if self.data.btnType == UnlockBtnType.Quest then
            TimerManager:GetInstance():DelayInvoke(function()
                self.unlockQuest:SetActive(true)
            end, 0.2)
        end
        local cg = self.unlockIcon_txt.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
        cg.alpha = 0
        cg:DOFade(1, 0.3):SetDelay(0.5)
    end
end

local function MoveToEndPosAnim(self, callback)
    self.popUp:Play("V_ui_jiesuan_title_fade_anim", 0, 0)
    self.root:SetActive(false)

    -- 解锁物品或建筑
    if self.data.type == UnlockWindowType.Product or self.data.type == UnlockWindowType.Building then
        self.flyIcon:SetActive(true)
        self.flyIcon:LoadSprite(self.data.icon, nil, function()
            self.flyIcon:SetNativeSize()
        end)
        self.flyIcon.transform:Set_localScale(1, 1, 1)
        self.flyIcon.transform.position = self.unlockIcon.transform.position

        -- 解锁建筑
        if self.data.type == UnlockWindowType.Building then
            local savePos = UIUtil.GetUIMainSavePos(UIMainSavePosType.Build)
            local targetPos = Vector3.New(savePos.x, savePos.y, savePos.z)
            if CS.SceneManager:IsInCity() and LuaEntry.DataConfig:CheckSwitch("quest_early") then
                targetPos.y = targetPos.y - 133
            end

            local targetScale = 91 / self.flyIcon:GetSizeDelta().y
            local flyDir = Vector3.Normalize(targetPos - self.flyIcon.transform.position)
            local uiMain = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
            if uiMain == nil then
                return
            end

            local buildObj = uiMain.View.bottom.build_obj
            buildObj:SetActive(true)

            DOTween.Sequence()
                   :Append(self.flyIcon.transform:DOMove(self.flyIcon.transform.position - flyDir * 20, 0.3)) -- 图标向反方向飞
                   :Append(self.flyIcon.transform:DOMove(targetPos + Vector3.New(2, 18, 0), 0.5)) -- 图标向目标点飞
                   :Join(self.flyIcon.transform:DOScale(Vector3.New(targetScale, targetScale, 1), 0.5)) -- (同时)图标缩小
                   :Join(buildObj.transform:DOMove(targetPos, 0.3)) -- (同时)快捷建造栏出现
                   :AppendCallback(function() -- 图标碰撞快捷建造栏
                self.flyIcon:SetActive(false)
            end)
                   :AppendInterval(0.4) -- 持续时间
                   :AppendCallback(function()
                buildObj.transform.position = savePos
                EventManager:GetInstance():Broadcast(EventId.UnlockBuilding)
                DataCenter.UnlockBtnManager:UnlockEffectComplete(self.data.btnType)
                if callback then
                    callback()
                end
            end)
        else
            DataCenter.UnlockBtnManager:UnlockEffectComplete(self.data.btnType)
            if callback then
                callback()
            end
        end
        -- 解锁功能
    elseif self.data.type == UnlockWindowType.GuideBtn then
        local UIMain = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
        UIMain.View:PlayAnim(UIMainAnimType.ChangeAllShow)

        -- 解锁 Quest
        if self.data.btnType == UnlockBtnType.Quest then
            self.flyQuest:SetActive(true)
            self.flyQuest.transform:Set_position(self.unlockQuest.transform:Get_position())
            TimerManager:GetInstance():DelayInvoke(function()
                local fly = self.flyQuest.transform:GetComponent(typeof(CS.UIGoodsFly))
                local pos = UIUtil.GetUIMainSavePos(UIMainSavePosType.QuestNpc)
                fly:DoAnimForLua(50, 50, 999, nil, 1, pos, function()
                    DataCenter.UnlockBtnManager:UnlockEffectComplete(self.data.btnType)
                    self.flyQuest:SetActive(false)
                    if callback then
                        callback()
                    end
                end)
            end, 0.5)
        else
            DataCenter.UnlockBtnManager:UnlockEffectComplete(self.data.btnType)
            if callback then
                callback()
            end
        end
    else
        DataCenter.UnlockBtnManager:UnlockEffectComplete(self.data.btnType)
        if callback then
            callback()
        end
    end
end

UIUnLockSuccessView.OnCreate= OnCreate
UIUnLockSuccessView.OnDestroy = OnDestroy
UIUnLockSuccessView.OnEnable = OnEnable
UIUnLockSuccessView.OnDisable = OnDisable
UIUnLockSuccessView.ComponentDefine = ComponentDefine
UIUnLockSuccessView.ComponentDestroy = ComponentDestroy
UIUnLockSuccessView.InitData = InitData
UIUnLockSuccessView.DataDefine = DataDefine
UIUnLockSuccessView.DataDestroy = DataDestroy
UIUnLockSuccessView.AddTimer = AddTimer
UIUnLockSuccessView.TimerAction = TimerAction
UIUnLockSuccessView.DeleteTimer = DeleteTimer
UIUnLockSuccessView.OnClick = OnClick
UIUnLockSuccessView.TryShowNext = TryShowNext
UIUnLockSuccessView.SetIcon = SetIcon
UIUnLockSuccessView.MoveToEndPosAnim = MoveToEndPosAnim

return UIUnLockSuccessView
