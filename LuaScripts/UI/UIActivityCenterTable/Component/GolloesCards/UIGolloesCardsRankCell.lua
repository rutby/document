---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 
---
local UIGolloesCardsRankCell = BaseClass("UIGolloesCardsRankCell",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGolloesCardsRPCell = require "UI.UIActivityCenterTable.Component.GolloesCards.UIGolloesCardsRPCell"


function UIGolloesCardsRankCell:OnCreate()
    base.OnCreate(self)
    self.firstNameTxt  = self:AddComponent(UITextMeshProUGUIEx,"firstNameTxt")
    self.secondNameTxt = self:AddComponent(UITextMeshProUGUIEx,"secondNameTxt")
    self.scoreTxt      = self:AddComponent(UITextMeshProUGUIEx,"scoreTxt")
    
    self.firstImg      = self:AddComponent(UIBaseContainer,"firstImg")
    self.secondImg     = self:AddComponent(UIBaseContainer,"secondImg")
    self.thirdImg      = self:AddComponent(UIBaseContainer,"thirdImg")
    
    self.numTxt        = self:AddComponent(UITextMeshProUGUIEx,"numTxt")

    self._head_btn  = self:AddComponent(UIButton,"UIPlayerHead")
    self.playerHead = self:AddComponent(UIPlayerHead, "UIPlayerHead/HeadIcon")
    self.monthCard  = self:AddComponent(UIBaseContainer,"UIPlayerHead/Foreground")
    self._head_btn:SetOnClick(function()
       self:OnClickHead()
    end)

    self.scroll_view_reward = self:AddComponent(UIScrollView, "scrollView_Reward")
    self.scroll_view_reward:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.scroll_view_reward:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
end

function UIGolloesCardsRankCell:OnDestroy()
    self:ClearScroll()
    base.OnDestroy(self)
end

function UIGolloesCardsRankCell:OnEnable()
    base.OnEnable(self)
end

function UIGolloesCardsRankCell:OnDisable()
    base.OnDisable(self)
end

function UIGolloesCardsRankCell:RefreshData(data,rewardArr)
    self.data = data
    local name = data.name
    if self.view.isServerRank and data.serverId and data.serverId ~= 0 then
        name = Localization:GetString('372761',data.serverId,data.name)
    end
    self.firstNameTxt:SetText(name)
    if data.abbr == "" then
        self.secondNameTxt:SetText("-")
    else
        self.secondNameTxt:SetText("["..data.abbr.."]"..data.alliancename)
    end
    self.scoreTxt:SetText(data.score)

    self.firstImg:SetActive(data.rank == 1)
    self.secondImg:SetActive(data.rank == 2)
    self.thirdImg:SetActive(data.rank == 3)
    self.numTxt:SetActive(data.rank > 3)
    self.numTxt:SetText(data.rank)

    self.playerHead:SetData(data.uid, data.pic, data.picVer)
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    self.monthCard:SetActive(data.monthCardEndTime > 0 and data.monthCardEndTime > curTime)
    self.rewardList = {}
    for i = 1 ,#rewardArr do
        if data.rank >= rewardArr[i].startN and data.rank <= rewardArr[i].endN then
            self.rewardList = rewardArr[i].reward
            break
        end
    end 
    if next(self.rewardList) then
        self:ClearScroll()
        self.scroll_view_reward:SetTotalCount(#self.rewardList)
        self.scroll_view_reward:RefillCells()
    end
end

function UIGolloesCardsRankCell:OnItemMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.scroll_view_reward:AddComponent(UIGolloesCardsRPCell, itemObj)
    cellItem:SetData(self.rewardList[index])
end

function UIGolloesCardsRankCell:OnItemMoveOut( itemObj, index)
    self.scroll_view_reward:RemoveComponent(itemObj.name, UIGolloesCardsRPCell)
end
function UIGolloesCardsRankCell:ClearScroll()
    self.scroll_view_reward:ClearCells()
    self.scroll_view_reward:RemoveComponents(UIGolloesCardsRPCell)
end

function UIGolloesCardsRankCell:OnClickHead()
    if self.data.uid ~= LuaEntry.Player.uid then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIOtherPlayerInfo,self.data.uid)
    else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerInfo,LuaEntry.Player.uid)
    end
end

return UIGolloesCardsRankCell