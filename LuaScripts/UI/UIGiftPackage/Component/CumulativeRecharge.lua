---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime:
---累充

local CumulativeRecharge = BaseClass("CumulativeRecharge", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICumulativeItem = require "UI.UIGiftPackage.Component.UICumulativeItem"
local view_path = "RightView"
local scroll_path = "RightView/Scroll"
local content_path = "RightView/Scroll/Content"
local actTypeIcon_img_path = "RightView/Rect_TopInfo/Img_ActTypeIcon"
local score_txt_path = "RightView/Rect_TopInfo/Txt_Score"
local getmore_btn_path = "RightView/Btn_GetMore"
local getmore_txt_path = "RightView/Btn_GetMore/Txt_GetMore"
local time_txt_path = "RightView/ActTime/remainTime"
local title_txt_path = "RightView/title_main"
local desc_txt_path = "RightView/Txt_Desc"
local intro_path = "RightView/Intro"

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ClearScroll()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.view_path = self:AddComponent(UIBaseComponent,view_path)
    self._score_txt = self:AddComponent(UITextMeshProUGUIEx,score_txt_path)
    self._actTypeIcon_img = self:AddComponent(UIImage,actTypeIcon_img_path)
    self.scroll = self:AddComponent(UIScrollRect, scroll_path)
    self.content_sv = self:AddComponent(GridInfinityScrollView, content_path)
    self._time_txt = self:AddComponent(UITextMeshProUGUIEx,time_txt_path)
    self._getMore_btn = self:AddComponent(UIButton,getmore_btn_path)
    self._getMore_btn:SetOnClick(function()
        self:OnClickGetMore()
    end)
    self.title_txt = self:AddComponent(UITextMeshProUGUIEx,title_txt_path)
    self.getMore_txt = self:AddComponent(UITextMeshProUGUIEx,getmore_txt_path)
    self.getMore_txt:SetLocalText(320413)
    self.desc_txt = self:AddComponent(UITextMeshProUGUIEx,desc_txt_path)
    self.desc_txt:SetLocalText(470071)
    self.intro_btn = self:AddComponent(UIButton, intro_path)
    self.intro_btn:SetOnClick(function()
        UIUtil.ShowIntro(Localization:GetString("470070"), Localization:GetString("100239"),Localization:GetString("470073"))
    end)
end


local function ComponentDestroy(self)
    self._score_txt = nil
    self._time_txt = nil
    self._getMore_btn = nil
    self.title_txt = nil
    self.desc_txt_path = nil
    self.intro_btn = nil
end

local function DataDefine(self)
    self.isFirst = true
    self.itemList = {}
    self.dataList = {}
    self.cell     = {}
    self.timer = nil
    self.timer_action = function(temp)
        self:RefreshTime()
    end
end

local function DataDestroy(self)
    self.itemList = nil
    self.dataList = nil
    self.cell     = nil
    self.isFirst  = nil
    self:DeleteTimer()
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.CumulativeReward, self.UpdateCellByStageId)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.CumulativeReward, self.UpdateCellByStageId)
end

local function ReInit(self,welfarelist,id,index,curRechargeId)
    self.welfarelist = welfarelist
    local _name = welfarelist[index]:getName()
    self.title_txt:SetLocalText(_name)
    self.actTypePath = GetTableData("recharge", curRechargeId, "image2")
    self._actTypeIcon_img:LoadSprite(string.format(LoadPath.ItemPath, self.actTypePath))
    self.rechargeId,self.dataList = DataCenter.CumulativeRechargeManager:GetInfo(id)
    self._score_txt:SetText(self.dataList.score)
    self.curStage = DataCenter.CumulativeRechargeManager:GetCurStage(self.rechargeId)
    local lastStage = DataCenter.CumulativeRechargeManager:GetLastStage()

    if self.isFirst then
        local OnInitCell = BindCallback(self, self.OnInitCell)
        local OnUpdateCell = BindCallback(self, self.OnUpdateCell)
        local OnDestroyCell = BindCallback(self, self.OnDestroyCell)
        self.content_sv:Init(OnInitCell, OnUpdateCell, OnDestroyCell)
        self.content_sv:SetItemCount(#self.dataList.stageInfo)
        self.isFirst = false
    else
        self.content_sv:ForceUpdate()
    end
    --积分有更新
    if self.curStage ~= lastStage then
        DataCenter.CumulativeRechargeManager:SetCurStage(self.curStage)
    end
    local canRecv = DataCenter.CumulativeRechargeManager:CheckCanRecv(self.rechargeId)
    if canRecv ~= 0 then
        self.content_sv:MoveItemByIndex(canRecv-1,0)
    else
        self.content_sv:MoveItemByIndex(self.curStage-1,0)
    end
    
    self:RefreshTime()
    self:AddTimer()
end

local function OnInitCell(self, go, index)
    local item = self.scroll:AddComponent(UICumulativeItem, go)
    self.itemList[go] = item
end

local function OnUpdateCell(self, go, index)
    local item = self.itemList[go]
    local data = self.dataList.stageInfo[index + 1]
    go.name = self.dataList.stageInfo[index+1].needScore
    go:SetActive(true)
    local param = {}
    param.rechargeId = self.rechargeId
    param.info = data
    param.scrollView = self.scroll
    param.curScore = self.dataList.score
    param.curStage = self.curStage
    param.imgPath = self.actTypePath
    param.isFirst = (index + 1) == 1
    param.isLast1 = (index + 1) == #self.dataList.stageInfo
    param.isLast2 = (index + 1) == #self.dataList.stageInfo - 1
    param.showUp = param.info.needScore <= param.curScore
    param.showDown = false
    if (index + 1) == #self.dataList.stageInfo then
        param.showDown = param.info.needScore <= param.curScore
    else
        local nextData = self.dataList.stageInfo[index + 2]
        param.showDown = nextData.needScore <= self.dataList.score
    end
    item:ReInit(param)
    self.cell[data.stageId] = item
end

local function OnDestroyCell(self, go, index)

end

local function ClearScroll(self)
    self.scroll:RemoveComponents(UICumulativeItem)
    self.content_sv:DestroyChildNode()
end

local function AddTimer(self)
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false,false,false)
    end

    self.timer:Start()
end

local function RefreshTime(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.dataList.endTime - curTime
    if deltaTime > 0 then
        self._time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    else
        self.view.ctrl:CloseSelf()
    end
end

local function DeleteTimer(self)
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
end

local function UpdateCellByStageId(self,param)
    self.cell[param]:RewardUpdate()
end

local function OnClickGetMore(self)
    for i = 1, #self.welfarelist do
        local type = self.welfarelist[i]:getType()
        if type ~= WelfareTagType.CumulativeRecharge then
            self.view:GotoButtonType(type)
            break
        end
    end
end

CumulativeRecharge.OnCreate = OnCreate
CumulativeRecharge.OnDestroy = OnDestroy
CumulativeRecharge.OnEnable = OnEnable
CumulativeRecharge.OnDisable = OnDisable
CumulativeRecharge.ComponentDefine = ComponentDefine
CumulativeRecharge.ComponentDestroy = ComponentDestroy
CumulativeRecharge.DataDefine = DataDefine
CumulativeRecharge.DataDestroy = DataDestroy
CumulativeRecharge.OnAddListener = OnAddListener
CumulativeRecharge.OnRemoveListener = OnRemoveListener
CumulativeRecharge.OnInitCell = OnInitCell
CumulativeRecharge.OnUpdateCell = OnUpdateCell
CumulativeRecharge.OnDestroyCell = OnDestroyCell
CumulativeRecharge.ReInit = ReInit
CumulativeRecharge.ClearScroll = ClearScroll
CumulativeRecharge.AddTimer = AddTimer
CumulativeRecharge.RefreshTime = RefreshTime
CumulativeRecharge.DeleteTimer = DeleteTimer
CumulativeRecharge.UpdateCellByStageId = UpdateCellByStageId
CumulativeRecharge.OnClickGetMore = OnClickGetMore

return CumulativeRecharge