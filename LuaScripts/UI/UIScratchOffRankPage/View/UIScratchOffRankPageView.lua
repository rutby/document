---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime:
--- 
local UIScratchOffRankPageView = BaseClass("UIScratchOffRankPageView", UIBaseView)
local base = UIBaseView
local UIScratchOffRankItem = require "UI.UIScratchOffRankPage.Comp.UIScratchOffRankItem"
local UIGolloesCardsRPCell = require "UI.UIActivityCenterTable.Component.GolloesCards.UIGolloesCardsRPCell"

function UIScratchOffRankPageView:OnCreate()
    base.OnCreate(self)
    
    self._title_txt = self:AddComponent(UIText,"UICommonPopUpTitle/bg_mid/titleText")
    self._title_txt:SetLocalText(390040)
    
    self._close_btn = self:AddComponent(UIButton,"UICommonPopUpTitle/bg_mid/CloseBtn")
    self._close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    --{{{自己的信息
    self._selfRank_txt = self:AddComponent(UIText,"ImgBg/Rect_Rank/selfObj/Txt_SelfRank")
    self._selfName_txt = self:AddComponent(UIText, "ImgBg/Rect_Rank/selfObj/Txt_SelfName")
    self._selfAName_txt = self:AddComponent(UIText,"ImgBg/Rect_Rank/selfObj/Txt_SelfAName")
    self._selfScoreDes_txt = self:AddComponent(UIText,"ImgBg/Rect_Rank/selfObj/Txt_SelfScoreDes")
    self._selfScore_txt = self:AddComponent(UIText,"ImgBg/Rect_Rank/selfObj/Txt_SelfScoreDes/Txt_SelfScore")
    self._selfHead_btn = self:AddComponent(UIButton,"ImgBg/Rect_Rank/selfObj/playerFlag/UIPlayerHead")
    self._selfHead_img = self:AddComponent(UIPlayerHead,"ImgBg/Rect_Rank/selfObj/playerFlag/UIPlayerHead/HeadIcon")
    --self._monthCard_img = self:AddComponent(UIBaseContainer,"ImgBg/Rect_Rank/selfObj/playerFlag/UIPlayerHead/Foreground")
    self._selfHead_btn:SetOnClick(function()
        self:OnClickSelfHead()
    end)
    self.scroll_viewSelf = self:AddComponent(UIScrollView, "ImgBg/Rect_Rank/selfObj/scrollView_SelfReward")
    self.scroll_viewSelf:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.scroll_viewSelf:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
    --}}}

    self._rankName_txt = self:AddComponent(UIText,"ImgBg/Rect_Rank/Rect_RankDes/Txt_RankName")
    self._rankScore_txt = self:AddComponent(UIText,"ImgBg/Rect_Rank/Rect_RankDes/Txt_RankScore")
    self._rankReward_txt = self:AddComponent(UIText,"ImgBg/Rect_Rank/Rect_RankDes/Txt_RankReward")

    self.scroll_view = self:AddComponent(UIScrollView, "ImgBg/Rect_Rank/ScrollView")
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnRankItemMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnRankItemMoveOut(itemObj, index)
    end)
    
    self._noRank_txt = self:AddComponent(UIText,"ImgBg/Txt_NoRank")
end

function UIScratchOffRankPageView:OnDestroy()
    base.OnDestroy(self)
end

function UIScratchOffRankPageView:OnEnable()
    base.OnEnable(self)
    self._noRank_txt:SetActive(false)
    local actId = tonumber(self:GetUserData())
    self:RefreshRank(actId)
end

function UIScratchOffRankPageView:OnDisable()
    base.OnDisable(self)
end

function UIScratchOffRankPageView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.ScratchOffGameRankInfoUpdate, self.OnRefresh)
end

function UIScratchOffRankPageView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.ScratchOffGameRankInfoUpdate, self.OnRefresh)
end

function UIScratchOffRankPageView:RefreshRank(activityId)
    self.activityId = activityId
    SFSNetwork.SendMessage(MsgDefines.GetScratchOffGameRankInfo, activityId)
end

function UIScratchOffRankPageView:OnRefresh()
    self.actData = DataCenter.ScratchOffGameManager:GetRankInfoByActId(tonumber(self.activityId))
    if self.actData then
        self._selfName_txt:SetText(LuaEntry.Player.name)
        if LuaEntry.Player:IsInAlliance() then
            local allInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
            self._selfAName_txt:SetText(allInfo.abbr)
            self._selfAName_txt:SetActive(true)
        else
            self._selfAName_txt:SetActive(false)
        end
        if self.actData.selfRank == -1 then
            self._selfRank_txt:SetText("-")
        else
            self._selfRank_txt:SetText(self.actData.selfRank)
        end
        self._selfScoreDes_txt:SetLocalText(361001)
        self._selfScore_txt:SetText(self.actData.selfScore)
        self._selfHead_img:SetData(LuaEntry.Player.uid, LuaEntry.Player.pic, LuaEntry.Player.picVer)
        --if DataCenter.MonthCardNewManager:CheckIfMonthCardActive() then
        --    self._monthCard_img:SetActive(true)
        --else
        --    self._monthCard_img:SetActive(false)
        --end

        self:ClearScroll()

        self.rankList = self.actData.rankList
        self.rewardArr = self.actData.rankReward
        
        --自己当前排名奖励
        local selfRank = self.actData.selfRank
        if selfRank ~= -1 then
            self.rewardList = {}
            for i = 1 ,#self.rewardArr do
                if selfRank >= self.rewardArr[i].startN and selfRank <= self.rewardArr[i].endN then
                    self.rewardList = self.rewardArr[i].reward
                    break
                end
            end
            if next(self.rewardList) then
                self.scroll_viewSelf:SetTotalCount(#self.rewardList)
                self.scroll_viewSelf:RefillCells()
            end
        end
        
        self._rankName_txt:SetLocalText(302129)
        self._rankScore_txt:SetLocalText(361001)
        self._rankReward_txt:SetLocalText(302026)

        if self.rankList and #self.rankList >0 then
            self.scroll_view:SetTotalCount(#self.rankList)
            self.scroll_view:RefillCells()
        else
            self._noRank_txt:SetActive(true)
            self._noRank_txt:SetLocalText(110534)
        end
    end
end

function UIScratchOffRankPageView:OnItemMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.scroll_viewSelf:AddComponent(UIGolloesCardsRPCell, itemObj)
    cellItem:SetData(self.rewardList[index])
end

function UIScratchOffRankPageView:OnItemMoveOut( itemObj, index)
    self.scroll_viewSelf:RemoveComponent(itemObj.name, UIGolloesCardsRPCell)
end

function UIScratchOffRankPageView:OnRankItemMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.scroll_view:AddComponent(UIScratchOffRankItem, itemObj)
    cellItem:RefreshData(self.rankList[index],self.rewardArr)
end

function UIScratchOffRankPageView:OnRankItemMoveOut( itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIScratchOffRankItem)
end

function UIScratchOffRankPageView:ClearScroll()
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UIScratchOffRankItem)
    self.scroll_viewSelf:ClearCells()
    self.scroll_viewSelf:RemoveComponents(UIGolloesCardsRPCell)
end

function UIScratchOffRankPageView:OnClickSelfHead()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerInfo,LuaEntry.Player.uid)
end


return UIScratchOffRankPageView