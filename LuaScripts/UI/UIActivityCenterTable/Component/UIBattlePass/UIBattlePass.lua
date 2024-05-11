---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 
---

local UIBattlePass = BaseClass("UIBattlePass", UIBaseContainer)
local base = UIBaseContainer
local UIBattlePassTaskCell = require "UI.UIActivityCenterTable.Component.UIBattlePass.UIBattlePassTaskCell"
local UIBattlePassRewardItem = require "UI.UIActivityCenterTable.Component.UIBattlePass.UIBattlePassRewardItem"
local UIGiftPackagePoint = require "UI.UIGiftPackage.Component.UIGiftPackagePoint"
local Localization = CS.GameEntry.Localization

local titleBg_path = "Root/TitleBg"
local time_txt_path = "Root/TitleBg/NotStarted/Txt_Times"
local actIcon_img_path = "Root/TitleBg/Img_ActIcon"
local actName_txt_path = "Root/TitleBg/Txt_ActName"
local lvTitle_txt_path =  "Root/TitleBg/Txt_LvTitle"
local passLv_txt_path = "Root/TitleBg/Txt_PassLv"
local buy_btn_path = "Root/BuyBtn"
local buyBg_path = "Root/TitleBg/Bg_Buy"
local buy_text_path = "Root/BuyBtn/BuyText"
local buyTitle_text_path = "Root/TitleBg/Bg_Buy/Txt_BuyTitle"
local progress_img_path = "Root/TitleBg/Img_Progress"
local progress_txt_path  = "Root/TitleBg/Img_Progress/Txt_Progress"
local add_btn_path = "Root/TitleBg/Btn_Add"

local toggle1_path =  "Root/middle/ToggleGroupBg/Rect_Group/Toggle1"
local toggle2_path =  "Root/middle/ToggleGroupBg/Rect_Group/Toggle2"
local toggle3_path =  "Root/middle/ToggleGroupBg/Rect_Group/Toggle3"

local toggleCheckMark1_path = "Root/middle/ToggleGroupBg/Rect_Group/Toggle1/Background/Checkmark1"
local toggleArrow1_path = "Root/middle/ToggleGroupBg/Rect_Group/Toggle1/Background/Checkmark1/arrow1"
local toggleText1_path =  "Root/middle/ToggleGroupBg/Rect_Group/Toggle1/text1"
local toggleCheckText1_path =  "Root/middle/ToggleGroupBg/Rect_Group/Toggle1/checkText1"
local toggleCheckMark2_path = "Root/middle/ToggleGroupBg/Rect_Group/Toggle2/Background/Checkmark2"
local toggleArrow2_path = "Root/middle/ToggleGroupBg/Rect_Group/Toggle2/Background/Checkmark2/arrow2"
local toggleText2_path =  "Root/middle/ToggleGroupBg/Rect_Group/Toggle2/text2"
local toggleCheckText2_path =  "Root/middle/ToggleGroupBg/Rect_Group/Toggle2/checkText2"
local toggleCheckMark3_path = "Root/middle/ToggleGroupBg/Rect_Group/Toggle3/Background/Checkmark3"
local toggleArrow3_path = "Root/middle/ToggleGroupBg/Rect_Group/Toggle3/Background/Checkmark3/arrow3"
local toggleText3_path =  "Root/middle/ToggleGroupBg/Rect_Group/Toggle3/text3"
local toggleCheckText3_path =  "Root/middle/ToggleGroupBg/Rect_Group/Toggle3/checkText3"


local scroll_view_path = "Root/Mask/ScrollView"
local scroll_content_path = "Root/Mask/ScrollView/rewardContent"
local nextReward_path = "Root/Mask/NextReward"
local mask_path = "Root/Mask"
local freeReward_txt_path = "Root/Mask/BoxBg/Txt_FreeReward"
local boxLock_img_path = "Root/Mask/BoxBg/BoxBottom/BoxLock"
local boxLock_btn_path = "Root/Mask/BoxBg/BoxBottom"
local payReward_txt_path = "Root/Mask/BoxBg/BoxBottom/Txt_PayReward"

local task_view_path = "Root/TaskBg"
local task_content_path = "Root/TaskBg/TaskView/Content"

local point_path = "Root/BuyBtn/UIGiftPackagePoint"

local oneGet_btn_path = "Root/Mask/Btn_List/Btn_OneGet"
local oneGet_txt_path = "Root/Mask/Btn_List/Btn_OneGet/Txt_OneGet"
local oneGetRed_rect_path = "Root/Mask/Btn_List/Btn_OneGet/Rect_OnGetRed"

local extra_rect_path = "Root/Mask/ExtraBg"
local extraBox_btn_path = "Root/Mask/ExtraBg/Btn_ExtraBox"
local extraTitle_txt_path = "Root/Mask/ExtraBg/Txt_ExtraTitle"
local extraInfo_btn_path = "Root/Mask/ExtraBg/Btn_ExtraInfo"
local exchangeNum_txt_path = "Root/Mask/ExtraBg/Txt_ExchangeNum"
local exchangeDes_txt_path = "Root/Mask/ExtraBg/Txt_ExchangeDes"
local txtCurLv_path = "Root/Mask/BoxBg/curLvBg/textCurLevel"

local intro_btn_path = "Root/TitleBg/Intro"
local taskTitle_txt_path = "Root/TaskBg/Txt_TaskTitle"
local lock_path = "Root/Mask/ExtraBg/Lock"
local extraRedDot_path = "Root/Mask/ExtraBg/ExtraRedDot"
local txtExtraRedNum_path = "Root/Mask/ExtraBg/ExtraRedDot/TxtExtraRedNum"
local particleMask_path = "Root/Mask/ScrollView/ParticleMask"
local baseImage_path = "Root/Mask/ScrollView/BaseImage"

--local particleDeltaY = 860
--local particleMaskScaleY = 17500 --23700
--local devScreenHeight = 1334
local scaleFactor =  50

local GetRewardType =
{
    None = -1,
    Normal = 0,
    Special = 1,
}

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    if self.pointEffect ~= nil then
        self.pointEffect:Stop()
        self.pointEffect = nil
    end
    self:ClearScroll()
    self:DeleteTimer()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
	self.playSound = false
    self.toggle1:SetIsOn(true)
    self.toggle2:SetIsOn(false)
    self.toggle3:SetIsOn(false)
end

local function ComponentDefine(self)
    self._actName_txt = self:AddComponent(UITextMeshProUGUIEx, actName_txt_path)
    self._passLv_txt = self:AddComponent(UITextMeshProUGUIEx, passLv_txt_path)
    self.lvTitle_txt = self:AddComponent(UITextMeshProUGUIEx,lvTitle_txt_path)
    self.lvTitle_txt:SetLocalText(100082)
    self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
    self.buy_btn:SetOnClick(function()
        self:OnBuyClick()
    end)
    self.buyBg = self:AddComponent(UIBaseContainer, buyBg_path)
    self.buy_text = self:AddComponent(UITextMeshProUGUIEx, buy_text_path)
    self._buyTitle_txt = self:AddComponent(UITextMeshProUGUIEx,buyTitle_text_path)
    self._buyTitle_txt:SetLocalText(320464)
    self._time_txt = self:AddComponent(UITextMeshProUGUIEx,time_txt_path)
    self._progress_img = self:AddComponent(UISlider,progress_img_path)
    self._progress_txt = self:AddComponent(UITextMeshProUGUIEx,progress_txt_path)
    self._add_btn = self:AddComponent(UIButton,add_btn_path)
    self._add_btn:SetOnClick(function()
        self:OnBuyLvUpClick()
    end)
    
    self._actIcon_img = self:AddComponent(UIImage,actIcon_img_path)
    
    self.toggle1 = self:AddComponent(UIToggle,toggle1_path)
    self.toggle2 = self:AddComponent(UIToggle,toggle2_path)
    self.toggle3 = self:AddComponent(UIToggle,toggle3_path)

    self.toggleCheckMark1 = self:AddComponent(UIBaseContainer, toggleCheckMark1_path)
    self.toggleArrow1 = self:AddComponent(UIBaseContainer, toggleArrow1_path)
    self.toggleText1 = self:AddComponent(UITextMeshProUGUIEx,toggleText1_path)
    self.toggleCheckText1 = self:AddComponent(UITextMeshProUGUIEx,toggleCheckText1_path)
    self.toggleText1:SetLocalText(130065)
    self.toggleCheckText1:SetLocalText(130065)
    self.toggleCheckMark2 = self:AddComponent(UIBaseContainer, toggleCheckMark2_path)
    self.toggleArrow2 = self:AddComponent(UIBaseContainer, toggleArrow2_path)
    self.toggleText2 = self:AddComponent(UITextMeshProUGUIEx,toggleText2_path)
    self.toggleCheckText2 = self:AddComponent(UITextMeshProUGUIEx,toggleCheckText2_path)
    self.toggleText2:SetLocalText(170015)
    self.toggleCheckText2:SetLocalText(170015)
    self.toggleCheckMark3 = self:AddComponent(UIBaseContainer, toggleCheckMark3_path)
    self.toggleArrow3 = self:AddComponent(UIBaseContainer, toggleArrow3_path)
    self.toggleText3 = self:AddComponent(UITextMeshProUGUIEx,toggleText3_path)
    self.toggleCheckText3 = self:AddComponent(UITextMeshProUGUIEx,toggleCheckText3_path)
    self.toggleText3:SetLocalText(320430)
    self.toggleCheckText3:SetLocalText(320430)

    self.toggle1:SetIsOn(true)
    self.toggle1:SetOnValueChanged(function(tf)
        if tf then
            self:ToggleControlBorS(1)
        end
    end)
    self.toggle2:SetIsOn(false)
    self.toggle2:SetOnValueChanged(function(tf)
        if tf then
            self:ToggleControlBorS(2)
        end
    end)
    self.toggle3:SetIsOn(false)
    self.toggle3:SetOnValueChanged(function(tf)
        if tf then
            self:ToggleControlBorS(3)
        end
    end)

    self.toggleList = {}
    for i = 1 ,3 do
        self.toggleList[i] = {}
        self.toggleList[i].img = self:AddComponent(UIImage,"Root/middle/ToggleGroupBg/Rect_Group/Toggle"..i.."/RedDot"..i)
        self.toggleList[i].txt = self:AddComponent(UITextMeshProUGUIEx,"Root/middle/ToggleGroupBg/Rect_Group/Toggle"..i.."/RedDot"..i.."/Txt_RedNum"..i)
    end

    self.scroll_view = self:AddComponent(UIBaseContainer,scroll_view_path)
    self.scroll_content = self:AddComponent(GridInfinityScrollView, scroll_content_path)
    self.mask_go = self:AddComponent(UIBaseContainer, mask_path)
    
    self.task_view = self:AddComponent(UIBaseContainer,task_view_path)
    self.task_content = self:AddComponent(GridInfinityScrollView, task_content_path)
    
    self.nextReward = self:AddComponent(UIBattlePassRewardItem,nextReward_path)
    
    self.point_rect = self:AddComponent(UIGiftPackagePoint,point_path)
    
    self._oneGet_btn = self:AddComponent(UIButton,oneGet_btn_path)
    self._oneGet_btn:SetOnClick(function()
        self:OneGetClick()
    end)
    self._oneGetRed_rect = self:AddComponent(UITextMeshProUGUIEx,oneGetRed_rect_path)
    self._oneGet_txt = self:AddComponent(UITextMeshProUGUIEx,oneGet_txt_path)
    self._oneGet_txt:SetLocalText(110132)
    
    self._extra_rect = self:AddComponent(UIBaseContainer,extra_rect_path)
    self._extraTitle_txt = self:AddComponent(UITextMeshProUGUIEx,extraTitle_txt_path)
    self._extraTitle_txt:SetLocalText(130338)
    self._extraInfo_btn = self:AddComponent(UIButton,extraInfo_btn_path)
    self._extraInfo_btn:SetOnClick(function()
        self:OnExtraClick()
    end)
    self._extraBox_btn = self:AddComponent(UIButton,extraBox_btn_path)
    self._extraBox_btn:SetOnClick(function()
        self:OnBoxClick()
    end)
    self._extraBox_anim = self:AddComponent(UIAnimator,extraBox_btn_path)
    self._exchangeNum_txt = self:AddComponent(UITextMeshProUGUIEx,exchangeNum_txt_path)
    self._exchangeDes_txt = self:AddComponent(UITextMeshProUGUIEx,exchangeDes_txt_path)
    self._exchangeDes_txt:SetLocalText(470060)
    self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
    self.intro_btn:SetOnClick(function()
        self:OnIntroClick()
    end)
    
    self._boxLock_img = self:AddComponent(UIImage,boxLock_img_path)
    self.boxLock_btn = self:AddComponent(UIButton,boxLock_btn_path)
    self.boxLock_btn:SetOnClick(function()
        self:OnClickBoxLock()
    end)
    self._payReward_txt = self:AddComponent(UITextMeshProUGUIEx,payReward_txt_path)
    self._payReward_txt:SetLocalText(320437)
    
    self._freeReward_txt = self:AddComponent(UITextMeshProUGUIEx,freeReward_txt_path)
    self._freeReward_txt:SetLocalText(320465)
    
    self._taskTitle_txt = self:AddComponent(UITextMeshProUGUIEx,taskTitle_txt_path)
    self._taskTitle_txt:SetLocalText(320441)
    
    self.txtCurLv = self:AddComponent(UITextMeshProUGUIEx, txtCurLv_path)
    self.lock = self:AddComponent(UIBaseContainer, lock_path)
    self.extraRedDot = self:AddComponent(UIBaseContainer, extraRedDot_path)
    self.txtExtraRedNum = self:AddComponent(UITextMeshProUGUIEx, txtExtraRedNum_path)
    self.particleMask = self:AddComponent(UIBaseContainer, particleMask_path)
    self.titleBg = self:AddComponent(UIImage,titleBg_path)
    self.goTextMat = self.transform:Find("Root/TitleBg/Txt_ActName/goTextMat"):GetComponent(typeof(CS.UnityEngine.MeshRenderer))
    
    self.baseImage = self:AddComponent(UIImage,baseImage_path)
    self.baseImage.anchorMin = Vector2.New(0.5, 0.5)
    self.baseImage.anchorMax =  Vector2.New(0.5, 0.5)
    local rect = self.baseImage.rectTransform.rect
    self.particleMask:SetLocalScaleXYZ(self.particleMask.rectTransform.localScale.x, rect.height * scaleFactor, 1)
    --local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    --local screenSize = CS.UnityEngine.Screen
    --local scale = (screenSize.height / scaleFactor ) / (devScreenHeight )
    --self.particleMask:SetLocalScaleXYZ(self.particleMask.rectTransform.localScale.x, particleMaskScaleY * scaleFactor, 1)
end

local function ComponentDestroy(self)
    self._actName_txt = nil
    self.buy_btn = nil
    self.buy_text = nil
    self.buy_desc_text = nil
    self.point_rect = nil
    self._boxLock_img = nil
    self.scroll_view = nil
    self.mask_go = nil
    self._taskTitle_txt = nil
    self.baseImage.anchorMin = Vector2.New(0, 0)
    self.baseImage.anchorMax =  Vector2.New(1, 1)
end

local function DataDefine(self)
    self.view = nil
    self.specialUnlocked = nil -- 是否已经付费解锁下层奖励
    self.itemList = {}
    self.curLevel = 0
    self.curIndex = 0
    self.packageInfo = nil
    self.nextLv = true
    self.timer = nil
    self.timer_action = function(temp)
        self:RefreshTime(temp)
    end
    self.actEnd = false
    self.playSound = false
end

local function DataDestroy(self)
    self.view = nil
    self.specialUnlocked = nil
    self.itemList = nil
    self.curLevel = nil
    self.curIndex = nil
    self.listGO = nil
    self.listGOReward = nil
    self.nextReward:SetActive(false)
    self.nextLv = nil
    self.timer_action = nil
    self.actEnd = nil
    self.playSound = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.ActBattlePass, self.OnRefresh)
    self:AddUIListener(EventId.ActBattlePassRefresh, self.RefreshBattlePass)
    self:AddUIListener(EventId.ActBattlePassStage, self.RefreshRewardCell)
    self:AddUIListener(EventId.ActBattlePassTask, self.RefreshTaskCell)
  --  self:AddUIListener(EventId.UpdateGiftPackData, self.OnBuyPackageSucc)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.ActBattlePass, self.OnRefresh)
    self:RemoveUIListener(EventId.ActBattlePassRefresh, self.RefreshBattlePass)
    self:RemoveUIListener(EventId.ActBattlePassStage, self.RefreshRewardCell)
    self:RemoveUIListener(EventId.ActBattlePassTask, self.RefreshTaskCell)
    --self:RemoveUIListener(EventId.UpdateGiftPackData, self.OnBuyPackageSucc)
end

local function SetData(self,activityId,actId)
    self.activityId = activityId
    self.curType = 0
    DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(actId)
    self:OnRefresh()
end

local function OnRefresh(self)
	self.playSound = false
    self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    if self.actData and self.actData.lastResetTime == nil then
        SFSNetwork.SendMessage(MsgDefines.GetBattlePassInfo,toInt(self.activityId))
        return
    else
        if not UITimeManager:GetInstance():IsSameDayForServer(self.actData.lastResetTime,curTime) then
            SFSNetwork.SendMessage(MsgDefines.GetBattlePassInfo,toInt(self.activityId))
            return
        end
    end
    self.lastLv = self.actData.battlePass.level
    self.txtCurLv:SetText(self.actData.battlePass.level)
    self:RefreshTop()
    self:RefreshRed()
    self:ShowCells()
    self:ToggleControlBorS(1)
    if self.actData then
        self._boxLock_img:SetActive(self.actData.battlePass.unlock == 0)
    end
end

--顶部更新
local function RefreshTop(self,lastLv)
    local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if actListData then
        local config = BattlePassTitleConfig[actListData.activity_pic] or BattlePassTitleConfig["PassBlackWoman"]
        self._actName_txt:SetLocalText(actListData.name)
        self._actName_txt:SetColorGradient(config.TitleTopColor, config.TitleTopColor, config.TitleBottomColor, config.TitleBottomColor)
        self._actName_txt:SetMaterial(self.goTextMat.sharedMaterials[config.OutlineNum])
        self:RefreshTime(actListData)
        self:AddTimer(actListData)
        if actListData.activity_pic ~= "" then
            self.titleBg:LoadSprite(LoadPath.UIBattlePassBgPath..actListData.activity_pic)
        end
    end
    
    self.packageInfo = GiftPackageData.get(self.actData:GetExchangeId())
    if self.packageInfo and self.actData.battlePass.unlock == 0 then
        self.buy_btn:SetActive(true)
        self.buyBg:SetActive(true)
        local price = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
        self.buy_text:SetText(price)
        self.point_rect:RefreshPoint(self.packageInfo)
    else
        self.buy_btn:SetActive(false)
        self.buyBg:SetActive(false)
    end
    local template = DataCenter.ActBattlePassTemplateManager:GetTemplateById(toInt(self.activityId),self.actData.battlePass.level)
    self._progress_txt:SetLocalText(150033,self.actData.battlePass.exp,template.levelUpExp)
    self.highReward = DataCenter.ActBattlePassTemplateManager:GetTemplateHighRewardById(toInt(self.activityId))
    
    --进度
    local passLv = 0
    if lastLv then
        local isLvUp = 0
        isLvUp = (self.actData.battlePass.level - lastLv)
        if isLvUp > 0 then  --升级了
            self._progress_img:DOValue(1,0.3,function()
                self._progress_img:SetValue(0)
                self._progress_img:DOValue(self.actData.battlePass.exp/template.levelUpExp,0.3,function()
                    self._passLv_txt:SetText("Lv."..self.actData.battlePass.level)
                    passLv = self.actData.battlePass.level
                    self.pointEffect =  TimerManager:GetInstance():DelayInvoke(function()
                    end, 0.5)
                end)
            end)
        else
            self._progress_img:DOValue(self.actData.battlePass.exp/template.levelUpExp,0.3,function()
                self._passLv_txt:SetText("Lv."..self.actData.battlePass.level)
                passLv = self.actData.battlePass.level
            end)
        end
        self.lastLv = self.actData.battlePass.level
    else
        local lv = passLv
        if lv ~= "" then
            if tonumber(lv) < self.actData.battlePass.level then
                self.pointEffect =  TimerManager:GetInstance():DelayInvoke(function()
                end, 0.5)
            end
        end
        self._passLv_txt:SetText("Lv."..self.actData.battlePass.level)
        self._progress_img:SetValue(self.actData.battlePass.exp/template.levelUpExp)
    end
end

local function AddTimer(self,actListData)
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action ,actListData , false,false,false)
    end
    self.timer:Start()
end

local function RefreshTime(self,actListData)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if actListData.endTime < curTime then
        self:DeleteTimer()
        self.actEnd = true
    else
        if actListData:CheckIfIsToEnd() then
            self._time_txt:SetColorRGBA(0.91, 0.26, 0.26, 1)
        else
            self._time_txt:SetColor(WhiteColor)
        end
        self.actEnd = false
        self._time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(actListData.endTime - curTime))
    end
end

local function DeleteTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

local function GetActState(self)
    return self.actEnd
end

--红点更新
local function RefreshRed(self)
    for i = 1 ,3 do
        local num = self.actData:GetRedNum(i)
        if num > 0 then
            self.toggleList[i].img:SetActive(true)
            self.toggleList[i].txt:SetText(num)
        else
            self.toggleList[i].img:SetActive(false)
        end
    end
    local oneGetNum = self.actData:GetRedNum(1)
    self._oneGetRed_rect:SetActive(oneGetNum > 0)
    local extraRedNum = self.actData:GetExtraRedNum()
    self.extraRedDot:SetActive(extraRedNum > 0)
    self.txtExtraRedNum:SetText(extraRedNum)
end

--type 1每日任务   2常驻任务
local function InitTask(self,type)
    if self.listGO then
        return
    end
    self.listGO = {}
    local bindFunc1 = BindCallback(self, self.OnInitScroll)
    local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
    local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
    self.task_content:Init(bindFunc1,bindFunc2, bindFunc3)
    self.taskList = self.actData.taskArr[type]
    self.task_content:SetItemCount(#self.taskList)
end

local function OnInitScroll(self,go,index)
    local item = self.task_view:AddComponent(UIBattlePassTaskCell, go)
    self.listGO[go] = item
end

local function OnUpdateScroll(self,go,index)
    local sub = self.taskList[index + 1]
    local cellItem = self.listGO[go]
    if sub == nil then
        return
    end
    local param = {}
    param.info = sub
    param.index = index + 1
    param.actId = toInt(self.activityId)
    param.unlock = self.actData.battlePass.unlock
    param.flyPos = self._actIcon_img.transform.position
    param.callBack = function() return self:GetActState() end
  --  param.callBack = function(tempIndex) self:OnClickCallBack(tempIndex) end
    cellItem:RefreshData(param)
end

local function OnDestroyScrollItem(self,go, index)

end

--奖励展示
local function ShowCells(self)
    self.scrollDelta = self.scroll_content:GetSizeDelta()
    --是否满级
    local nextTemplate = DataCenter.ActBattlePassTemplateManager:GetTemplateById(toInt(self.activityId),self.actData.battlePass.level+1)
    if nextTemplate then
        self.nextLv = true
        self._add_btn:SetActive(true)
        self.nextReward:SetActive(true)
        self._extra_rect:SetActive(false)
        self._exchangeNum_txt:SetActive(false)
        self._exchangeDes_txt:SetActive(false)
    else
        self.nextLv = false
        self._add_btn:SetActive(false)
        self.nextReward:SetActive(false)
        self._extra_rect:SetActive(true)
        self:CheckExtraBox()
        if self.actData.battlePass.unlock == 1 then
            self._exchangeNum_txt:SetActive(true)
            self._exchangeNum_txt:SetLocalText(150033,self.actData.battlePass.exp,self.actData.extraExp)
            self.lock:SetActive(false)
            self._exchangeDes_txt:SetActive(false)
        else
            self._exchangeDes_txt:SetActive(true)
            self.lock:SetActive(true)
        end
    end
    if self.listGOReward then
        return
    end
    self.listGOReward = {}
    local bindFunc1 = BindCallback(self, self.OnInitRewardScroll)
    local bindFunc2 = BindCallback(self, self.OnUpdateRewardScroll)
    local bindFunc3 = BindCallback(self, self.OnDestroyRewardScrollItem)
    self.scroll_content:Init(bindFunc1,bindFunc2, bindFunc3)
    local count = #self.actData.stateInfo
    self.scroll_content:SetItemCount(count)
    local index = DataCenter.ActBattlePassData:CheckCurGetReward(tonumber(self.activityId))
    --检查是否有可领取奖励
    --local info = self.actData.stateInfo[self.highReward[1].level]
    --info.isFirst = false
    --info.isLast = false
    --info.curLv = self.actData.battlePass.level
    --info.unlock = self.actData.battlePass.unlock
    --info.actId = toInt(self.activityId)
    --info.callBack = function() return self:GetActState() end
    --self.nextReward:SetData(info, self, true)
    self.scroll_content:MoveItemByIndex(index-1,0)
    
end

local function OnInitRewardScroll(self,go,index)
    local item = self.scroll_view:AddComponent(UIBattlePassRewardItem, go)
    self.listGOReward[go] = item
end

local function OnUpdateRewardScroll(self,go,index)
    index = index + 1
    if index <= #self.actData.stateInfo then
        local item = self.listGOReward[go]
        -- data
        local data = self.actData.stateInfo[index]
        data.isFirst = (index == 1)
        data.isLast = (index == #self.actData.stateInfo)
        if index == 1 then
            data.pro = self.actData.battlePass.level / data.level
            data.showBallLeft = false
            if self.actData.battlePass.level < data.level then
                self.curIndex = index
            end
        else
            local lastData = self.actData.stateInfo[index - 1]
            data.pro = (self.actData.battlePass.level - lastData.level) / (data.level - lastData.level)
            data.showBallLeft = self.actData.battlePass.level >= lastData.level
            if self.actData.battlePass.level < data.level and self.actData.battlePass.level >= lastData.level then
                self.curIndex = index
            end
        end
        data.showBallRight = self.actData.battlePass.level >= data.level
        data.curLv = self.actData.battlePass.level
        data.unlock = self.actData.battlePass.unlock
        data.actId = toInt(self.activityId)
        data.callBack = function() return self:GetActState() end
        data.showUp = index == 1 or data.showBallRight
        data.showDown = false
        if index == #self.actData.stateInfo then
            data.showDown = data.showBallRight
        else
            data.showDown = self.actData.battlePass.level >= self.actData.stateInfo[index + 1].level
        end
        item:SetData(data, self)
        self.itemList[index] = item

        if self.nextLv then
            for i = 1 ,#self.highReward do
                if index < self.highReward[i].level then
                    if index >= (DataCenter.ActBattlePassTemplateManager:GetActMaxLv(toInt(self.activityId)) - 1) then
                        self._extra_rect:SetActive(true)
                        self.nextReward:SetActive(false)
                        if self.actData.battlePass.unlock == 1 then
                            self._exchangeDes_txt:SetActive(true)
                            
                            self.lock:SetActive(false)
                        else
                            self._exchangeDes_txt:SetActive(true)
                            self.lock:SetActive(true)
                        end
                    else
                        self._extra_rect:SetActive(false)
                        self.nextReward:SetActive(true)
                    end
                    local info = self.actData.stateInfo[self.highReward[i].level]
                    info.isFirst = false
                    info.isLast = (i == #self.actData.stateInfo)
                    info.curLv = self.actData.battlePass.level
                    info.unlock = self.actData.battlePass.unlock
                    info.actId = toInt(self.activityId)
                    info.callBack = function() return self:GetActState() end
                    if self.curNextIndex then
                        if self.curNextIndex > index and self.curNextIndex < index + 5 then
                            return
                        end
                    end
                    self.curNextIndex = self.highReward[i].level
                    self.nextReward:SetData(info, self,true)
                    break
                end
            end
        end
    end
end

local function OnDestroyRewardScrollItem(self,go, index)
    
end

--页签切换
local function ToggleControlBorS(self,index)
    if self.curType == index then
        return
    end
    self.curType = index


    if self.playSound then
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_common_switch_2)
    else
        self.playSound = true
    end
    
    if index == 1 then          --奖励
        self.task_view:SetActive(false)
        self.mask_go:SetActive(true)
        local num = self.actData:GetRedNum(1)
        self._oneGet_btn:SetActive(num >= 3)
        self.toggleText1:SetActive(true)
        self.taskIndex = 0
        self.toggleText1:SetActive(false)
        self.toggleCheckText1:SetActive(true)
        self.toggleCheckMark1:SetActive(true)
        self.toggleArrow1:SetActive(true)
        self.toggleText2:SetActive(true)
        self.toggleCheckText2:SetActive(false)
        self.toggleCheckMark2:SetActive(false)
        self.toggleArrow2:SetActive(false)
        self.toggleText3:SetActive(true)
        self.toggleCheckText3:SetActive(false)
        self.toggleCheckMark3:SetActive(false)
        self.toggleArrow3:SetActive(false)
        self._taskTitle_txt:SetActive(false)
    elseif index == 2 then      --每日任务
        self.task_view:SetActive(true)
        self.mask_go:SetActive(false)
        self.actData:TaskSortHandle(1)
        self.taskList = self.actData.taskArr[1]
        self:InitTask(1)
        self._oneGet_btn:SetActive(false)
        self.taskIndex = 1
        self.task_content:SetItemCount(#self.taskList)
        self.toggleText1:SetActive(true)
        self.toggleCheckText1:SetActive(false)
        self.toggleCheckMark1:SetActive(false)
        self.toggleArrow1:SetActive(false)
        self.toggleText2:SetActive(false)
        self.toggleCheckText2:SetActive(true)
        self.toggleCheckMark2:SetActive(true)
        self.toggleArrow2:SetActive(true)
        self.toggleText3:SetActive(true)
        self.toggleCheckText3:SetActive(false)
        self.toggleCheckMark3:SetActive(false)
        self.toggleArrow3:SetActive(false)
        self._taskTitle_txt:SetActive(true)
        
    elseif index == 3 then      --常驻任务
        self.task_view:SetActive(true)
        self.mask_go:SetActive(false)
        self.actData:TaskSortHandle(2)
        self.taskList = self.actData.taskArr[2]
        self:InitTask(2)
        self._oneGet_btn:SetActive(false)
        self.taskIndex = 2
        self.task_content:SetItemCount(#self.taskList)
        self.toggleText1:SetActive(true)
        self.toggleCheckText1:SetActive(false)
        self.toggleCheckMark1:SetActive(false)
        self.toggleArrow1:SetActive(false)
        self.toggleText2:SetActive(true)
        self.toggleCheckText2:SetActive(false)
        self.toggleCheckMark2:SetActive(false)
        self.toggleArrow2:SetActive(false)
        self.toggleText3:SetActive(false)
        self.toggleCheckText3:SetActive(true)
        self.toggleCheckMark3:SetActive(true)
        self.toggleArrow3:SetActive(true)
        self._taskTitle_txt:SetActive(false)
    end
end

--额外奖励盒子动画
local function CheckExtraBox(self)
    if self.actData.battlePass.unlock == 1 then
        --根据当前已有的经验计算是否能领
        if self.actData.battlePass.exp - self.actData.extraExp >= 0 then
            self._extraBox_anim:Play("V_ui_extrabox_",0,0)
            return
        end
    end
    self._extraBox_anim:Play("V_ui_extrabox_default",0,0)
end

--{{{事件更新
local function RefreshBattlePass(self)
    self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
    --是否满级
    local nextTemplate = DataCenter.ActBattlePassTemplateManager:GetTemplateById(toInt(self.activityId),self.actData.battlePass.level+1)
    if nextTemplate then
        self.nextLv = true
        self.nextReward:SetActive(true)
        self._add_btn:SetActive(true)
        self._extra_rect:SetActive(false)
        self._exchangeNum_txt:SetActive(false)
    else
        self.nextLv = false
        self._add_btn:SetActive(false)
        self.nextReward:SetActive(false)
        self._extra_rect:SetActive(true)
        self:CheckExtraBox()
        if self.actData.battlePass.unlock == 1 then
            self._exchangeNum_txt:SetActive(true)
            self._exchangeNum_txt:SetLocalText(150033,self.actData.battlePass.exp,self.actData.extraExp)
            self.lock:SetActive(false)
			self._exchangeDes_txt:SetActive(false)
        else
            self._exchangeDes_txt:SetActive(true)
            self.lock:SetActive(true)
        end
    end
    self:RefreshTop()
    if self.taskIndex == 0 then
        self.taskList = self.actData.taskArr[1]
    else
        self.taskList = self.actData.taskArr[self.taskIndex]
    end
    if self.listGO then
        self.task_content:ForceUpdate()
    end
    self.scroll_content:ForceUpdate()
    self.txtCurLv:SetText(self.actData.battlePass.level)
    self:RefreshRed()
    local num = self.actData:GetRedNum(1)
    self._oneGet_btn:SetActive(num >= 3)
end

local function RefreshRewardCell(self)
    self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
    self.scroll_content:ForceUpdate()
    self.txtCurLv:SetText(self.actData.battlePass.level)
    self:RefreshRed()
end

local function RefreshTaskCell(self)
    self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
    if self.actData and next(self.actData) then
        --是否满级
        local nextTemplate = DataCenter.ActBattlePassTemplateManager:GetTemplateById(toInt(self.activityId),self.actData.battlePass.level+1)
        if nextTemplate then
            self.nextLv = true
            self._add_btn:SetActive(true)
            self.nextReward:SetActive(true)
            self._extra_rect:SetActive(false)
            self._exchangeNum_txt:SetActive(false)
            self._exchangeDes_txt:SetActive(false)
        else
            self.nextLv = false
            self._add_btn:SetActive(false)
            self.nextReward:SetActive(false)
            self._extra_rect:SetActive(true)
            self:CheckExtraBox()
            if self.actData.battlePass.unlock == 1 then
                self._exchangeNum_txt:SetActive(true)
                self._exchangeNum_txt:SetLocalText(150033,self.actData.battlePass.exp,self.actData.extraExp)
                self.lock:SetActive(false)
                self._exchangeDes_txt:SetActive(false)
            else
                self._exchangeDes_txt:SetActive(true)
                self.lock:SetActive(true)
            end
        end
        self:RefreshTop(self.lastLv)
        if self.taskIndex == 0 then
            self.taskList = self.actData.taskArr[1]
        else
            self.taskList = self.actData.taskArr[self.taskIndex]
        end
        if self.listGO then
            self.task_content:ForceUpdate()
        end
        self.scroll_content:ForceUpdate()
        self.txtCurLv:SetText(self.actData.battlePass.level)
        self:RefreshRed()
    end
end

local function OnBuyPackageSucc(self)
   -- self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
end
--}}}

local function ClearScroll(self)
    self.scroll_view:RemoveComponents(UIBattlePassTaskCell)
    self.scroll_content:DestroyChildNode()
    self.task_view:RemoveComponents(UIBattlePassTaskCell)
    self.task_content:DestroyChildNode()
end

--购买升级
local function OnBuyLvUpClick(self)
    if self.actEnd then
        UIUtil.ShowTipsId(370100)
        return
    end
    --UIUtil.ShowMessage(Localization:GetString(320438),2,nil,nil,function() SFSNetwork.SendMessage(MsgDefines.BuyBattlePassLevel,toInt(self.activityId)) end)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlePassBuy,{anim = true,isBlur = true},toInt(self.activityId))
end

--一键领取
local function OneGetClick(self)
    if self.actEnd then
        UIUtil.ShowTipsId(370100)
        return
    end
    local num = self.actData:GetRedNum(1)
    if num > 0 then
        SFSNetwork.SendMessage(MsgDefines.ReceiveBattlePassAllReward,toInt(self.activityId))
    else
        UIUtil.ShowTipsId(320446)
    end
end

--购买战令
local function OnBuyClick(self)
    if self.actEnd then
        UIUtil.ShowTipsId(370100)
        return
    end
    if self.packageInfo then
        if self.actData.battlePass.unlock == 0 then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlePassGiftPackagePopUp, { anim = true, isBlur = true }, tonumber(self.activityId))
        end
    end
end

--额外奖励
local function OnBoxClick(self)
    --是否购买了战令
    if self.actData.battlePass.unlock == 1 then
        --根据当前已有的经验计算是否能领
        if self.actData.battlePass.exp - self.actData.extraExp >= 0 then
            SFSNetwork.SendMessage(MsgDefines.ReceiveBattlePassExtraReward,toInt(self.activityId))
            return
        end
    else
        UIUtil.ShowTips(Localization:GetString("320442"))
    end
    
    local x = self._extraBox_btn.transform.position.x
    local y = self._extraBox_btn.transform.position.y
    local offset = 70
    --如果没有领奖并且总次数大于需要次数
    local isUp = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityRewardTip,Localization:GetString("320466",self.actData.extraExp),ActivityEnum.ActivityType.BattlePass,x,y,isUp,nil,offset,tonumber(self.activityId))
end

local function OnExtraClick(self)
    local param = {}
    param.type = "desc"
    param.desc = Localization:GetString("320448",self.actData.extraExp)
    param["alignObject"] = self._extraInfo_btn
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)
end

--活动说明
local function OnIntroClick(self)
    local maxLv = DataCenter.ActBattlePassTemplateManager:GetActMaxLv(toInt(self.activityId))
    UIUtil.ShowIntro(Localization:GetString("320429"), Localization:GetString("100239"),Localization:GetString("320432",maxLv))
end

local function OnClickBoxLock(self)
    if self.actData then
        if self.actData.battlePass.unlock == 0 then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlePassGiftPackagePopUp, { anim = true, isBlur = true }, tonumber(self.activityId))
        end
    end
end

UIBattlePass.OnCreate = OnCreate
UIBattlePass.OnDestroy = OnDestroy
UIBattlePass.OnEnable = OnEnable
UIBattlePass.OnDisable = OnDisable
UIBattlePass.ComponentDefine = ComponentDefine
UIBattlePass.ComponentDestroy = ComponentDestroy
UIBattlePass.DataDefine = DataDefine
UIBattlePass.DataDestroy = DataDestroy
UIBattlePass.OnAddListener = OnAddListener
UIBattlePass.OnRemoveListener = OnRemoveListener

UIBattlePass.SetData = SetData
UIBattlePass.OnRefresh = OnRefresh
UIBattlePass.RefreshTop = RefreshTop
UIBattlePass.RefreshRed = RefreshRed

UIBattlePass.InitTask = InitTask
UIBattlePass.OnInitScroll = OnInitScroll
UIBattlePass.OnUpdateScroll = OnUpdateScroll
UIBattlePass.OnDestroyScrollItem = OnDestroyScrollItem

UIBattlePass.ShowCells = ShowCells
UIBattlePass.OnInitRewardScroll = OnInitRewardScroll
UIBattlePass.OnUpdateRewardScroll = OnUpdateRewardScroll
UIBattlePass.OnDestroyRewardScrollItem = OnDestroyRewardScrollItem

UIBattlePass.ToggleControlBorS = ToggleControlBorS
UIBattlePass.RefreshBattlePass = RefreshBattlePass
UIBattlePass.RefreshRewardCell = RefreshRewardCell
UIBattlePass.RefreshTaskCell = RefreshTaskCell
UIBattlePass.OnBuyPackageSucc = OnBuyPackageSucc

UIBattlePass.ClearScroll = ClearScroll

UIBattlePass.AddTimer = AddTimer
UIBattlePass.RefreshTime = RefreshTime
UIBattlePass.DeleteTimer = DeleteTimer

UIBattlePass.GetActState = GetActState
UIBattlePass.OneGetClick = OneGetClick
UIBattlePass.OnBoxClick = OnBoxClick
UIBattlePass.OnExtraClick = OnExtraClick
UIBattlePass.CheckExtraBox = CheckExtraBox
UIBattlePass.OnBuyLvUpClick = OnBuyLvUpClick
UIBattlePass.OnBuyClick = OnBuyClick
UIBattlePass.OnIntroClick = OnIntroClick
UIBattlePass.OnClickBoxLock = OnClickBoxLock

return UIBattlePass