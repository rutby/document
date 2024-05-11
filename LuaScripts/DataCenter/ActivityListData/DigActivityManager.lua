---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/10/20 16:09
---DigManager.lua


local DigActivityManager = BaseClass("DigActivityManager");
local DigActivityData = require "DataCenter.ActivityListData.DigActivityData"
local DigActivityTemplate = require "DataCenter.ActivityListData.DigActivityTemplate"
local DigActivityParamTemplate = require "DataCenter.ActivityListData.DigActivityParamTemplate"
local DigRankData = require "DataCenter.ActivityListData.DigActivityRankData"
local ActGolloesCardRankInfo = require "DataCenter.ActivityListData.ActGolloesCardRankInfo"
local Localization = CS.GameEntry.Localization

local function __init(self)
    self.digInfoDic = {}
    self.digTemplateDic = {}
    self.digParamTemplateDic = {}
    self.digRankInfoDic = {}
    self.cacheBuyPickaxeCount = 0
    self.isDigging = false
    
    self:InitTemplate()
    self:AddListener()
end

local function __delete(self)
    self.digTemplateDic = nil
    self.digInfoDic = nil
    self.digParamTemplateDic = nil
    self.digRankInfoDic = nil
    self.cacheBuyPickaxeCount = nil
    self.isDigging = nil
    
    self:RemoveListener()
end

local function AddListener(self)
    --EventManager:GetInstance():AddListener(EventId.OnPassDay, self.TryReqUpdateMineCaveInfo)
end

local function RemoveListener(self)
    --EventManager:GetInstance():RemoveListener(EventId.OnPassDay, self.TryReqUpdateMineCaveInfo)
end

local function UpdateDigInfo(self, msg)    
    if not msg or not msg.activityId then
        return
    end
    self.isDigging = false
    local tempActId = msg.activityId
    if not self.digInfoDic[tempActId] then
        local newDigInfo = DigActivityData.New()
        newDigInfo:ParseData(msg)
        self.digInfoDic[tempActId] = newDigInfo
    else
        self.digInfoDic[tempActId]:ParseData(msg)
    end
    
    EventManager:GetInstance():Broadcast(EventId.OnDigActivityInfoUpdated)
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

local function ResetDigStatus(self)
    self.isDigging = false
end

local function RequestDigInfo(self, activityId)
    SFSNetwork.SendMessage(MsgDefines.GetDigActivityInfo, activityId)
end

local function OnRecvDigInfo(self, msg)
    self:UpdateDigInfo(msg)
end

local function RequestDigOneBlock(self, activityId, digIndex)
    if self.isDigging then
        return
    end
    self.isDigging = true
    SFSNetwork.SendMessage(MsgDefines.DigOneBlock, activityId, digIndex)
end

local function OnRecvDigResult(self, msg)
    self.isDigging = false
    
    if not msg then
        return
    end
    if msg["reward"] then
        for _, v in pairs(msg["reward"]) do
            DataCenter.RewardManager:AddOneReward(v)
        end
    end
    
    if self.digInfoDic[msg.activityId] then
        local digInfo = self.digInfoDic[msg.activityId]
        
        if msg.goodsIndex and msg.goodsIndex == 0 then
            self.cacheFinalRewardMsg = msg
        end
        
        local digResult = digInfo:AddOneDigRecord({digIndex = msg.digIndex, goodsIndex = msg.goodsIndex})
        EventManager:GetInstance():Broadcast(EventId.OnDigOneBlockSucc, digResult)
    end
end

local function ShowGetFinalReward(self)
    DataCenter.RewardManager:ShowCommonReward(self.cacheFinalRewardMsg)
end

local function RequestAutoDig(self, activityId)
    SFSNetwork.SendMessage(MsgDefines.StartAutoDig, activityId)
end

local function OnRecvAutoDigResult(self, msg)
    if not msg then
        return
    end

    if msg["reward"] then
        for _, v in pairs(msg["reward"]) do
            DataCenter.RewardManager:AddOneReward(v)
        end
    end
    
    local digInfo = self.digInfoDic[msg.activityId]
    if not digInfo then
        return
    end

    local resultList = {}
    for i, v in ipairs(msg.digArr) do
        local oneResult = digInfo:AddOneDigRecord(v)
        table.insert(resultList, oneResult)
    end
    
    table.sort(resultList, function(a, b)
        if a.rewardIndex ~= b.rewardIndex then
            return b.rewardIndex == 0
        else
            return false
        end
    end)
    local state = Setting:GetBool(SettingKeys.ActDigJumpAnim..LuaEntry.Player.uid,false)
    if state then
        DataCenter.RewardManager:ShowCommonReward(msg)
    end
    EventManager:GetInstance():Broadcast(EventId.OnGetAutoDigResult, resultList)
end

local function RequestSelectFinalReward(self, activityId, rewardIndex)
    SFSNetwork.SendMessage(MsgDefines.SelectFinalDigReward, activityId, rewardIndex)
end

local function OnRecvSelectFinalRewardSucc(self, msg)
    if not msg then
        return
    end
    if not self.digInfoDic[msg.activityId] then
        return
    end
    self.digInfoDic[msg.activityId]:UpdateSuperReward(msg.bigRewardIndex)

    EventManager:GetInstance():Broadcast(EventId.OnDigActFinalResultUpdated)
end

local function GetDigRankReq(self, activityId)
    SFSNetwork.SendMessage(MsgDefines.GetDigActivityRankInfo, activityId)
end

local function OnRecvDigRankResp(self, msg)
    if not self.digRankInfoDic then
        self.digRankInfoDic = {}
    end
    if msg["activityId"] then
        if not self.digRankInfoDic[msg["activityId"]] then
            self.digRankInfoDic[msg["activityId"]] = DigRankData.New()
        end
        self.digRankInfoDic[msg["activityId"]]:ParseData(msg)
    end
    
    EventManager:GetInstance():Broadcast(EventId.OnDigActivityRankInfoUpdate)
end




local function RequestBuyOneItem(self, activityId, count)
    SFSNetwork.SendMessage(MsgDefines.BuyDigTool, activityId, count)
end

local function OnRecvBuyItemRet(self, msg)
    if not msg then
        return
    end

    if msg["reward"] then
        for _, v in pairs(msg["reward"]) do
            DataCenter.RewardManager:AddOneReward(v)
        end
    end
    if msg.activityId and self.digInfoDic[msg.activityId] then
        self.digInfoDic[msg.activityId].itemBoughtTimes = self.digInfoDic[msg.activityId].itemBoughtTimes + self.cacheBuyPickaxeCount
        self.cacheBuyPickaxeCount = 0
    end
    
    EventManager:GetInstance():Broadcast(EventId.OnbuyPickaxeSucc)
end


local function InitTemplate(self)
    self.digTemplateDic = {}
    LocalController:instance():visitTable(TableName.DigActivityDig,function(id,lineData)
        local item = DigActivityTemplate.New()
        item:InitData(lineData)
        self.digTemplateDic[item.activityId] = item
    end)
    
    self.digParamTemplateDic = {}
    LocalController:instance():visitTable(TableName.DigActivityPara,function(id,lineData)
        local item = DigActivityParamTemplate.New()
        item:InitData(lineData)
        if not self.digParamTemplateDic[item.digId] then
            self.digParamTemplateDic[item.digId] = {}
        end
        table.insert(self.digParamTemplateDic[item.digId], item)
    end)
end


local function GetDigActivityRed(self)
    return 0
end

local function GetDigInfo(self, activityId)
    if not self.digInfoDic then
        return nil
    end
    return self.digInfoDic[activityId]
end

local function GetDigTemplate(self, activityId)
    if not self.digTemplateDic then
        return nil
    end
    return self.digTemplateDic[activityId]
end

local function GetFinalReward(self, activityId, level, rewardIndex)
    local template = self.digTemplateDic[activityId]
    if template then
        return template:GetFinalReward(level, rewardIndex)
    else
        return nil
    end
end

local function GetRewardsList(self, activityId, level)
    local template = self.digTemplateDic[activityId]
    if template then
        local digId = template.id
        local paramTemplateList = self.digParamTemplateDic[digId]
        if paramTemplateList then
            for i, v in ipairs(paramTemplateList) do
                if v.level == level then
                    return v.rewards
                end
            end
        end
    end
    return {}
end

local function GetPreviewRewardsList(self, activityId, level)
    local retList = {}
    local tempList = self:GetRewardsList(activityId, level)
    table.insertto(retList, tempList)
    local digInfo = self.digInfoDic[activityId]
    if digInfo and digInfo.finalRewardIndex > 0 then
        local finalReward = {}
        local reward = self:GetFinalReward(activityId, level, digInfo.finalRewardIndex)
        finalReward.itemId = reward.itemId
        finalReward.count = reward.count
        table.insert(retList, 1, finalReward)
    else
        local finalReward = {}
        finalReward.itemId = ""
        finalReward.count = 0
        table.insert(retList, 1, finalReward)
    end
    return retList
end

local function GetMaxLvCount(self, activityId)
    local template = self.digTemplateDic[activityId]
    if template then
        local digId = template.id
        local paramTemplateList = self.digParamTemplateDic[digId]
        if paramTemplateList then
            return #paramTemplateList
        end
    end
    return 0
end

local function GetDiggedOutReward(self, activityId, level, blockIndex)
    local retInfo = nil
    
    local tempInfo = self.digInfoDic[activityId]
    if tempInfo then
        local record = tempInfo.digRecordDic[blockIndex]
        if record then
            if record.rewardIndex == 0 then
                local finalReward = self:GetFinalReward(activityId, level, tempInfo.finalRewardIndex)
                retInfo = {}
                retInfo.itemId = finalReward.itemId
                retInfo.count = finalReward.count
            else
                local rewardsList = self:GetRewardsList(activityId, level)
                if rewardsList and #rewardsList >= record.rewardIndex then
                    retInfo = rewardsList[record.rewardIndex]
                end
            end
        end
    end
    
    return retInfo
end

local function GetSelectedFinalRewardInfo(self, activityId, level)
    local finalRewardIndex = 0
    local digInfo = self.digInfoDic[activityId]
    if digInfo then
        finalRewardIndex = digInfo.finalRewardIndex
    end
    
    local isSuperLv = self:CheckIfIsSuperLv(activityId, level)
    
    return finalRewardIndex, isSuperLv
end

local function CheckIfIsSuperLv(self, activityId, level)
    local isSuperLv = false
    local digTemplate = self.digTemplateDic[activityId]
    if digTemplate then
        isSuperLv = table.hasvalue(digTemplate.superLevels, level)
    end
    return isSuperLv
end

local function GetFinalRewards(self, activityId)
    local template = self.digTemplateDic[activityId]
    return template.normalRewards, template.superRewards
end

local function GetFinalRewardGotTimes(self, activityId, isSuperLv, rewardIndex)
    local digInfo = self.digInfoDic[activityId]
    local gotDic = nil
    if isSuperLv then
        gotDic = digInfo.superRewardGotTimesDic
    else
        gotDic = digInfo.normalRewardGotTimesDic
    end
    if gotDic[rewardIndex] then
        return gotDic[rewardIndex].gotTimes
    else
        return 0
    end
end

local function GetPickaxId(self, activityId)
    local digTemplate = self:GetDigTemplate(activityId)
    if not digTemplate then
        return nil
    end
    return digTemplate.pickaxId
end

local function GetRankServerGroupStr(self, activityId)
    local digTemplate = self:GetDigTemplate(activityId)
    if digTemplate ~= nil then
        return DataCenter.ActivityController:GetRankServerGroupStr(digTemplate.rank)
    end
    return nil
end

local function GetPickaxCount(self, activityId)
    local pickaxId = self:GetPickaxId(activityId)
    return DataCenter.ItemData:GetItemCount(pickaxId) or 0
end

local function GetPickaxePackageInfo(self, activityId)
    local digTemplate = self:GetDigTemplate(activityId)
    if not digTemplate then
        return nil
    end
    
    local packInfo = GiftPackManager.GetFirstGiftPackByShowType(6, digTemplate.pickaxId)
    return packInfo
end

local function TryBuyPickaxe(self, activityId)
    local digTemplate = DataCenter.DigActivityManager:GetDigTemplate(activityId)
    local digInfo = DataCenter.DigActivityManager:GetDigInfo(activityId)
    if digTemplate.pickaxBuyMax - digInfo.itemBoughtTimes <= 0 then
        UIUtil.ShowTipsId(372451)
        return
    end

    local pickaxId = DataCenter.DigActivityManager:GetPickaxId(activityId)
    if not pickaxId then
        return
    end

    local param = {}
    param.goodsInfo = {}
    param.goodsInfo.rewardType = RewardType.GOODS
    param.goodsInfo.itemId = pickaxId
    param.goodsInfo.count = 1

    local limit = digTemplate.pickaxBuyMax - digInfo.itemBoughtTimes
    param.goodsInfo.limitCount = limit
    param.goodsInfo.eachPrice = digTemplate.pickaxPrice
    param.consumeInfo = {}
    param.consumeInfo.currencyType = RewardType.GOLD
    param.consumeInfo.currencyId = ""
    param.showResBar = true
    param.callback = function(buyCount)
        self.cacheBuyPickaxeCount = buyCount
        self:RequestBuyOneItem(activityId, buyCount)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMultiBuy,NormalBlurPanelAnim, param)
end

local function CheckIfPickaxeEnough(self, activityId, showTip)
    local pickaxeId = self:GetPickaxId(activityId)
    local tempCount = DataCenter.ItemData:GetItemCount(pickaxeId)
    if tempCount <= 0 then
        if showTip then
            UIUtil.ShowMessage(Localization:GetString("372452"),2,nil,nil,function ()
                DataCenter.DigActivityManager:GetMorePickaxe(activityId,1)
                --UIManager:GetInstance():OpenWindow(UIWindowNames.UIGetPickaxe,{anim = true}, activityId)
            end,nil,nil)
        end
        return false
    end
    return true
end

local function GetMorePickaxe(self,activityId,num)
    local pickaxId = DataCenter.DigActivityManager:GetPickaxId(activityId)
    local lackTab = {}
    local param = {}
    param.type = ResLackType.Item
    param.id =  pickaxId
    param.targetNum = num
    table.insert(lackTab,param)
    GoToResLack.GoToItemResLackList(lackTab)
end

local function GetDigRankInfo(self, activityId)
    return self.digRankInfoDic[activityId]
end

local function GetSelfRank(self, activityId)
    local selfRank = ActGolloesCardRankInfo.New()
    local rankInfo = self.digRankInfoDic[activityId]
    if rankInfo then
        selfRank.uid = LuaEntry.Player.uid
        selfRank.score = rankInfo.selfScore
        selfRank.name = LuaEntry.Player.name
        if LuaEntry.Player:IsInAlliance() then
            local allianceBase = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
            selfRank.alliancename = allianceBase.allianceName
            selfRank.abbr = allianceBase.abbr
        else
            selfRank.alliancename = ""
        end
        selfRank.rank = rankInfo.selfRank
        selfRank.pic = LuaEntry.Player.pic
        selfRank.picVer = LuaEntry.Player.picVer
        selfRank.serverId = LuaEntry.Player.serverId
        for m, n in ipairs(rankInfo.rankRewardArr) do
            if n.startN <= rankInfo.selfRank and rankInfo.selfRank <= n.endN then
                selfRank.reward = n.reward
                break
            end
        end
        
    end
    return selfRank
end

local function GetRankList(self, activityId)
    local rankInfo = self.digRankInfoDic[activityId]
    if rankInfo then
        local rankList = rankInfo.rankList
        for i, v in ipairs(rankList) do
            if not v.reward then
                v.reward = {}
                for m, n in ipairs(rankInfo.rankRewardArr) do
                    if n.startN <= v.rank and v.rank <= n.endN then
                        v.reward = n.reward
                        break
                    end
                end
            end
        end
        table.sort(rankList, function(a, b)
            if a.rank ~= b.rank then
                return a.rank < b.rank
            else
                return a.uid < b.uid
            end
        end)
        return rankList
    else
        return {}
    end
end

DigActivityManager.__init = __init
DigActivityManager.__delete = __delete
DigActivityManager.AddListener = AddListener
DigActivityManager.RemoveListener = RemoveListener

DigActivityManager.UpdateDigInfo = UpdateDigInfo
DigActivityManager.RequestDigInfo = RequestDigInfo
DigActivityManager.OnRecvDigInfo = OnRecvDigInfo
DigActivityManager.RequestDigOneBlock = RequestDigOneBlock
DigActivityManager.OnRecvDigResult = OnRecvDigResult
DigActivityManager.RequestAutoDig = RequestAutoDig
DigActivityManager.ShowGetFinalReward = ShowGetFinalReward
DigActivityManager.OnRecvAutoDigResult = OnRecvAutoDigResult
DigActivityManager.RequestSelectFinalReward = RequestSelectFinalReward
DigActivityManager.OnRecvSelectFinalRewardSucc = OnRecvSelectFinalRewardSucc
DigActivityManager.RequestBuyOneItem = RequestBuyOneItem
DigActivityManager.OnRecvBuyItemRet = OnRecvBuyItemRet
DigActivityManager.InitTemplate = InitTemplate
DigActivityManager.GetDigActivityRed = GetDigActivityRed
DigActivityManager.GetDigInfo = GetDigInfo
DigActivityManager.GetFinalReward = GetFinalReward
DigActivityManager.GetDigTemplate = GetDigTemplate
DigActivityManager.GetMaxLvCount = GetMaxLvCount
DigActivityManager.GetRewardsList = GetRewardsList
DigActivityManager.GetPreviewRewardsList = GetPreviewRewardsList
DigActivityManager.GetDiggedOutReward = GetDiggedOutReward
DigActivityManager.GetSelectedFinalRewardInfo = GetSelectedFinalRewardInfo
DigActivityManager.CheckIfIsSuperLv = CheckIfIsSuperLv
DigActivityManager.GetFinalRewards = GetFinalRewards
DigActivityManager.GetFinalRewardGotTimes = GetFinalRewardGotTimes
DigActivityManager.GetPickaxePackageInfo = GetPickaxePackageInfo
DigActivityManager.GetPickaxId = GetPickaxId
DigActivityManager.GetPickaxCount = GetPickaxCount
DigActivityManager.TryBuyPickaxe = TryBuyPickaxe
DigActivityManager.CheckIfPickaxeEnough = CheckIfPickaxeEnough
DigActivityManager.ResetDigStatus = ResetDigStatus
DigActivityManager.GetDigRankReq = GetDigRankReq
DigActivityManager.OnRecvDigRankResp = OnRecvDigRankResp
DigActivityManager.GetDigRankInfo = GetDigRankInfo
DigActivityManager.GetSelfRank = GetSelfRank
DigActivityManager.GetRankList = GetRankList
DigActivityManager.GetRankServerGroupStr = GetRankServerGroupStr
DigActivityManager.GetMorePickaxe = GetMorePickaxe

return DigActivityManager