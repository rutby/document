---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/15 16:38
---UIConsumeItemView.lua

local base = UIBaseView--Variable
local UIConsumeItemView = BaseClass("UIConsumeItemView", base)--Variable
local Localization = CS.GameEntry.Localization
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local title_path = "UICommonMiniPopUpTitle/Bg_mid/titleText"
local closeBtn_path = "UICommonMiniPopUpTitle/Bg_mid/CloseBtn"
local consumeTip_path = "UICommonMiniPopUpTitle/DesName"
local consumeItem_path = "UICommonMiniPopUpTitle/UICommonItemAct"
local confirmBtn_path = "UICommonMiniPopUpTitle/BtnGo/moveBtn"
local confirmTxt_path = "UICommonMiniPopUpTitle/BtnGo/moveBtn/offset/moveBtnTxt"
local priceContainer_path = "UICommonMiniPopUpTitle/BtnGo/moveBtn/offset/cost"
local goldCountTxt_path = "UICommonMiniPopUpTitle/BtnGo/moveBtn/offset/cost/costGoldCount"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:InitData()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.goTextMat = self.transform:Find("UICommonMiniPopUpTitle/BtnGo/moveBtn/goTextMat"):GetComponent(typeof(CS.UnityEngine.MeshRenderer))
    self.titleN = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.titleN:SetLocalText(100161)
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.consumeTipN = self:AddComponent(UITextMeshProUGUIEx, consumeTip_path)
    self.consumeItemN = self:AddComponent(UICommonItem, consumeItem_path)
    self.confirmBtnN = self:AddComponent(UIButton, confirmBtn_path)
    self.confirmBtnImg = self:AddComponent(UIImage, confirmBtn_path)
    self.confirmBtnN:SetOnClick(function()
        self:OnClickConfirmBtn()
    end)
    self.confirmTxtN = self:AddComponent(UITextMeshProUGUIEx, confirmTxt_path)
    self.priceContainerN = self:AddComponent(UIBaseContainer, priceContainer_path)
    self.goldCountTxtN = self:AddComponent(UITextMeshProUGUIEx, goldCountTxt_path)
end

local function ComponentDestroy(self)
    self.titleN = nil
    self.closeBtnN = nil
    self.consumeTipN = nil
    self.consumeItemN = nil
    self.confirmBtnN = nil
    self.confirmTxtN = nil
    self.goldCountTxtN = nil
end

local function DataDefine(self)
    self.consumeType = nil
    self.consumeItemId = nil
    self.consumeCount = nil
    self.consumeEnough = nil
end

local function DataDestroy(self)
    self.consumeType = nil
    self.consumeItemId = nil
    self.consumeCount = nil
    self.consumeEnough = nil
end

--[[
local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end
--]]

local function InitData(self)
    self.consumeType = self:GetUserData()
    self.consumeItemId, self.consumeCount, self.consumeEnough = self:GetConsumeItemInfo()
    
    
    self:RefreshAll()
end

local function RefreshAll(self)
    self:SetTitle()
    self:SetItem()
    self:SetConsumeTip()
    self:SetConfirmBtn()
end

local function SetTitle(self)
    local strTitle = ""
    if self.consumeType == ConsumeItemType.AlMoveCity_SysInvite
            or self.consumeType == ConsumeItemType.AlMoveCity_LeaderInvite then
        strTitle = Localization:GetString("390883")
    end
    
    self.titleN:SetText(strTitle)
end

local function SetItem(self)
    if self.consumeItemId then
        local rewardInfo = {}
        rewardInfo.rewardType = RewardType.GOODS
        rewardInfo.itemId = self.consumeItemId
        rewardInfo.count = self.consumeCount
        self.consumeItemN:SetActive(true)
        self.consumeItemN:ReInit(rewardInfo)
        local countColor = self.consumeEnough and WhiteColor or RedColor
        self.consumeItemN:SetItemCountColor(countColor)
    else
        self.consumeItemN:SetActive(false)
    end
end

local function SetConsumeTip(self)
    local strTitle = ""
    if self.consumeType == ConsumeItemType.AlMoveCity_SysInvite
            or self.consumeType == ConsumeItemType.AlMoveCity_LeaderInvite then
        if self.consumeEnough then
            strTitle = Localization:GetString("110229")
        else
            local _, tempPrice = self:GetPrice()
            strTitle = Localization:GetString("391076", tempPrice)
        end
    end

    self.consumeTipN:SetText(strTitle)
end

local function SetConfirmBtn(self)
    if self.consumeType == ConsumeItemType.AlMoveCity_SysInvite
        or self.consumeType == ConsumeItemType.AlMoveCity_LeaderInvite then
        self.confirmTxtN:SetLocalText(110046)
        if self.consumeEnough then
            self.priceContainerN:SetActive(false)
            self.confirmBtnImg:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_green101"))
            self.confirmTxtN:SetMaterial(self.goTextMat.sharedMaterials[1])
        else
            self.confirmBtnImg:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_yellow101"))
            self.confirmTxtN:SetMaterial(self.goTextMat.sharedMaterials[2])
            self.priceContainerN:SetActive(true)
            local rewardType, price = self:GetPrice()
            self.goldCountTxtN:SetText(price)
            if LuaEntry.Player.gold < price then
                self.goldCountTxtN:SetColor(RedColor)
            else
                self.goldCountTxtN:SetColor(WhiteColor)
            end
        end
    end
end

--return itemId, needCount, isEnough
local function GetConsumeItemInfo(self)
    if self.consumeType == ConsumeItemType.AlMoveCity_SysInvite
        or self.consumeType == ConsumeItemType.AlMoveCity_LeaderInvite then
        local ownCount = DataCenter.ItemData:GetItemCount(SpecialItemId.ITEM_ALLIANCE_CITY_MOVE)
        return SpecialItemId.ITEM_ALLIANCE_CITY_MOVE, 1, ownCount > 0
    end
end

local function GetPrice(self)
    if self.consumeType == ConsumeItemType.AlMoveCity_SysInvite
        or self.consumeType == ConsumeItemType.AlMoveCity_LeaderInvite then
        local price = LuaEntry.DataConfig:TryGetNum("union_move", "k3") or 0
        return RewardType.GOLD, price
    end
end


local function OnClickConfirmBtn(self)
    if self.consumeType == ConsumeItemType.AlMoveCity_LeaderInvite
        or self.consumeType == ConsumeItemType.AlMoveCity_SysInvite then
        local cacheType = self.consumeType
        if self.consumeEnough then
            local worldPointPos = SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
            GoToUtil.GotoWorldPos(worldPointPos, CS.SceneManager.World.InitZoom,LookAtFocusTime,function()
                SFSNetwork.SendMessage(MsgDefines.AllianceMoveCity, 2, cacheType == ConsumeItemType.AlMoveCity_LeaderInvite)
                EventManager:GetInstance():Broadcast(EventId.SetMovingUI,UIMovingType.Open)
            end)
        else
            local _, price = self:GetPrice()
            if LuaEntry.Player.gold >= price then
                UIUtil.ShowMessage(Localization:GetString("391076", price),2,"","", function()
                    local worldPointPos = SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
                    GoToUtil.GotoWorldPos(worldPointPos, CS.SceneManager.World.InitZoom,LookAtFocusTime,function()
                        SFSNetwork.SendMessage(MsgDefines.AllianceMoveCity, 3, cacheType == ConsumeItemType.AlMoveCity_LeaderInvite)
                        EventManager:GetInstance():Broadcast(EventId.SetMovingUI,UIMovingType.Open)
                    end)
                end, function()
                end)
            else
                GoToUtil.GotoPayTips()
            end
        end
    end
end

local function OnClickCloseBtn(self)
    self.ctrl:CloseSelf()
end

UIConsumeItemView.OnCreate = OnCreate 
UIConsumeItemView.OnDestroy = OnDestroy
--UIConsumeItemView.OnAddListener = OnAddListener
--UIConsumeItemView.OnRemoveListener = OnRemoveListener
UIConsumeItemView.ComponentDefine = ComponentDefine
UIConsumeItemView.ComponentDestroy = ComponentDestroy
UIConsumeItemView.DataDefine = DataDefine
UIConsumeItemView.DataDestroy = DataDestroy

UIConsumeItemView.InitData = InitData
UIConsumeItemView.RefreshAll = RefreshAll
UIConsumeItemView.SetTitle = SetTitle
UIConsumeItemView.SetItem = SetItem
UIConsumeItemView.SetConsumeTip = SetConsumeTip
UIConsumeItemView.SetConfirmBtn = SetConfirmBtn
UIConsumeItemView.GetConsumeItemInfo = GetConsumeItemInfo
UIConsumeItemView.GetPrice = GetPrice
UIConsumeItemView.OnClickConfirmBtn = OnClickConfirmBtn
UIConsumeItemView.OnClickCloseBtn = OnClickCloseBtn

return UIConsumeItemView