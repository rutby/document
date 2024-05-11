---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/1/13 11:51
---

local BarterShopItem = BaseClass("BarterShopItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local RewardUtil = require "Util.RewardUtil"
local ActivityRewardItem = require "UI.UIActivityCenterTable.Component.BarterShopRewardItem"

local remainTimes_path = "remainTimes"
local contentNeed_path = "Barter/contentNeed"
local contentGet_path = "Barter/contentGet"
local contentBarter_path = "Barter"
local barterBtn_path = "Btn_Reward"
local barterBtnTxt_path = "Btn_Reward/Txt_Reward"
local noTimesTxt_path = "Txt_Completed"
local vip_text_path = "Txt_VIP"
local more_btn_go_path = "Btn_Reward/MoreBtnGo"

-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

--控件的定义
local function ComponentDefine(self)
    self.remainTimesN = self:AddComponent(UIText, remainTimes_path)
    self.contentNeedN = self:AddComponent(UIBaseContainer, contentNeed_path)
    self.contentGetN = self:AddComponent(UIBaseContainer, contentGet_path)
    self.contentBarterN = self:AddComponent(UIBaseContainer, contentBarter_path)
    self.barterBtnN = self:AddComponent(UIButton, barterBtn_path)
    self.barterBtnN:SetOnClick(function()
        self:OnClickBarterBtn()
    end)
    self.barterBtnTxtN = self:AddComponent(UIText, barterBtnTxt_path)
    self.barterBtnTxtN:SetLocalText(110029)
    self.noTimesTxtN = self:AddComponent(UIText, noTimesTxt_path)
    self.noTimesTxtN:SetLocalText(372159)
    self.vip_text = self:AddComponent(UIText, vip_text_path)
    self.vip_text:SetText("")

    self.more_btn_go = self:AddComponent(UIBaseContainer, more_btn_go_path)
end

--控件的销毁
local function ComponentDestroy(self)
    self:SetAllNeedCellDestroy()
    self:SetAllGetCellDestroy()
    self.remainTimesN = nil
    self.contentNeedN = nil
    self.contentGetN = nil
    self.contentBarterN = nil
    self.barterBtnN = nil
    self.barterBtnTxtN = nil
end

--变量的定义
local function DataDefine(self)
    self.barterInfo = nil
    self.lackItem = nil
    self.getList = nil
    self.needList = nil
    self.isDecorationSend = false
end

--变量的销毁
local function DataDestroy(self)
    self.barterInfo = nil
    self.lackItem = nil
    self.getList = nil
    self.needList = nil
    self.isDecorationSend = false
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.BarterShopExchangeSucc, self.OnGetBarterSucc)
    self:AddUIListener(EventId.OnClaimRewardEffFinish, self.RefreshNeed)

end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.BarterShopExchangeSucc, self.OnGetBarterSucc)
    self:RemoveUIListener(EventId.OnClaimRewardEffFinish, self.RefreshNeed)
    base.OnRemoveListener(self)
end


local function SetItem(self, tempInfo, actInfo, isPreview,isNewPre,callBack,index)
    self.barterInfo = tempInfo
    self.activityInfo = actInfo
    self.isPreview = isPreview == true
    self.isNewPre = isNewPre
    self.callBack = callBack
    self.index = index
    if self.barterInfo then
        self.isDecorationSend = (toInt(self.barterInfo.is_decoration_gift) == 1)
        self.gift_require = self.barterInfo.gift_require
    end
    
    self:RefreshBarter()
    self:RefreshRemainTimes()
end

--返回是否还有剩余次数
local function RefreshRemainTimes(self)
    local getNum = self.activityInfo:GetExchangedNum(self.barterInfo.id)
    self.remainTimesN:SetText(Localization:GetString("372157", getNum, self.barterInfo.times))

    if self.isPreview then
        self.remainTimesN:SetActive(true)
        self.noTimesTxtN:SetActive(false)
        self.vip_text:SetActive(false)
        self.barterBtnN:SetActive(true)
        UIGray.SetGray(self.barterBtnN.transform, true, true)
    else
        local vipNeed = toInt(self.barterInfo.vip)
        local vipOk = true
        if vipNeed > 0 then
            local vipInfo = DataCenter.VIPManager:GetVipData()
            if vipInfo and vipNeed > vipInfo.level then
                vipOk = false
            end
        end
        if self.isDecorationSend then
            self.barterBtnTxtN:SetLocalText(320757)
        else
            self.barterBtnTxtN:SetLocalText(110029)
        end

        local noTimes = getNum >= self.barterInfo.times
        local canBarter = (not noTimes) and (not self.lackItem) and vipOk
        
        UIGray.SetGray(self.barterBtnN.transform, not canBarter, not noTimes and vipOk)
        if noTimes then
            self.barterBtnN:SetActive(false)
            self.remainTimesN:SetActive(false)
            self.noTimesTxtN:SetActive(true)
        else
            self.barterBtnN:SetActive(true)
            self.remainTimesN:SetActive(true)
            self.noTimesTxtN:SetActive(false)
            self.vip_text:SetActive(not vipOk)
            if not vipOk then
                self.barterBtnN:SetActive(false)
                self.vip_text:SetLocalText(320297, vipNeed)
                self.remainTimesN:SetText("")
            end
        end
        if not noTimes then
            return true
        end
    end
end

local function RefreshBarter(self)
    self:RefreshNeed(true)
    self:RefreshGet(true)
end

local function RefreshNeed(self, forceUpdate)
    if not self.barterInfo then
        return
    end
    self.lackItem = nil
    self:SetAllNeedCellDestroy()
    self.needList = self.view.ctrl:GetBarterItemsList(self.barterInfo.item1, true)
    --if not self.needList or #self.needList == 0 or forceUpdate then
    --end
    self.needModels = {}
    if self.needList ~= nil then
        for i = 1, table.length(self.needList) do
            --复制基础prefab，每次循环创建一次
            self.needModels[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonItem, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                --go.gameObject:SetActive(true)
                go.transform:SetParent(self.contentNeedN.transform)
                if self.isNewPre then
                    go.transform:Set_localScale(0.68, 0.68,0.68)
                else
                    go.transform:Set_localScale(0.6, 0.6,0.6)
                end
                go.transform:Set_localPosition(0, -50,0)
                go.name ="item" .. i
                local cell = self.contentNeedN:AddComponent(ActivityRewardItem,go.name)
                local costIsEnough = self.needList[i].count >= self.needList[i].cost
                if not self.lackItem and not costIsEnough then
                    self.lackItem = self.needList[i]
                end
                if cell.num_text then
                    cell.num_text:SetActive(true)
                end
                cell:RefreshData(self.needList[i])
                self.needList[i].iconImg = go.transform:Find("clickBtn/ItemIcon")

                if i == #self.needList then
                    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.contentBarterN.rectTransform)
                    self:RefreshRemainTimes()
                end
            end)
        end
    end
end

local function RefreshGet(self, forceUpdate)
    self:SetAllGetCellDestroy()
    if not self.getList or #self.getList == 0 or forceUpdate then
        if self.isDecorationSend then
            self.getList = self.view.ctrl:GetBarterItemsList(self.barterInfo.gift_goods, false)
        else
            self.getList = self.view.ctrl:GetBarterItemsList(self.barterInfo.item2, false)
        end
    end
    self.getModels = {}
    if self.getList ~= nil then
        for i = 1, table.length(self.getList) do
            --复制基础prefab，每次循环创建一次
            self.getModels[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonItem, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                --go.gameObject:SetActive(true)
                go.transform:SetParent(self.contentGetN.transform)
                if self.isNewPre then
                    go.transform:Set_localScale(0.68, 0.68,0.68)
                else
                    go.transform:Set_localScale(0.6, 0.6,0.6)
                end
                go.transform:Set_localPosition(0, -50,0)
                go.name ="item" .. i
                local cell = self.contentGetN:AddComponent(ActivityRewardItem,go.name)
                if cell.num_text then
                    cell.num_text:SetActive(true)
                end
                cell:RefreshData(self.getList[i])
                self.getList[i].iconImg = go.transform:Find("clickBtn/ItemIcon")

                if i == #self.getList then
                    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.contentBarterN.rectTransform)
                end
            end)
        end
    end
end

--Obsolete
local function GetItemsList(self, strConf, isNeed)
    local retList = {}
    local strList = string.split(strConf, "|")
    for i, v in ipairs(strList) do
        local paramList = string.split(v, ";")
        local oneItem = {}
        if #paramList == 2 then
            oneItem.rewardType = tonumber(paramList[1])
            if isNeed then
                local resType = RewardToResType[tonumber(paramList[1])]
                local tempCount = 0
                if resType == ResourceType.Gold then
                    tempCount = LuaEntry.Player.gold
                else
                    tempCount = LuaEntry.Resource:GetCntByResType(resType)
                end
                oneItem.count = tempCount
                oneItem.cost = tonumber(paramList[2])
            else
                oneItem.count = tonumber(paramList[2])
            end
            table.insert(retList, oneItem)
        elseif #paramList == 3 then
            oneItem.rewardType = tonumber(paramList[1])
            oneItem.itemId = paramList[2]
            if isNeed then
                local costItem = DataCenter.ItemData:GetItemById(paramList[2])
                local ownNum = costItem and costItem.count or 0
                oneItem.count = ownNum
                oneItem.cost = tonumber(paramList[3])
            else
                oneItem.count = tonumber(paramList[3])
            end
            table.insert(retList, oneItem)
        end
    end
    return self.view.ctrl:RewardItemList(retList)
end

local function SetAllNeedCellDestroy(self)
    self.contentNeedN:RemoveComponents(ActivityRewardItem)
    if self.needModels~=nil then
        for k,v in pairs(self.needModels) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.needModels = nil
end

local function SetAllGetCellDestroy(self)
    self.contentGetN:RemoveComponents(ActivityRewardItem)
    if self.getModels~=nil then
        for k,v in pairs(self.getModels) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.getModels = nil
end

local function OnGetBarterSucc(self, id)
    if self.barterInfo and self.barterInfo.id == id then
        local tempType = {}
        for i, v in ipairs(self.getList) do
            if v.rewardType == RewardType.METAL or v.rewardType == RewardType.WATER or v.rewardType == RewardType.ELECTRICITY then
                tempType = {ResourceType.Metal,ResourceType.Electricity,ResourceType.Water}
                break
            end
        end
        EventManager:GetInstance():Broadcast(EventId.RefreshTopResByPickUp,tempType)
        
        local showFly = true
        for i, v in ipairs(self.getList) do
            if v.rewardType == RewardType.HERO then
                showFly = false
                break
            end
        end

        if showFly then
            for i, v in ipairs(self.getList) do
                local rewardType = v.rewardType
                local itemId = v.itemId
                local pic =RewardUtil.GetPic(v.rewardType,itemId)
                local img = v.iconImg-- self.getList[i].iconImg
                if pic~="" then
                    local flyCount = v.count > 10 and 10 or v.count
                    UIUtil.DoFly(tonumber(rewardType),flyCount,pic,img.transform.position,Vector3.New(0,0,0))
                end
            end
        else
            local msg = {}
            msg.reward = {}
            for i, v in ipairs(self.getList) do
                local param = {}
                if v.rewardType == RewardType.HERO then--如果是兑换英雄，则只能兑换英雄
                    param.type = v.rewardType
                    param.value = {}
                    param.value.heroId = v.itemId
                    param.value.rewardAdd = v.count
                    table.insert(msg.reward, param)
                end
            end
            DataCenter.RewardManager:ShowCommonReward(msg)
        end
        --self:RefreshNeed()
        EventManager:GetInstance():Broadcast(EventId.OnClaimRewardEffFinish)
        EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
        
        --if not self:RefreshRemainTimes() then
        --end
    end
end

local function OnClickBarterBtn(self)
    if self.isPreview then
        UIUtil.ShowTipsId(110557)
        return
    end
    if not self.lackItem then
        if self.isDecorationSend then
            local canSend = false
            if string.IsNullOrEmpty(self.gift_require) then
                canSend = true
            else
                local vec = string.split(self.gift_require, "|")
                for k, v in ipairs(vec) do
                    local tmpVec = string.split(v, ";")
                    if tmpVec and #tmpVec == 2 then
                        if toInt(tmpVec[1]) == 1 then
                            local itemId = toInt(tmpVec[2])
                            local itemNum = DataCenter.ItemData:GetItemCount(itemId)
                            if itemNum > 0 then
                                canSend = true
                                break
                            end
                        elseif toInt(tmpVec[1]) == 2 then
                            local decorationId = toInt(tmpVec[2])
                            local decoration = DataCenter.DecorationDataManager:GetSkinDataById(decorationId)
                            if decoration then
                                canSend = true
                                break
                            end
                        end
                    end
                end
            end
            if not canSend then
                UIUtil.ShowTipsId(320778)
                return
            end
            if self.getList and #self.getList > 0 and self.needList and #self.needList > 0 then
                local param = {}
                param.needNum = self.needList[1].cost
                param.needItemId = self.needList[1].itemId
                param.needRewardType = self.needList[1].rewardType

                param.getNum = self.getList[1].cost
                param.getItemId = self.getList[1].itemId
                param.getRewardType = self.getList[1].rewardType
                param.activityId = self.activityInfo.id
                param.id = self.barterInfo.id
                UIManager:GetInstance():OpenWindow(UIWindowNames.DecorationGiftRewardSend, { anim = true }, param)
            end
        else
            if self.callBack then
                self.callBack(self.more_btn_go.transform,self.barterInfo,self.needList,self.index)
            end
            SFSNetwork.SendMessage(MsgDefines.BarterShopExchange,self.barterInfo.activity_id, self.barterInfo.id, 1)
        end
    else
        if self.lackItem.itemId then
            UIUtil.ShowTipsId(120021)
            
            --UIUtil.ShowMessage(Localization:GetString(GameDialogDefine.NO_DIAMOND_GOTO_BUY), 1, GameDialogDefine.GOTO, GameDialogDefine.CANCEL, function()
            --    GoToUtil.GotoPay()
            --end, function() end)
        else
            if self.lackItem.rewardType == RewardType.OIL or self.lackItem.rewardType == RewardType.METAL
                    or self.lackItem.rewardType == RewardType.WATER
                    or self.lackItem.rewardType == RewardType.MONEY or self.lackItem.rewardType == RewardType.ELECTRICITY then
                local tempRes = {}
                local resType = RewardToResType[self.lackItem.rewardType]
                tempRes[resType] = self.lackItem.cost or 0
                local lackTab = {}
                local param = {}
                param.type = ResLackType.Res
                param.id = resType
                param.targetNum = self.lackItem.cost
                table.insert(lackTab,param)
                GoToResLack.GoToItemResLackList(lackTab)
                self.view.ctrl:CloseSelf()
            elseif self.lackItem.rewardType == RewardType.GOLD then
                GoToUtil.GotoPayTips()
                self.view.ctrl:CloseSelf()
                --UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage, { anim = true },
                --        {
                --            welfareTagType = WelfareTagType.PackStore,
                --        })
            end
        end
    end
end


BarterShopItem.OnCreate = OnCreate
BarterShopItem.OnDestroy = OnDestroy
BarterShopItem.ComponentDefine = ComponentDefine
BarterShopItem.ComponentDestroy = ComponentDestroy
BarterShopItem.DataDefine = DataDefine
BarterShopItem.DataDestroy = DataDestroy
BarterShopItem.OnAddListener = OnAddListener
BarterShopItem.OnRemoveListener = OnRemoveListener

BarterShopItem.SetItem = SetItem
BarterShopItem.RefreshRemainTimes = RefreshRemainTimes
BarterShopItem.RefreshBarter = RefreshBarter
BarterShopItem.RefreshNeed = RefreshNeed
BarterShopItem.RefreshGet = RefreshGet
BarterShopItem.SetAllNeedCellDestroy = SetAllNeedCellDestroy
BarterShopItem.SetAllGetCellDestroy = SetAllGetCellDestroy
BarterShopItem.OnClickBarterBtn = OnClickBarterBtn
BarterShopItem.OnGetBarterSucc = OnGetBarterSucc
BarterShopItem.GetItemsList = GetItemsList

return BarterShopItem