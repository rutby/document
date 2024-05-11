
--- Created by shimin.
--- DateTime: 2020/8/21 14:36
--- 加速界面

local UIFormationAddStaminaView = BaseClass("UIFormationAddStaminaView", UIBaseView)
local base = UIBaseView

local UIItemCell = require "UI.UIFormation.UIFormationAddStamina.Component.StaminaItem"
local Localization = CS.GameEntry.Localization

local panel_path = "UICommonPopUpTitle/panel"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local title_text_path = "UICommonPopUpTitle/bg_mid/titleText"
local slider_path = "Bg/sliderBg/Slider"
local total_num_path = "Bg/sliderBg/totalNum"
local more_btn_go_path = "MoreBtn"
local use_count_btn_path = "MoreBtn/UseCountBtn"
local use_count_btn_name_path = "MoreBtn/UseCountBtn/UseCountBtnName"
local use_max_btn_path = "MoreBtn/UseMaxBtn"
local use_max_btn_name_path = "MoreBtn/UseMaxBtn/UseMaxBtnName"
local scrollview_path = "Bg/ScrollViews"
local content_path = "Bg/ScrollViews/Content"
local resume_tip_text_path = "Bg/sliderBg/ResumeTipText"
local all_resume_text_path = "Bg/sliderBg/ResumeTipText/AllResumeText"
local infoBtn_path = "Bg/btn_detail"

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ClearScroll()
    self.content:SetAnchoredPosition(Vector2.New(0,0))
    self.content:Dispose()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.btn = self:AddComponent(UIButton, panel_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.total_num = self:AddComponent(UITextMeshProUGUIEx, total_num_path)
    self.content = self:AddComponent(UIBaseContainer,content_path)
    self.more_btn_go = self:AddComponent(UIAnimator, more_btn_go_path)
    self.use_count_btn = self:AddComponent(UIButton, use_count_btn_path)
    self.use_count_btn_name = self:AddComponent(UITextMeshProUGUIEx, use_count_btn_name_path)
    self.use_max_btn = self:AddComponent(UIButton, use_max_btn_path)
    self.use_max_btn_name = self:AddComponent(UITextMeshProUGUIEx, use_max_btn_name_path)

    self.btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self.use_count_btn:SetOnClick(function()
        self:MoreBtnClick()
    end)
    self.timer_action = function(temp)
        self:RefreshFormationStamina()
    end
    self.scrollview = self:AddComponent(UIBaseContainer, scrollview_path)
    self.content = self:AddComponent(GridInfinityScrollView, content_path)
    self.resume_tip_text = self:AddComponent(UITextMeshProUGUIEx, resume_tip_text_path)--obsolete
    self.all_resume_text = self:AddComponent(UITextMeshProUGUIEx, all_resume_text_path)--obsolete
    self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
    self.infoBtnN:SetOnClick(function()
        self:OnStateBtnClick()
    end)
end

local function ComponentDestroy(self)
    self.more_btn_go.transform:SetParent(self.transform)
    self.more_btn_go:SetActive(false)
    self.btn = nil
    self.close_btn = nil
    self.title_text = nil
    self.slider = nil
    self.total_num = nil
    self.scrollview = nil
    self.content = nil
    self.more_btn_go = nil
    self.more_btn = nil
    self.more_btn_name = nil
    self.use_count_btn = nil
    self.use_count_btn_name = nil
    self.use_max_btn = nil
    self.use_max_btn_name = nil
    self.resume_tip_text = nil
    self.all_resume_text = nil
    self.all_resume_time = nil
end


local function DataDefine(self)
    self.moreItemId = nil
    self.moreBtnMax = nil
    self.moreIndex = nil
    self.items = {}
    self.cells = {}
    self.moreParent = nil
    self.isCreateScroll = false
    self.sendMessage = false
    self.isShowMore = false
    self.listGO = {}
    self.resumeSpeed = 0
    self.resumeIsTrue = nil
end

local function DataDestroy(self)
    self.moreItemId = nil
    self.moreBtnMax = nil
    self.moreIndex = nil
    self.items = nil
    self.cells = nil
    self.moreParent = nil
    self.resumeSpeed = nil
    self.resumeIsTrue = nil
end

local function OnEnable(self)
    base.OnEnable(self)
    self:ReInit()
    self:AddTimer()
end

local function OnDisable(self)
    self:DeleteTimer()
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
    self:AddUIListener(EventId.FormationStaminaUpdate,self.RefreshFormationStamina)
    self:AddUIListener(EventId.UserGoldCoverStamina,self.OnUseGoldCallBack)
    self:AddUIListener(EventId.UserItemCoverStamina,self.OnUseCallBack)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
    self:RemoveUIListener(EventId.FormationStaminaUpdate,self.RefreshFormationStamina)
    self:RemoveUIListener(EventId.UserGoldCoverStamina,self.OnUseGoldCallBack)
    self:RemoveUIListener(EventId.UserItemCoverStamina,self.OnUseCallBack)
end

local function RefreshFormationStamina(self)
    self.maxNum = 100
    local config = DataCenter.ArmyFormationDataManager:GetConfigData()
    if config~=nil then
        self.maxNum = config.FormationStaminaMax
        self.resumeSpeed = config.FormationStaminaUpdateTime
    end
    self.curNum = LuaEntry.Player:GetCurStamina()
    local tempValue = math.min(1,(self.curNum/self.maxNum))
    self.slider:SetValue(tempValue)
    self.total_num:SetText(string.GetFormattedSeperatorNum(math.floor(self.curNum)).."/"..string.GetFormattedSeperatorNum(math.floor(self.maxNum)))

    --local curStamina = LuaEntry.Player.stamina
    --local delta = self.maxNum - curStamina
    --local curTime = UITimeManager:GetInstance():GetServerTime()
    --local leftTime = self.resumeSpeed * delta * 1000 + LuaEntry.Player.lastStaminaTime - curTime
    --if delta <= 0 or leftTime <= 0 then
        --if self.resumeIsTrue ~= false then
        --    self.all_resume_text:SetLocalText(GameDialogDefine.STAMINA_FULL)
        --    self.resumeIsTrue = false
        --end
    --else
        --if self.resumeIsTrue ~= true then
        --    self.resumeIsTrue = true
        --end
        --local restTime = UITimeManager:GetInstance():MilliSecondToFmtString(math.floor(leftTime))
        --local nameStr = Localization:GetString(GameDialogDefine.ALL_RESUME)..": ".."<color=#27BE8C>"..restTime.."</color>"
        --self.all_resume_text:SetText(nameStr)
    --end
end

local function MoreBtnClick(self)
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Speed_Button)
    local item = DataCenter.ItemData:GetItemById(self.moreItemId)
    if item~=nil then
        SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = item.uuid,num = self.moreBtnMax })
    end
end

local function OnUseCallBack(self)
    self.sendMessage = false
    self:RefreshFormationStamina()
    local item = DataCenter.ItemData:GetItemById(self.moreItemId)
    if item == nil then
        self:HideMoreBtn()
        self.items = self.ctrl:GetItemList()
        self.content:SetItemCount(#self.items)
        self.content:ForceUpdate()
    else
        if item.count > 1 and self.isShowMore == false then
            self.more_btn_go:SetActive(true)
            self:ShowMoreBtn()
            self:ShowMoreBtnName(item)
            if self.cells[self.moreIndex] ~= nil then   
                self.cells[self.moreIndex]:RefreshOwnCount(item.count)
            end
        else
            self.more_btn_go:SetActive(false)
            self.items = self.ctrl:GetItemList()
            self.content:SetItemCount(#self.items)
            self.content:ForceUpdate()
            self:HideMoreBtn()
            if self.cells[self.moreIndex] ~= nil then
                self.cells[self.moreIndex]:RefreshOwnCount(item.count)
            end
        end
    end
end

local function OnUseGoldCallBack(self)
    self.sendMessage =false
    self:RefreshFormationStamina()
    for k,v in pairs(self.cells) do
        v:RefreshGoldData()
    end
    
end
local function ReInit(self)
    self.title_text:SetLocalText(104217)
    self.more_btn_go:SetActive(false)
    self:ShowCells()
    self:RefreshFormationStamina()
    --local config = DataCenter.ArmyFormationDataManager:GetConfigData()
    --if config ~=nil then
    --    self.resume_tip_text:SetLocalText(GameDialogDefine.STAMINA_RESUME_ONR_POINT_NEED_TIME, math.ceil(config.FormationStaminaUpdateTime))
    --end
end


local function ShowCells(self)
    self.items = self.ctrl:GetItemList()
    self.more_btn_go:SetActive(false)
    local count = #self.items
    if not self.isCreateScroll then
        local bindFunc1 = BindCallback(self, self.OnInitScroll)
        local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
        local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
        self.content:Init(bindFunc1,bindFunc2, bindFunc3)
    end
    self.content:SetAnchoredPosition(Vector2.New(0,0))
    self.content:SetItemCount(count)
    self.content:ForceUpdate()
    self.isCreateScroll = true
end

local function ClearScroll(self)
    self.scrollview:RemoveComponents(UIItemCell)
    self.content:DestroyChildNode()
end


local function OnInitScroll(self,go,index)
    local item = self.scrollview:AddComponent(UIItemCell, go)
    self.listGO[go] = item
end

local function OnUpdateScroll(self,go,index)
    local cellItem = self.listGO[go]
    if not cellItem then
        return
    end
    local param = {}
    param.callBack = function(_index,itemId,isBuy,price) self:CellsCallBack(_index,itemId,isBuy,price) end
    param.index = index+1
    param.info = self.items[index+1]
    cellItem:ReInit(param)
    self.cells[index+1] = cellItem
end

local function OnDestroyScrollItem(self,go, index)
    if self.showTimer == nil then
        self:HideMoreBtn()
    end
end

local function CellsCallBack(self,index,itemId,isBuy,price)
    if self.sendMessage == true then
        return
    end
    if isBuy then
        self:HideMoreBtn()
        if LuaEntry.Player.gold >= price then
            self.sendMessage = true
            SFSNetwork.SendMessage(MsgDefines.UserRecoverPlayerStamina)
        else
            GoToUtil.GotoPayTips()
        end
    else
        self.moreItemId = itemId
        self.moreIndex = index
        local item = DataCenter.ItemData:GetItemById(itemId)
        self.sendMessage = true
        SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = item.uuid,num = 1 })
    end
end

local function ShowMoreBtn(self)
    self.isShowMore = true
    local moreParent = self.cells[self.moreIndex]:GetMoreBtnParent()
    if self.moreParent ~= moreParent then
        self.moreParent = moreParent
        self.more_btn_go.transform:SetParent(moreParent)
        self.more_btn_go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        local ret,time = self.more_btn_go:PlayAnimationReturnTime("ShowMoreBtn")
        if ret then
            self.showTimer = TimerManager:GetInstance():GetTimer(time + 0.5, function()
                if self.showTimer ~= nil then
                    self.showTimer:Stop()
                    self.showTimer = nil
                end
            end , self, true,false,false)
            self.showTimer:Start()
        end
    end
end

local function HideMoreBtn(self)
    if self.moreParent then
        self.moreParent = nil
        self.more_btn_go.transform:SetParent(self.transform)
        self.more_btn_go.transform:SetAsFirstSibling()
        self.more_btn_go:Play("CloseMoreBtn",0,0)
    end
    self.isShowMore = false
end

local function ShowMoreBtnName(self,item)
    self.moreBtnMax = item.count
    self.curNum = LuaEntry.Player:GetCurStamina()
    local restNum = self.maxNum- self.curNum
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.moreItemId)
    if template.para ~= nil and template.para ~= "" and restNum>0 then
        local resourceCount = tonumber(template.para)
        if resourceCount~=nil and resourceCount>0 then
            self.moreBtnMax = math.floor((restNum) / resourceCount)
        end
    end
    if self.moreBtnMax > item.count then
        self.moreBtnMax = item.count
    end
    if self.moreBtnMax > 0 then
        self.use_count_btn_name:SetText("x"..self.moreBtnMax)
    else
        self.more_btn_go:SetActive(false)
    end
end

local function UpdateGoldSignal(self)
    local gold = LuaEntry.Player.gold
    for k,v in pairs(self.cells) do
        v:RefreshColor(gold)
    end
end

local function AddTimer(self)
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self, false,false,false)
    end
    self.timer:Start()
end

local function DeleteTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end


local function OnStateBtnClick(self)
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.infoBtnN.gameObject.transform.position  + Vector3.New(180, -50, 0) * scaleFactor
    local endTime = 0
    -- + Vector3.New(-19, 30, 0) * scaleFactor
    local time = UIUtil.GetEnergyRecoverTime()
    local title = Localization:GetString("104198", math.floor(time))
    local speedAddEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.STAMINA_RECOVER_SPEED_ADD)

    local content0 = speedAddEffect > 0 and (Localization:GetString("320292").."+"..math.floor(speedAddEffect).."%") or ""
    local content1 = Localization:GetString("104199")
    local content2 = Localization:GetString("104200")
    local maxAddEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.STAMINA_MAX_LIMIT)
    local maxBase = LuaEntry.DataConfig:TryGetNum("car_stamina", "k1")
    local maxStamina = maxBase + maxAddEffect
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = curTime - LuaEntry.Player.lastStaminaTime
    local curStamina = LuaEntry.Player.stamina
    if curStamina < maxStamina and time > 0 then
        local delta = math.max(maxStamina - curStamina, 1)
        local needTime = delta * time * 1000
        if needTime > deltaTime then
            endTime = LuaEntry.Player.lastStaminaTime + needTime
        end
    end
    local param = {}
    param.title = title
    param.content0 = content0
    param.content1 = content1
    param.content2 = content2
    param.endTime = endTime
    param.position = position
    param.isLeft  = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationTip, { anim = false }, param)
end


UIFormationAddStaminaView.OnCreate = OnCreate
UIFormationAddStaminaView.OnDestroy = OnDestroy
UIFormationAddStaminaView.OnEnable = OnEnable
UIFormationAddStaminaView.OnDisable = OnDisable
UIFormationAddStaminaView.ComponentDefine = ComponentDefine
UIFormationAddStaminaView.ComponentDestroy = ComponentDestroy
UIFormationAddStaminaView.DataDefine = DataDefine
UIFormationAddStaminaView.DataDestroy = DataDestroy
UIFormationAddStaminaView.OnAddListener = OnAddListener
UIFormationAddStaminaView.OnRemoveListener = OnRemoveListener
UIFormationAddStaminaView.MoreBtnClick = MoreBtnClick
UIFormationAddStaminaView.ClearScroll = ClearScroll
UIFormationAddStaminaView.ReInit = ReInit
UIFormationAddStaminaView.ShowCells = ShowCells
UIFormationAddStaminaView.CellsCallBack = CellsCallBack
UIFormationAddStaminaView.ShowMoreBtn = ShowMoreBtn
UIFormationAddStaminaView.ShowMoreBtnName = ShowMoreBtnName
UIFormationAddStaminaView.UpdateGoldSignal = UpdateGoldSignal
UIFormationAddStaminaView.HideMoreBtn = HideMoreBtn
UIFormationAddStaminaView.OnInitScroll = OnInitScroll
UIFormationAddStaminaView.OnUpdateScroll = OnUpdateScroll
UIFormationAddStaminaView.OnDestroyScrollItem = OnDestroyScrollItem
UIFormationAddStaminaView.DeleteTimer  =DeleteTimer
UIFormationAddStaminaView.AddTimer =AddTimer
UIFormationAddStaminaView.OnUseGoldCallBack = OnUseGoldCallBack
UIFormationAddStaminaView.OnUseCallBack = OnUseCallBack
UIFormationAddStaminaView.RefreshFormationStamina =RefreshFormationStamina
UIFormationAddStaminaView.OnStateBtnClick =OnStateBtnClick
return UIFormationAddStaminaView