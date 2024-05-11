--- Created by zzl.
--- DateTime: 
--- 
local UIHeroTipView = require "UI.UIHero2.UIHeroTip.View.UIHeroTipView"
local UIAllianceBuildingCollectView = BaseClass("UIAllianceBuildingCollectView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIAllianceCollectItem = require "UI.UIAllianceBuildingCollect.Component.UIAllianceCollectItem"

--创建
function UIAllianceBuildingCollectView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

-- 销毁
function UIAllianceBuildingCollectView:OnDestroy()
    self:DelCountDownTimer()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIAllianceBuildingCollectView:ComponentDefine()
    self.titleN = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/bg_mid/titleText")
    self.titleN:SetLocalText(300787)
    self.closeBtnN = self:AddComponent(UIButton, "UICommonPopUpTitle/bg_mid/CloseBtn")
    self.closeBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.bgBtnN = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
    self.bgBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.info_btn = self:AddComponent(UIButton, "ImgBg/Rect_Top/Button")
    self.info_btn:SetOnClick(function()
        self:OnInfoClick()
    end)
    self._point_txt = self:AddComponent(UIText,"ImgBg/Rect_Top/Txt_Point")
    self._text_today = self:AddComponent(UIText,"ImgBg/Rect_Top/Txt_Point/Text_today")
    self._text_today:SetLocalText(300785)
    self._act_des_txt = self:AddComponent(UIText,"ImgBg/Rect_act/Text_act")
    self._act_des_txt:SetLocalText(374021)
    self.top_obj = self:AddComponent(UIBaseContainer,"ImgBg/Rect_Top")
    self.act_obj = self:AddComponent(UIBaseContainer,"ImgBg/Rect_act")
    self._icon_img = self:AddComponent(UIImage,"ImgBg/Rect_Info/Img_Icon")
    self.des_txt = self:AddComponent(UIText,"ImgBg/desObj/desTxt")
    self._name_txt = self:AddComponent(UIText,"ImgBg/Rect_Info/Txt_Name")
    self._tips_txt = self:AddComponent(UIText,"ImgBg/Rect_Info/Txt_Tips")
    self._slider = self:AddComponent(UISlider,"ImgBg/Rect_Info/Slider_Progress/Slider")
    self._timer_txt = self:AddComponent(UIText,"ImgBg/Rect_Info/Slider_Progress/Txt_Timer")
    self.state_img = self:AddComponent(UIImage,"ImgBg/Rect_Info/Slider_Progress/ImageState")
    self._timerTips_txt = self:AddComponent(UIText,"ImgBg/Rect_Info/Txt_TimerTips")
    self._progress_txt = self:AddComponent(UIText,"ImgBg/Rect_Info/Txt_Progress")

    self.contentN = self:AddComponent(UIBaseContainer,"ImgBg/ScrollView/Viewport/Content")
    self._join_rect = self:AddComponent(UIBaseContainer,"ImgBg/ScrollView/Viewport/Content/Rect_Join")
    self._join_txt = self:AddComponent(UIText,"ImgBg/ScrollView/Viewport/Content/Rect_Join/join/Txt_Join")
    self._join_txt:SetLocalText(GameDialogDefine.CLICK_TO_JOIN)
    self._join_btn = self:AddComponent(UIButton,"ImgBg/ScrollView/Viewport/Content/Rect_Join/Btn_Join")
    self._join_btn:SetOnClick(function()
        self:OnClickJoin()
    end)
end

function UIAllianceBuildingCollectView:ComponentDestroy()
    self.titleN = nil
    self.closeBtnN = nil
    self.bgBtnN = nil
    self.tipN = nil
    self.scrollRectN = nil
    self.contentN = nil
end

function UIAllianceBuildingCollectView:DataDefine()
    self.CountDownTimerAction = function()
        self:RefreshRemainTime()
    end
end

function UIAllianceBuildingCollectView:DataDestroy()
    self.allianceMineId = nil
    self.cityItems = nil
    self.allianceCityList = nil
end

function UIAllianceBuildingCollectView:OnEnable()
    base.OnEnable(self)
    self.pointId,self.uuid = self:GetUserData()
    DataCenter.AllianceMineManager:RequestAlMineMarchList(self.uuid)
    self:RefreshAll()
end

function UIAllianceBuildingCollectView:OnDisable()
    base.OnDisable(self)
end

function UIAllianceBuildingCollectView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.OnRefreshAllianceMineMarch, self.RefreshMarchInfo)
end

function UIAllianceBuildingCollectView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.OnRefreshAllianceMineMarch, self.RefreshMarchInfo)
end

function UIAllianceBuildingCollectView:RefreshAll()
    self._tips_txt:SetText("")
    --self.tipN:SetText(Localization:GetString(300773, Localization:GetString(mineTemplate.name)))
    local detail = nil
    local pointInfo = DataCenter.WorldPointManager:GetPointInfo(self.pointId)
    if pointInfo then
        detail = DataCenter.WorldPointDetailManager:GetDetailByPointId(pointInfo.mainIndex)
    end
    if not detail then
        return
    end
    self.mineInfo = detail.alBuilding
    if not self.mineInfo then
        return
    end
    local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(self.mineInfo.buildId)
    if template~=nil then
        self._name_txt:SetText(Localization:GetString(template.name))
        self._icon_img:LoadSprite(template:GetIconPath())
    end
    self._join_rect:SetActive(false)
    
    if self.mineInfo.status == AllianceMineStatus.Constructing then
        self._timerTips_txt:SetLocalText(390210)
        self.state_img:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/UIlmk_jianzao.png")
        local str = " "..string.GetFormattedStr(self.mineInfo.soldierNum).."/"..string.GetFormattedStr(self.mineInfo.soldierMax)
        self.des_txt:SetText(Localization:GetString("110144",str))
        self.mineTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(self.mineInfo.buildId)
        local needT = (self.mineTemplate.resDurable - self.mineInfo.durability) / self.mineInfo.buildSpeed
        self.endTime = self.mineInfo.lastBuildTime + needT * 1000
        self:AddCountDownTimer()
        self:RefreshRemainTime()
        local maxPoint = LuaEntry.DataConfig:TryGetNum("allance_build", "k5")
        local curPoint = DataCenter.AllianceMineManager:GetPoint()
        self._point_txt:SetLocalText(150033,curPoint,maxPoint)
    else
        
        self._timerTips_txt:SetLocalText(300039)
        self.state_img:LoadSprite("Assets/Main/Sprites/UI/Common/New/Common_icon_march_collect_alliance.png")
        self.curNum = self.mineInfo.remainNum
        self:AddCountDownTimer()
        self:RefreshRemainTime()
        if WorldAllianceBuildUtil.IsAllianceActMineGroup(self.mineInfo.buildId)==true then
            self.top_obj:SetActive(false)
            self.act_obj:SetActive(true)
            if self:CheckSelfMarchIsActCollect() then
                self._join_rect:SetActive(false)
            else
                self._join_rect:SetActive(true)
            end
        else
            self.act_obj:SetActive(false)
            self.top_obj:SetActive(true)
            --检查自己部队是否有在采集
            if self:CheckSelfMarchIsCollect() then
                self._join_rect:SetActive(false)
            else
                self._join_rect:SetActive(true)
            end
            local maxPoint = LuaEntry.DataConfig:TryGetNum("allance_build", "k5")
            local curPoint = DataCenter.AllianceMineManager:GetPoint()
            self._point_txt:SetLocalText(150033,curPoint,maxPoint)
        end
        
    end
    
end

--}}}
--{{{矿容量
function UIAllianceBuildingCollectView:AddCountDownTimer()
    if self.countDownTimer == nil then
        self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction , self, false,false,false)
    end
    self.countDownTimer:Start()
end

function UIAllianceBuildingCollectView:RefreshRemainTime()
    if self.mineInfo.status == AllianceMineStatus.Constructing then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local remainTime = self.endTime - curTime
        if remainTime~=nil and remainTime > 0 then
            self._timer_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
            local tempProg = self.mineInfo:GetConstructDurability() / self.mineTemplate.resDurable
            self._slider:SetValue(tempProg)
            self._progress_txt:SetText(string.GetFormattedPercentStr(tempProg))
        else
            self._timer_txt:SetText("")
            self._slider:SetValue(1)
            self._progress_txt:SetText("100%")
            self:DelCountDownTimer()
        end
    else
        self.curNum = self.curNum - self.mineInfo.collectSpeed
        if self.curNum <= 0 then
            self._slider:SetValue(0)
            self._timer_txt:SetLocalText(150033,0,self.mineInfo.initNum)
            self._progress_txt:SetText(string.GetFormattedPercentStr(0))
            self:DelCountDownTimer()
            return
        end
        local tempProg = self.curNum / self.mineInfo.initNum
        self._slider:SetValue(tempProg)
        self._timer_txt:SetLocalText(150033,string.GetFormattedStr(self.curNum),string.GetFormattedStr(self.mineInfo.initNum))
        self._progress_txt:SetText(string.GetFormattedPercentStr((self.curNum/self.mineInfo.initNum)))
    end
end

function UIAllianceBuildingCollectView:DelCountDownTimer()
    if self.countDownTimer ~= nil then
        self.countDownTimer:Stop()
        self.countDownTimer = nil
    end
end
--}}}

function UIAllianceBuildingCollectView:OnClickCloseBtn()
    self.ctrl:CloseSelf()
end

function UIAllianceBuildingCollectView:OnClickJoin()
    GoToUtil.CloseAllWindows()
    if self.mineInfo~=nil and WorldAllianceBuildUtil.IsAllianceActMineGroup(self.mineInfo.buildId)==true then
        MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_COLLECT_ACT_ALLIANCE_MINE,self.pointId, self.uuid)
    else
        MarchUtil.OnClickStartMarch(MarchTargetType.COLLECT_ALLIANCE_BUILD_RESOURCE,self.pointId, self.uuid)
    end
    
end

function UIAllianceBuildingCollectView:CheckSelfMarchIsCollect()
    local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
    if #selfMarch > 0 then
        for i = 1, #selfMarch do
            local march = selfMarch[i]
            if (march:GetMarchTargetType() == MarchTargetType.COLLECT_ALLIANCE_BUILD_RESOURCE or march:GetMarchTargetType() == MarchTargetType.BUILD_ALLIANCE_BUILDING) and march.targetUuid == self.uuid then
                return true
            end
        end
    end
    return false
end

function UIAllianceBuildingCollectView:CheckSelfMarchIsActCollect()
    local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
    if #selfMarch > 0 then
        for i = 1, #selfMarch do
            local march = selfMarch[i]
            if march:GetMarchTargetType() == MarchTargetType.ASSISTANCE_COLLECT_ACT_ALLIANCE_MINE  and march.targetUuid == self.uuid then
                return true
            end
        end
    end
    return false
end
function UIAllianceBuildingCollectView:RefreshMarchInfo()
    local info = DataCenter.AllianceMineManager:GetMarchInfo()
    local totalNum = 0
    if info then
        self:SetFirstCellDestroy()
        for i = 1, table.length(info) do
            totalNum = totalNum + info[i]:GetSoliderNum()
            --复制基础prefab，每次循环创建一次
            self.modelFirst[i] = self:GameObjectInstantiateAsync(UIAssets.UIAllianceCollectItem, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.contentN.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.name =info[i].ownerUid .. i
                local cell = self.contentN:AddComponent(UIAllianceCollectItem,go.name)
                cell:SetItem(info[i])
            end)
        end
    end
    if self.mineInfo~=nil and self.mineInfo.status == AllianceMineStatus.Constructing then
        local str = " "..string.GetFormattedStr(self.mineInfo.soldierNum).."/"..string.GetFormattedStr(self.mineInfo.soldierMax)
        self.des_txt:SetText(Localization:GetString("110144",str))
    else
        local str = " "..string.GetFormattedStr(totalNum)
        self.des_txt:SetText(Localization:GetString("110144",str))
    end
end

function UIAllianceBuildingCollectView:SetFirstCellDestroy()
    self.contentN:RemoveComponents(UIAllianceCollectItem)
    if self.modelFirst~=nil then
        for k,v in pairs(self.modelFirst) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.modelFirst = {}
end

function UIAllianceBuildingCollectView:OnInfoClick()
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.info_btn.gameObject.transform.position + Vector3.New(0, -33, 0) * scaleFactor

    local param = UIHeroTipView.Param.New()
    param.content = Localization:GetString("300786")
    param.dir = UIHeroTipView.Direction.BELOW
    param.defWidth = 200
    param.pivot = 0.5
    param.position = position
    param.deltaX = 0
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)

end


return UIAllianceBuildingCollectView