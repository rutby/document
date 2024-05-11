---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/10/9 19:25
---
local RuinRewardDetailItem = require "UI.UIRuinRewardDetail.Component.RuinRewardDetailItem"
local UIRuinRewardDetailView = BaseClass("UIRuinRewardDetailView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local txt_title_path ="UICommonPopUpTitle/bg_mid/titleText"
local txt_des_path ="title/des"
local txt_score_path = "title/scoreDes/scoreNum"
local txt_score_des_path = "title/scoreDes"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local scrollView_path = "ScrollView"
local rankDes_path = "Head/RankDesc"
local NameDes_path = "Head/NameDesc"
local StateDesc_path = "Head/StateDesc"
local RewardDesc_path = "Head/RewardDesc"

local function OnCreate(self)
    base.OnCreate(self)
    self.cityLv,self.cityId = self:GetUserData()
    self.score = 0
    self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
    self.txt_title:SetLocalText(111244)
    self.txt_des = self:AddComponent(UITextMeshProUGUIEx, txt_des_path)
    local desStr = Localization:GetString("111248")
    self.txt_des:SetText(desStr)
    self.txt_score = self:AddComponent(UITextMeshProUGUIEx, txt_score_path)
    self.txt_reward = self:AddComponent(UITextMeshProUGUIEx, txt_score_des_path)
    self.txt_reward:SetLocalText(111245)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.showDatalist ={}
    self.ScrollView = self:AddComponent(UIScrollView, scrollView_path)
    self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)

    self.rankDes = self:AddComponent(UITextMeshProUGUIEx, rankDes_path)
    self.rankDes:SetLocalText(450081)
    self.nameDes = self:AddComponent(UITextMeshProUGUIEx, NameDes_path)
    self.nameDes:SetLocalText(450082)
    self.stateDes = self:AddComponent(UITextMeshProUGUIEx, StateDesc_path)
    self.stateDes:SetLocalText(450083)
    self.rewardDes = self:AddComponent(UITextMeshProUGUIEx, RewardDesc_path)
    self.rewardDes:SetLocalText(450084)
    
    SFSNetwork.SendMessage(MsgDefines.WorldGetAllianceCityDetail,self.cityId,LuaEntry.Player:GetSelfServerId())
end

local function OnDestroy(self)
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end


local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.WorldAllianceCityDetail, self.SetRewardState)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.WorldAllianceCityDetail, self.SetRewardState)
end
local function SetRewardState(self)
    local cityDetail = DataCenter.WorldPointDetailManager:GetAllianceCityData(self.cityId)
    if cityDetail~=nil then
        self.score = cityDetail.selfKillPoint
    end
    self:RefreshList()
end
local function ClearScroll(self)
    self.ScrollView:ClearCells()
    self.ScrollView:RemoveComponents(RuinRewardDetailItem)
    self.showDatalist = {}
end

local function OnItemMoveIn(self,itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.ScrollView:AddComponent(RuinRewardDetailItem, itemObj)
    cellItem:SetItemShow(self.showDatalist[index],self.curIndex)
end

local function OnItemMoveOut(self, itemObj, index)
    self.ScrollView:RemoveComponent(itemObj.name, RuinRewardDetailItem)
end

local function RefreshList(self)
    self.txt_score:SetText(string.GetFormattedSeperatorNum(math.floor(self.score)))
    self:ClearScroll()
    local data = self.ctrl:GetRewardList(self.cityLv,self.score)
    self.curIndex = data.curIndex
    self.showDatalist = data.dataList
    if #self.showDatalist>0 then
        local index = math.max(1,self.curIndex-5)
        self.ScrollView:SetTotalCount(#self.showDatalist)
        self.ScrollView:RefillCells(index)
    end
end

UIRuinRewardDetailView.OnCreate= OnCreate
UIRuinRewardDetailView.OnDestroy = OnDestroy
UIRuinRewardDetailView.OnEnable = OnEnable
UIRuinRewardDetailView.OnDisable = OnDisable
UIRuinRewardDetailView.OnAddListener = OnAddListener
UIRuinRewardDetailView.OnRemoveListener = OnRemoveListener
UIRuinRewardDetailView.RefreshList = RefreshList
UIRuinRewardDetailView.ClearScroll =ClearScroll
UIRuinRewardDetailView.OnItemMoveIn = OnItemMoveIn
UIRuinRewardDetailView.OnItemMoveOut =OnItemMoveOut
UIRuinRewardDetailView.SetRewardState =SetRewardState
return UIRuinRewardDetailView