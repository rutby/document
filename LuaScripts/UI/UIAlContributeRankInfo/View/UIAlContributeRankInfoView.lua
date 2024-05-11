---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1020.
--- DateTime: 2023/4/10 15:18
---

local UIAlContributeRankInfoView = BaseClass("UIAlContributeRankInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AlContributeRankInfoItem = require "UI.UIAlContributeRankInfo.Component.AlContributeRankInfoItem"

--UICommonMidPopUpTitle
local txtTitle_Path = "UICommonMidPopUpTitle/txtTitle"
local btnClose_Path = "UICommonMidPopUpTitle/btnClose"
local btnPanel_path = "UICommonMidPopUpTitle/btnPanel"

--Root
local txtScoreProcess_Path = "Root/processBarRoot/txtScoreProcess"
local imgExploitIcon_Path = "Root/processBarRoot/imgExploitIcon"
local btnMoreScore_Path = "Root/processBarRoot/btnMoreScore"
local sliderProcessBar_Path = "Root/processBarRoot/SliderProcessBar"
local scrollView_Path = "Root/ScrollView"
local txtDesc_Path = "Root/txtDesc"
local rankStar_path = "Root/processBarRoot/imgExploitIcon/rankStar/starImage"

function UIAlContributeRankInfoView : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:RefreshView()
end

function UIAlContributeRankInfoView : OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIAlContributeRankInfoView : OnAddListener()
    base.OnAddListener(self)
    --self:AddUIListener(EventId.UpdateSelfExploit, self.RefreshView)
end

function UIAlContributeRankInfoView : OnRemoveListener()
    --self:RemoveUIListener(EventId.UpdateSelfExploit, self.RefreshView)
    base.OnRemoveListener(self)
end

function UIAlContributeRankInfoView : DataDefine()
    self.itemInfoList = {}
    self.activityId = tonumber(self:GetUserData()) 
end

function UIAlContributeRankInfoView : DataDestroy()
    self.itemInfoList = nil
    self.activityId = 0
end

function UIAlContributeRankInfoView : ComponentDefine()
    --UICommonMidPopUpTitle
    self.txtTitle = self:AddComponent(UIText, txtTitle_Path)
    self.txtTitle:SetLocalText(372854)
    
    self.btnClose = self:AddComponent(UIButton, btnClose_Path)
    self.btnClose:SetOnClick(function()
        self.ctrl:OnClickCloseBtn()
    end)
    
    self.btnPanel = self:AddComponent(UIButton, btnPanel_path)
    self.btnPanel:SetOnClick(function()
        self.ctrl:OnClickCloseBtn()
    end)

    --Root
    self.txtScoreProcess = self:AddComponent(UIText, txtScoreProcess_Path)
    local selfScore = DataCenter.AlContributeManager:GetSelfScore()
    local nextScore = DataCenter.AlContributeManager:GetNextRankScore()
    self.txtScoreProcess:SetText(string.GetFormattedSeperatorNum(selfScore).."/"..string.GetFormattedSeperatorNum(nextScore));

    self.sliderProcessBar = self:AddComponent(UISlider, sliderProcessBar_Path)
    self.sliderProcessBar:SetValue(selfScore/nextScore)
    
    self.imgExploitIcon = self:AddComponent(UIImage, imgExploitIcon_Path)
    local selfRank = DataCenter.AlContributeManager:GetSelfExploitRank()
    local imgExploitIconPath = DataCenter.AlContributeManager:GetExploitImgPathByRank(selfRank)
    self.imgExploitIcon:LoadSprite(imgExploitIconPath);
    
    self.rankStarList = {}
    for i = 1, 4 do
        local rankStar = self:AddComponent(UIBaseContainer, rankStar_path .. i)
        table.insert(self.rankStarList, rankStar)
    end
    local starNum = DataCenter.AlContributeManager: GetConfigDataByRank(selfRank, "star")
    for i, v in ipairs(self.rankStarList) do
        if i <= starNum then
            v:SetActive(true)
        else
            v:SetActive(false)
        end
    end
    
    self.btnMoreScore = self:AddComponent(UIButton, btnMoreScore_Path)
    self.btnMoreScore:SetOnClick(function()
        self.ctrl:OnClickMoreScoreBtn(self.activityId)
    end)
    
    self.ScrollView = self:AddComponent(UIScrollView, scrollView_Path)
    self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnRankItemMoveIn(itemObj, index)
    end)
    self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnRankItemMoveOut(itemObj, index)
    end)

    self.txtDesc = self:AddComponent(UIText, txtDesc_Path)
    self.txtDesc:SetLocalText(372857)
end

function UIAlContributeRankInfoView : ComponentDestroy()
    self:ClearScroll()
end

function UIAlContributeRankInfoView : OnRankItemMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.ScrollView:AddComponent(AlContributeRankInfoItem, itemObj)
    item:SetData(index, self.itemInfoList[index])
end

function UIAlContributeRankInfoView : OnRankItemMoveOut(itemObj, index)
    self.ScrollView:RemoveComponent(itemObj.name, AlContributeRankInfoItem)
end

function UIAlContributeRankInfoView : ClearScroll()
    self.ScrollView:ClearCells()
    self.ScrollView:RemoveComponents(AlContributeRankInfoItem)
end

function UIAlContributeRankInfoView : RefreshView()
    self.itemInfoList = DataCenter.AlContributeManager:GetExploitRewardList()
    if self.itemInfoList == nil then
        return
    end
    
    table.sort(self.itemInfoList,function(a,b)
        return a["rank"] < b["rank"]
    end)
    local unTakeRewardIndex = #self.itemInfoList
    for i,j in ipairs(self.itemInfoList) do
        if j["state"] == 0 then
            unTakeRewardIndex = i
            break
        end
    end
    if self.itemInfoList ~= nil and #self.itemInfoList > 0 then
        self.ScrollView:SetTotalCount(#self.itemInfoList)
        self.ScrollView:RefillCells()
        local selfRank = DataCenter.AlContributeManager:GetSelfExploitRank()
        local toIndex = math.min(selfRank + 1, unTakeRewardIndex)
        self.ScrollView:ScrollToCell(toIndex - 1, 5000)
    end
end

function UIAlContributeRankInfoView : OnGetReward(index)
    self.itemInfoList[index]["state"] = 1
end

return UIAlContributeRankInfoView