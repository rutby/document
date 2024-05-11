---
--- 伤兵补偿
--- Created by zzl.
--- DateTime:
---
local TotalDetailItem = require "UI.UIArmyInfo.Component.TotalDetailItem"
local UIWoundedCompensateView = BaseClass("UIWoundedCompensateView",UIBaseView)
local base = UIBaseView

--创建
function UIWoundedCompensateView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:OnRefresh()
end

-- 销毁
function UIWoundedCompensateView:OnDestroy()
    self:DataDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

function UIWoundedCompensateView:ComponentDefine()
    self.txt_title = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/bg_mid/titleText")
    self.close_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/bg_mid/CloseBtn")
    self.return_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
    
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:Close()
    end)
    self.return_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)

    self.scrollView = self:AddComponent(UIScrollView,"MainPanel/TotalContent")
    self.scrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.scrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
    
    self._desNum_txt = self:AddComponent(UIText,"MainPanel/TotalContent/TotalNum")
    self._scale_txt  = self:AddComponent(UIText,"MainPanel/TotalContent/TotalScale")
    self._des_txt  = self:AddComponent(UIText,"MainPanel/TotalContent/TotalDes")
    self._time_txt  = self:AddComponent(UIText,"MainPanel/TotalContent/TotalTimer")
    self._time_des = self:AddComponent(UIText,"MainPanel/TotalContent/timeTxt")
    self._rece_btn = self:AddComponent(UIButton,"MainPanel/TotalContent/Btn_Rece")
    self._rece_txt = self:AddComponent(UIText,"MainPanel/TotalContent/Btn_Rece/Txt_Rect")
    self._rece_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:GetReward()
    end)
end

function UIWoundedCompensateView:ComponentDestroy()
    self.txt_title = nil
    self.close_btn = nil
    self.return_btn = nil
    self.scrollView = nil
    self._desNum_txt = nil
    self._scale_txt = nil
    self._des_txt = nil
end

function UIWoundedCompensateView:DataDefine()
    self.timer = nil
    self.timer_action = function(temp)
        self:RefreshTime(temp)
    end
end

function UIWoundedCompensateView:DataDestroy()
    self:DeleteTimer()
    self.timer_action = nil
end

function UIWoundedCompensateView:OnEnable()
    base.OnEnable(self)
end

function UIWoundedCompensateView:OnDisable()
    base.OnDisable(self)
end

function UIWoundedCompensateView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.OnTaskForceRefreshFinish, self.DoQuestShowAnimation)
end

function UIWoundedCompensateView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.OnTaskForceRefreshFinish, self.DoQuestShowAnimation)
end

function UIWoundedCompensateView:OnRefresh()
    self.compensateData = DataCenter.WoundedCompensateData:GetDataInfo()
    self.itemList = self.compensateData.reward
    self:InitFreeSolider()
    self:RefreshTxt()
    self:RefreshTime()
    self:AddTimer()
end

--设置标题
function UIWoundedCompensateView:RefreshTxt()
    self.txt_title:SetLocalText(311156)
    local num = 0
    for i = 1 ,#self.itemList do
        num = self.itemList[i].count + num
    end
    self._desNum_txt:SetLocalText(311157,string.GetFormattedSeperatorNum(num))
    self._scale_txt:SetLocalText(311158,math.floor(self.compensateData.scale).."%")
    if self.cdEnd then
        self._des_txt:SetLocalText(311160)
    else
        self._des_txt:SetLocalText(311159)
    end
    self._rece_txt:SetLocalText(110107)
end

--{{{倒计时
function UIWoundedCompensateView:AddTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action ,self, false,false,false)
    end
    self.timer:Start()
end

function UIWoundedCompensateView:RefreshTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.compensateData.endTime < curTime then
        self:DeleteTimer()
        self.cdEnd = true
        self._rece_btn:SetActive(true)
        self._des_txt:SetLocalText(311160)
        self._time_txt:SetActive(false)
    else
        self._time_txt:SetLocalText(311161,UITimeManager:GetInstance():MilliSecondToFmtString(self.compensateData.endTime - curTime))
        self._time_txt:SetActive(true)
        self.cdEnd = false
        self._rece_btn:SetActive(false)
        self._des_txt:SetLocalText(311159)
    end
end

function UIWoundedCompensateView:DeleteTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end
--}}}

function UIWoundedCompensateView:InitFreeSolider()
    self:ClearScroll()
    if #self.itemList>0 then
        self.scrollView:SetTotalCount(#self.itemList)
        self.scrollView:RefillCells()
    end
end

function UIWoundedCompensateView:ClearScroll()
    self.cells = {}
    self.scrollView:ClearCells()
    self.scrollView:RemoveComponents(TotalDetailItem)
end

--key 兵种id  value 兵数量
function UIWoundedCompensateView:OnItemMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    self.cells[index] = self.scrollView:AddComponent(TotalDetailItem, itemObj)
    local param = {}
    param.key = self.itemList[index].itemId
    param.value = self.itemList[index].count
    param.index = index
    self.cells[index]:ReInit(param)
end

function UIWoundedCompensateView:OnItemMoveOut(itemObj, index)
    self.cells[index] = nil
    self.scrollView:RemoveComponent(itemObj.name, self.item)
end

function UIWoundedCompensateView:GetReward()
    self.ctrl:CloseSelf()
    SFSNetwork.SendMessage(MsgDefines.UserGetDefendWallCompensate,self.compensateData.uuid)
end

return UIWoundedCompensateView