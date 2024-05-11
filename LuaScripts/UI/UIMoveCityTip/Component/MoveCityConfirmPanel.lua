---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/15 17:23
---MoveCityConfirmPanel

local MoveCityConfirmPanel = BaseClass("MoveCityConfirmPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local AllianceFlagItem = require "UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem"

local moveDesc_path = "moveDesc"
local moveBtn_path = "moveBtn"
local moveBtnTxt_path = "moveBtn/offset/moveBtnTxt"
local moveCost_path = "moveBtn/offset/cost"
local moveCostFree_path = "moveBtn/offset/cost/costFree"
local moveCostIcon_path = "moveBtn/offset/cost/costItem"
local moveCostNum_path = "moveBtn/offset/cost/costGoldCount"
local allianceFlag_path = "allianceFlag"

local function OnCreate(self)
    base.OnCreate(self)

    self.moveDescN = self:AddComponent(UITextMeshProUGUIEx, moveDesc_path)
    self.moveBtnN = self:AddComponent(UIButton, moveBtn_path)
    self.moveBtnN:SetOnClick(function()
        self:OnClickMoveBtn()
    end)
    self.moveBtnTxtN = self:AddComponent(UITextMeshProUGUIEx, moveBtnTxt_path)
    self.moveBtnTxtN:SetLocalText(391075)
    self.moveCostN = self:AddComponent(UIBaseContainer, moveCost_path)
    self.moveCostFreeN = self:AddComponent(UITextMeshProUGUIEx, moveCostFree_path)
    self.moveCostFreeN:SetLocalText(130126)
    self.moveCostIconN = self:AddComponent(UIImage, moveCostIcon_path)
    self.moveCostNumN = self:AddComponent(UITextMeshProUGUIEx, moveCostNum_path)
    self.allianceFlagN = self:AddComponent(AllianceFlagItem, allianceFlag_path)
end

local function OnDestroy(self)
    self.moveDescN = nil
    self.moveBtnN = nil
    self.moveBtnTxtN = nil
    self.moveCostN = nil
    self.moveCostFreeN = nil
    self.moveCostIconN = nil
    self.moveCostNumN = nil
    self.allianceFlagN = nil
    base.OnDestroy(self)
end

local function ShowPanel(self, isShow, param)
    if not isShow then
        self:SetActive(false)
        return
    end
    
    self.costType = 1
    self.paramTb = param
    self:SetActive(true)

    --if self.paramTb.strTip then
    --    self.moveDescN:SetText(self.paramTb.strTip)
    if self.paramTb.openType == MoveCityTipType.RallyCheck then
        self.moveDescN:SetLocalText(391098)
    elseif self.paramTb.openType == MoveCityTipType.LeaderInvite or self.paramTb.openType == MoveCityTipType.SystemInvite then
        local point = DataCenter.AllianceBaseDataManager:GetAlMoveInviteTargetPoint(self.paramTb.openType)
        if point then
            local inviter = self.paramTb.openType == MoveCityTipType.LeaderInvite and (Localization:GetString("302336"))
                or (Localization:GetString("390327"))
            local targetPos = SceneUtils.IndexToTilePos(point, ForceChangeScene.World)
            self.moveDescN:SetText(Localization:GetString("391118", inviter, targetPos.x, targetPos.y))
        else
            self.moveDescN:SetLocalText(391080)
        end
    else
        self.moveDescN:SetLocalText(141140)
    end
    
    --邀请迁城把消耗道具和钻石放到了新的UI里
    if self.paramTb.openType == MoveCityTipType.LeaderInvite or self.paramTb.openType == MoveCityTipType.SystemInvite then
        self.moveCostN:SetActive(false)
        if LuaEntry.Player:CheckIfHasFreeAlMove() then
            self.costType = 1
        else
            local item = DataCenter.ItemData:GetItemById(SpecialItemId.ITEM_ALLIANCE_CITY_MOVE)
            local itemCount = item and item.count or 0
            if itemCount > 0 then
                self.costType = 2
            else
                self.costType = 3
            end
        end
    else
        self.moveCostN:SetActive(true)
        if LuaEntry.Player:CheckIfHasFreeAlMove() then
            self.moveCostFreeN:SetActive(true)
            self.moveCostIconN:SetActive(false)
            self.moveCostNumN:SetActive(false)
            self.costType = 1
        else
            self.moveCostFreeN:SetActive(false)
            local item = DataCenter.ItemData:GetItemById(SpecialItemId.ITEM_ALLIANCE_CITY_MOVE)
            local itemCount = item and item.count or 0
            if itemCount > 0 then
                self.moveCostIconN:SetActive(true)
                self.moveCostNumN:SetActive(false)
                self.costType = 2
            else
                self.moveCostIconN:SetActive(false)
                self.moveCostNumN:SetActive(true)
                local price = LuaEntry.DataConfig:TryGetNum("union_move", "k3") or 0
                --local template = DataCenter.ItemTemplateManager:GetItemTemplate(SpecialItemId.ITEM_ALLIANCE_CITY_MOVE)
                --local price = template.sales
                self.moveCostNumN:SetText(price)
                self.costType = 3
            end
        end
    end
    

    local allianceBase = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allianceBase and allianceBase.icon then
        self.allianceFlagN:SetData(allianceBase.icon)
    end
end

local function OnClickMoveBtn(self)
    local byInvite = (self.paramTb and self.paramTb.openType == MoveCityTipType.LeaderInvite) and true or false
    if (self.paramTb.openType == MoveCityTipType.LeaderInvite or self.paramTb.openType == MoveCityTipType.SystemInvite)
        and self.costType ~= 1 then
        local consumeType = self.paramTb.openType == MoveCityTipType.LeaderInvite and ConsumeItemType.AlMoveCity_LeaderInvite or ConsumeItemType.AlMoveCity_SysInvite
        UIUtil.OpenConsumeItemView(consumeType)
    else
        if self.costType == 3 then
            --local template = DataCenter.ItemTemplateManager:GetItemTemplate(SpecialItemId.ITEM_ALLIANCE_CITY_MOVE)
            --local price = template.sales
            local price = LuaEntry.DataConfig:TryGetNum("union_move", "k3") or 0

            if LuaEntry.Player.gold < tonumber(price) then
                self.view.ctrl:CloseSelf()
                GoToUtil.GotoPayTips()
                return
            else
                self.view.ctrl:Close()
                UIUtil.ShowMessage(Localization:GetString("391076", price),2,"","", function()
                    local costType = self.costType
                    local worldPointPos = SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
                    GoToUtil.GotoWorldPos(worldPointPos, CS.SceneManager.World.InitZoom,LookAtFocusTime,function()
                        SFSNetwork.SendMessage(MsgDefines.AllianceMoveCity, costType, byInvite)
                        EventManager:GetInstance():Broadcast(EventId.SetMovingUI,UIMovingType.Open)
                    end)
                end, function()
                end)
            end
        else
            local worldPointPos = SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
            local costType = self.costType
            GoToUtil.GotoWorldPos(worldPointPos, CS.SceneManager.World.InitZoom,LookAtFocusTime,function()
                SFSNetwork.SendMessage(MsgDefines.AllianceMoveCity, costType, byInvite)
                EventManager:GetInstance():Broadcast(EventId.SetMovingUI,UIMovingType.Open)
            end)
        end
    end
    
    
end

MoveCityConfirmPanel.OnCreate = OnCreate
MoveCityConfirmPanel.OnDestroy = OnDestroy

MoveCityConfirmPanel.ShowPanel = ShowPanel
MoveCityConfirmPanel.OnClickMoveBtn = OnClickMoveBtn

return MoveCityConfirmPanel