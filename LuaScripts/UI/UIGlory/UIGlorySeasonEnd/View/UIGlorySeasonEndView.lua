---
--- 赛季结束说明
--- Created by .
--- DateTime: 
---

local UIGlorySeasonEndView = BaseClass("UIGlorySeasonEndView", UIBaseView)
local base = UIBaseView
local SeasonEndIntroCell = require "UI.UIGlory.UIGlorySeasonEnd.Component.SeasonEndIntroCell"
function UIGlorySeasonEndView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

function UIGlorySeasonEndView:OnDestroy()
    self:DeleteTimer()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIGlorySeasonEndView:OnEnable()
    base.OnEnable(self)
    self:OnClickBtn(2)
end

function UIGlorySeasonEndView:OnDisable()
    base.OnDisable(self)
end

function UIGlorySeasonEndView:ComponentDefine()
    self.title_text = self:AddComponent(UIText, "Title")
    
    self.return_btn = self:AddComponent(UIButton, "Back")
    self.return_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGlorySeasonEnd)
    end)
    self.close_btn = self:AddComponent(UIButton, "Close")
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGlorySeasonEnd)
    end)
    --
    self._after_rect = self:AddComponent(UIBaseContainer,"Rect_After")
    self._title1_txt = self:AddComponent(UIText,"Rect_After/Txt_Title1")
    self._title2_txt = self:AddComponent(UIText,"Rect_After/Txt_Title2")
    self._title3_txt = self:AddComponent(UIText,"Rect_After/Txt_Title3")
    self._look_btn = self:AddComponent(UIButton,"Rect_After/Btn_Look")
    self._look_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickBtn(1)
    end)
    self._look_btn = self:AddComponent(UIText,"Rect_After/Btn_Look/Txt_Look")
    self._endTime1_txt = self:AddComponent(UIText,"Rect_After/Txt_EndTime1")
    self._endTime2_txt = self:AddComponent(UIText,"Rect_After/Txt_EndTime2")
    self._endTime3_txt = self:AddComponent(UIText,"Rect_After/Txt_EndTime3")
    self._endTime4_txt = self:AddComponent(UIText,"Rect_After/Txt_EndTime4")
    self._endTime5_txt = self:AddComponent(UIText,"Rect_After/Txt_EndTime5")
    self._endTime6_txt = self:AddComponent(UIText,"Rect_After/Txt_EndTime6")
    
    self._before_rect = self:AddComponent(UIBaseContainer,"Rect_Before")
    self._back_btn = self:AddComponent(UIButton,"Rect_Before/Btn_Back")
    self._back_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickBtn(2)
    end)
    self._back_txt = self:AddComponent(UIText,"Rect_Before/Btn_Back/Txt_Back")
    self._timeDes_txt = self:AddComponent(UIText,"Rect_Before/Rect_Time/Txt_TimeDes")
    self._time_txt = self:AddComponent(UIText,"Rect_Before/Rect_Time/Txt_Time")

    self.content = self:AddComponent(UIBaseContainer,"Rect_Before/Rect_Dialog/View/Content")
end

function UIGlorySeasonEndView:ComponentDestroy()
    self:SetCellDestroy()
end

function UIGlorySeasonEndView:DataDefine()
    self.timer_action = function(temp)
        self:RefreshTime()
    end
end

function UIGlorySeasonEndView:DataDestroy()
 
end

function UIGlorySeasonEndView:ReInit()
    self:SetRegularDialog()
    self:CreateCell()

    local settleTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
    self.time = settleTime
    self:RefreshTime()
    self:AddTimer()
end

function UIGlorySeasonEndView:SetRegularDialog()
    self.title_text:SetLocalText(110254)
    
    self._title1_txt:SetLocalText(111042)
    self._title2_txt:SetLocalText(111043)
    self._title3_txt:SetLocalText(111044)
    self._look_btn:SetLocalText(110076)
    self._back_txt:SetLocalText(300520)
    self._timeDes_txt:SetLocalText(312121)
end

function UIGlorySeasonEndView:CreateCell()
    local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
    local value = seasonId + 1
    local dialogStr = LuaEntry.DataConfig:TryGetStr("season_end", "k"..value)
    local list = string.split(dialogStr,"|")
    self:SetCellDestroy()
    for i = 1, table.length(list) do
        --复制基础prefab，每次循环创建一次
        self.modelFirst[i] = self:GameObjectInstantiateAsync(UIAssets.SeasonEndIntroCell, function(request)
            if request.isError then
                return
            end
            local go = request.gameObject;
            go.gameObject:SetActive(true)
            go.transform:SetParent(self.content.transform)
            go.transform.localScale = Vector3.New(1, 1, 1)
            go.name ="item" .. i
            local cell = self.content:AddComponent(SeasonEndIntroCell,go.name)
            cell:ReInit(list[i])
          --  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
        end)
    end
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
    end, 0.5)
end

function UIGlorySeasonEndView:SetCellDestroy()
    self.content:RemoveComponents(SeasonEndIntroCell)
    if self.modelFirst~=nil then
        for k,v in pairs(self.modelFirst) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.modelFirst = {}
end

function UIGlorySeasonEndView:OnClickBtn(type)
    if type == 1 then
        self._after_rect:SetActive(false)
        self._before_rect:SetActive(true)
    elseif type == 2 then
        self._after_rect:SetActive(true)
        self._before_rect:SetActive(false)
    end
end

function UIGlorySeasonEndView:AddTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self, false,false,false)
    end
    self.timer:Start()
end

--倒計時
function UIGlorySeasonEndView:RefreshTime()
    local now = UITimeManager:GetInstance():GetServerTime()
    if self.time and self.time > now then
        local tab = UITimeManager:GetInstance():MilliSecondToFmtStringByNum(self.time - now)
        self._endTime1_txt:SetText(string.sub(tostring(tab[1]),1,1))
        self._endTime2_txt:SetText(string.sub(tostring(tab[1]),2,2))
        self._endTime3_txt:SetText(string.sub(tostring(tab[2]),1,1))
        self._endTime4_txt:SetText(string.sub(tostring(tab[2]),2,2))
        self._endTime5_txt:SetText(string.sub(tostring(tab[3]),1,1))
        self._endTime6_txt:SetText(string.sub(tostring(tab[3]),2,2))
        self._time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.time - now))
    else
        self:DeleteTimer()
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGlorySeasonEnd)
    end
end

function UIGlorySeasonEndView:DeleteTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end


return UIGlorySeasonEndView