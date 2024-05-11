local RewardManager = BaseClass("RewardManager")
local Localization = CS.GameEntry.Localization


local function __init(self)
    self.param = {}  --页面打开需要的奖励数据
    self.viewParam = nil
end

local function __delete(self)
    self.param = nil
    self.viewParam = nil
end

--把奖励加到内存中
local function AddOneReward(self,message)

    local type = message["type"]
    if type ~= nil then
        if type == RewardType.EXP then
            if message["total"] ~= nil then
                LuaEntry.Player.exp = message["total"]
            end
        elseif type == RewardType.POWER then
            if message["total"] ~= nil then
                LuaEntry.Player.questPower = message["total"]
            end
        elseif type == RewardType.OIL then
            if message["total"] ~= nil then
                LuaEntry.Resource.oil = message["total"]
                EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
            end
        elseif type == RewardType.METAL then
            if message["total"] ~= nil then
                LuaEntry.Resource.metal = message["total"]
                EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
            end
        elseif type == RewardType.WATER then
            if message["total"] ~= nil then
                LuaEntry.Resource.water = message["total"]
                EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
            end
        elseif type == RewardType.MONEY then
            if message["total"] ~= nil then
                LuaEntry.Resource.money = message["total"]
                EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
            end
        elseif type == RewardType.ELECTRICITY then
            if message["total"] ~= nil then
                LuaEntry.Resource.electricity = message["total"]
                EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
            end
        elseif type == RewardType.PVE_POINT then
            if message["total"] ~= nil then
                LuaEntry.Resource.pvePoint = message["total"]
                EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
            end
        elseif type == RewardType.PEOPLE then
            if message["total"] ~= nil then
                LuaEntry.Resource.people = message["total"]
                EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
            end
        elseif type == RewardType.GOODS then
            if message["value"] ~= nil then
                local value = message['value']

                --获得特定招募券时进行弹窗提示
                --if  value['itemId'] == DataCenter.LotteryDataManager.needTipItemId then
                if DataCenter.LotteryDataManager:IsNeedTipItemId(value['itemId']) then
                    local count = value['count']
                    local add = value['rewardAdd']
                    --策划要求当任务打开的时候加个延迟
                    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIChatNew) then
                        TimerManager:GetInstance():DelayInvoke(function()
                            UIManager:GetInstance():OpenWindow(UIWindowNames.UIRecruitLotteryTip,{ anim = false, playEffect = false}, count, add, value['itemId'])
                        end, 1.8)
                    elseif UIManager:GetInstance():IsWindowOpen(UIWindowNames.UINoticeEquipTips) then
                        TimerManager:GetInstance():DelayInvoke(function()
                            UIManager:GetInstance():OpenWindow(UIWindowNames.UIRecruitLotteryTip,{ anim = false, playEffect = false}, count, add, value['itemId'])
                        end, 3)
                    else
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIRecruitLotteryTip,{ anim = false, playEffect = false}, count, add, value['itemId'])
                    end
                end
                ---- 获得芯片提示
                --if tonumber(value['itemId']) == 200022 then
                --    local delay = (CS.SceneManager.IsInPVE() and 1 or 0.1)
                --    if DataCenter.BuildManager.MainLv >= LuaEntry.DataConfig:TryGetNum("get_item_tips", "k1") and DataCenter.BuildManager.MainLv < BuildLevelCap then
                --        local param = {}
                --        param.total = value['count']
                --        param.add = value['rewardAdd']
                --        param.threshold = DataCenter.BuildManager:GetMainUpgradeNeedItemCount()
                --        param.name = self:GetNameByType(RewardType.GOODS, value['itemId'])
                --        param.icon = self:GetPicByType(RewardType.GOODS, value['itemId'])
                --        TimerManager:GetInstance():DelayInvoke(function()
                --            UIManager:GetInstance():OpenWindow(UIWindowNames.UIRecruitLotteryTip, { anim = false, playEffect = false }, param)
                --        end, delay)
                --    end
                --end

                DataCenter.ItemData:UpdateOneItem(message["value"])
            end
        elseif type == RewardType.ARM then
            local dic = message["value"]
            if dic ~= nil then
                local armyInfo = DataCenter.ArmyManager:FindArmy(dic["itemId"])
                if armyInfo ~= nil then
                    armyInfo.free = armyInfo.free + dic["count"]
                end
            end
        elseif type == RewardType.PTGOLD then
            if message["total"] ~= nil then
                LuaEntry.Player.ptGold = message["total"]
            end
        elseif type == RewardType.ITEM_EFFECT then
            local dic = message["value"]
            if dic ~= nil and dic["status"] ~= nil and dic["effectState"] ~= nil then
                for k,v in pairs(dic["status"]) do
                    local id = v["stateId"]
                    local qtype = GetTableData(TableName.StatusTab,id, "type2")
                    if qtype ~= nil and qtype ~= "" then
                        local eTime,b2 = math.modf((dic["effectState"].id / 1000))
                        local eId = tonumber(id)
                        if eId ~= nil and eId ~= 0 then
                            LuaEntry.Effect:AddStatus(eId, eTime)
                        end
                    end
                end
                EventManager:GetInstance():Broadcast(EventId.MSG_ITME_STATUS_TIME_CHANGE)
            end
        elseif type == RewardType.GOLD then
            if message["total"] ~= nil then
                LuaEntry.Player.gold = message["total"]
                EventManager:GetInstance():Broadcast(EventId.UpdateGold)
            end
        elseif type == RewardType.DETECT_EVENT then
            if message["value"] ~= nil then
                DataCenter.RadarCenterDataManager:UpdateEventNum(message["value"])
            end
        elseif type == RewardType.FORMATION_STAMINA then
            --if message["value"] ~= nil then
                --DataCenter.RadarCenterDataManager:UpdateEventNum(message["value"])
            --end
        elseif type == RewardType.WOOD then
            if message["total"] ~= nil then
                LuaEntry.Resource.wood = message["total"]
                EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
            end
        elseif type == RewardType.PVE_STAMINA then
            if message["total"] ~= nil then
                LuaEntry.Player.pveStamina = message["total"]
                EventManager:GetInstance():Broadcast(EventId.PveStaminaUpdate)
            end
        elseif type == RewardType.FLINT then
            if message["total"] ~= nil then
                LuaEntry.Resource.flint = message["total"]
                EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
            end
        elseif type == RewardType.STEEL then
            if message["total"] ~= nil then
                LuaEntry.Resource.steel = message["total"]
                EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
            end
        end
    end
end

--list中存 rewardType,itemId,count
local function ShowGiftReward(self,message,title,callback)
    local list = {}
    local param = {}
    param.title = title or Localization:GetString("E100076")
    if table.count(message["reward"]) > 0 then
        local origin = message["reward"]
        local newlist = {}
        for i = table.count(origin), 1, -1 do
            newlist[#newlist+1] = origin[i]
        end
        list = self:ReturnRewardParamForMessage(newlist)
    end
    if message["gold"] ~= nil then
        local tempParam = {}
        tempParam.rewardType = RewardType.GOLD
        tempParam.itemId = ""
        tempParam.count = message["goldAdd"] and message["goldAdd"] or tonumber(message["gold"]) - LuaEntry.Player.sm_addGoldCount
        if tempParam.count ~= 0 then
            table.insert(list,tempParam)
        end
    end
    if message["getMoney"] ~= nil then
        local tempParam = {}
        tempParam.rewardType = RewardType.MONEY
        tempParam.itemId = ""
        tempParam.count = tonumber(message["getMoney"])
        if tempParam.count > 0 then
            table.insert(list,tempParam)
        end
    end
    if message["getEnergy"] ~= nil then
        local tempParam = {}
        tempParam.rewardType = RewardType.FORMATION_STAMINA
        tempParam.itemId = ""
        tempParam.count = tonumber(message["getEnergy"])
        if tempParam.count > 0 then
            table.insert(list,tempParam)
        end
    end
    if (message["goods"] ~= nil) then
        local goods = message["goods"]
        local listItem = {}
        for i = 1, #goods do
            if listItem[goods[i].itemId] then
                listItem[goods[i].itemId] = listItem[goods[i].itemId] + goods[i].rewardAdd
            else
                listItem[goods[i].itemId] = goods[i].rewardAdd
            end
        end
        for k, v in pairs(listItem) do
            local tempParam = {}
            tempParam.rewardType = RewardType.GOODS
            tempParam.itemId = k
            tempParam.count = v
            table.insert(list, tempParam)
        end
        param.title = Localization:GetString(GameDialogDefine.CONGRATULATION_REWARD_GET)
    end
    
    
    
    if (message["stone"] ~= nil) then	--水晶
        local tempParam = {}
        tempParam.rewardType = RewardType.METAL
        tempParam.itemId = ""
        tempParam.count = tonumber(message["stoneAdd"])
        if tempParam.count ~= 0 then
            table.insert(list,tempParam)
        end
    end
    --if (message["exp"] ~= nil) then	--经验
    --    local tempParam = {}
    --    tempParam.rewardType = RewardType.EXP
    --    tempParam.itemId = ""
    --    tempParam.count = tonumber(message["exp"])
    --    if tempParam.count ~= 0 then
    --        table.insert(list,tempParam)
    --    end
    --end
    if (message["water"] ~= nil) then	--水
        local tempParam = {}
        tempParam.rewardType = RewardType.WATER
        tempParam.itemId = ""
        tempParam.count = tonumber(message["waterAdd"])
        if tempParam.count ~= 0 then
            table.insert(list,tempParam)
        end
    end
    if (message["money"] ~= nil) then	--钞票
        local tempParam = {}
        tempParam.rewardType = RewardType.MONEY
        tempParam.itemId = ""
        tempParam.count = tonumber(message["moneyAdd"])
        if tempParam.count ~= 0 then
            table.insert(list,tempParam)
        end
    end
    if (message["electricity"] ~= nil) then	--电力
        local tempParam = {}
        tempParam.rewardType = RewardType.ELECTRICITY
        tempParam.itemId = ""
        tempParam.count = tonumber(message["electricityAdd"])
        if tempParam.count ~= 0 then
            table.insert(list,tempParam)
        end
    end
    if (message["pvePoint"] ~= nil) then	--pve点数
        local tempParam = {}
        tempParam.rewardType = RewardType.PVE_POINT
        tempParam.itemId = ""
        tempParam.count = tonumber(message["pvePointAdd"])
        if tempParam.count ~= 0 then
            table.insert(list,tempParam)
        end
    end
    if (message["detectEvent"] ~= nil) then	--雷达事件数
        local tempParam = {}
        tempParam.rewardType = RewardType.DETECT_EVENT
        tempParam.itemId = ""
        tempParam.count = tonumber(message["detectEventAdd"])
        if tempParam.count ~= 0 then
            table.insert(list,tempParam)
        end
    end
    if (message["formationStamina"] ~= nil) then	--体力
        local tempParam = {}
        tempParam.rewardType = RewardType.FORMATION_STAMINA
        tempParam.itemId = ""
        tempParam.count = tonumber(message["formationStaminaAdd"])
        if tempParam.count ~= 0 then
            table.insert(list,tempParam)
        end
    end
    if (message["wood"] ~= nil) then	--木材
        local tempParam = {}
        tempParam.rewardType = RewardType.WOOD
        tempParam.itemId = ""
        tempParam.count = tonumber(message["wood"])
        if tempParam.count ~= 0 then
            table.insert(list,tempParam)
        end
    end
    if (message["coal"] ~= nil) then	--煤? 钢铁!
        local tempParam = {}
        tempParam.rewardType = RewardType.STEEL
        tempParam.itemId = ""
        tempParam.count = tonumber(message["coalAdd"])
        if tempParam.count ~= 0 then
            table.insert(list,tempParam)
        end
    end
    if (message["iron"] ~= nil) then	--铁? 木头!
        local tempParam = {}
        tempParam.rewardType = RewardType.PLANK
        tempParam.itemId = ""
        tempParam.count = tonumber(message["ironAdd"])
        if tempParam.count ~= 0 then
            table.insert(list,tempParam)
        end
    end
    if (message["pve_stamina"] ~= nil) then
        local tempParam = {}
        tempParam.rewardType = RewardType.PVE_STAMINA
        tempParam.itemId = ""
        tempParam.count = tonumber(message["pve_stamina"])
        if tempParam.count ~= 0 then
            table.insert(list,tempParam)
        end
    end
    if (message["people"] ~= nil) then	--人口
        local tempParam = {}
        tempParam.rewardType = RewardType.PEOPLE
        tempParam.itemId = ""
        tempParam.count = tonumber(message["people"])
        if tempParam.count ~= 0 then
            table.insert(list,tempParam)
        end
    end
    
    if(message["hero"]~=nil) then
        local heroArr = message["hero"]
        for i = 1, #heroArr do
            local msg = heroArr[i]
            local tempParam = {}
            tempParam.rewardType =  RewardType.HERO
            tempParam.sortOrder = 0
            tempParam.itemId = msg["heroId"]
            tempParam.count = tonumber(msg["rewardAdd"])
            tempParam.heroUuid = msg["uuid"]
            if tempParam.count ~= 0 then
                table.insert(list,tempParam)
            end
        end
    end
    
    list = table.reverse(list)
    --奖励中若有英雄，优先展示
    local heroList = {}
    for i = #list, 1,-1 do
        if list[i].rewardType == RewardType.HERO then
            table.insert(heroList,list[i])
            table.remove(list,i)
        end
    end
    for i = 1, #heroList do
        table.insert(list,1,heroList[i])
    end
    if not next(list) then
        return
    end
    param.rewardList = list
    self:SetParam(param)
    --DataCenter.UIPopWindowManager:Push(UIWindowNames.UIGiftPackageRewardGet,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},callback)
    if DataCenter.GuideManager:IsCanShowReward() then
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Ue_GetPayReward)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},callback)
    else
        DataCenter.GuideManager:SetGuideEndCallBack(function()
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Ue_GetPayReward)
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},callback)
        end)
    end
end

local function ShowCommonReward(self,message, title,isChange,heroExp,isArmyFly,isActGiftBox, strTip, titleType,callback,needSetParam)
    if needSetParam ~= nil and needSetParam == false then
        if DataCenter.GuideManager:IsCanShowReward() then
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Ue_GetReward)
            if heroExp~=nil then
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIGetRewardView,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},callback)
            else
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},callback)
            end

        else
            DataCenter.GuideManager:SetGuideEndCallBack(function()
                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Ue_GetReward)
                if heroExp~=nil then
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGetRewardView,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},callback)
                else
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},callback)
                end
            end)
        end
        return
    end
    
    if message["reward"] ~= nil or heroExp ~= nil then
        local list = {}
        list = self:ReturnRewardParamForMessage(message["reward"]) or {}
        
        if isActGiftBox then
            local actGiftBox = self:GetActGiftBox(message)
            for i, v in ipairs(actGiftBox) do
                table.insert(list, v)
            end 
        end
        
        if table.IsNullOrEmpty(list) then
            if callback then
                callback()
            end
            return
        end
        
        --这里特殊处理,有密码不显示板子
        for k, v in ipairs(list) do
            if v.rewardType == RewardType.GOODS then
                local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
                if itemTemplate.type == GOODS_TYPE.Password then
                    --直接不弹
                    return
                end
            end
        end

        table.sort(list,function(a, b )
            if a.rewardType ~= b.rewardType then
                return (a.rewardType == RewardType.HERO and true or false)
            else
                return a.sortOrder < b.sortOrder
            end
        end)
        
        local golloesList = self:GetGolloesRewards(message)
        for i, v in ipairs(golloesList) do
            table.insert(list, v)
        end
        
        local param = {}
        param.rewardList = list
        param.heroExp = heroExp
        param.title = title or Localization:GetString(GameDialogDefine.CONGRATULATION_REWARD_GET)
        param.tip = strTip
        param.titleType = titleType
        if isChange then
            if message["buildInfo"] ~= nil then
                local dic = message["buildInfo"]
                if dic.bId == BuildingTypes.FUN_BUILD_HERO_MONUMENT or dic.bId == BuildingTypes.FUN_BUILD_BARRACKS then
                    --此类奖励只有1个
                    param.isUpChange = list[1].rewardType
                end
            end
        end
        param.isArmyFly = isArmyFly
        self:SetParam(param)
        --DataCenter.UIPopWindowManager:Push(UIWindowNames.UIGiftPackageRewardGet,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide})
        if DataCenter.GuideManager:IsCanShowReward() then
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Ue_GetReward)
            if heroExp~=nil then
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIGetRewardView,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},callback)
            else
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},callback)
            end
            
        else
            DataCenter.GuideManager:SetGuideEndCallBack(function()
                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Ue_GetReward)
                if heroExp~=nil then
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGetRewardView,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},callback)
                else
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},callback)
                end
            end)
        end
    end
end

local function ShowCommonRewards(self, message)
    if message["reward"] ~= nil and #message["reward"] > 0 then
        for m,n in ipairs(message["reward"]) do
            local list = {}
            list = self:ReturnRewardParamForMessage(n) or {}

            --这里特殊处理,有密码不显示板子
            for k, v in ipairs(list) do
                if v.rewardType == RewardType.GOODS then
                    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
                    if itemTemplate.type == GOODS_TYPE.Password then
                        --直接不弹
                        return
                    end
                end
            end

            table.sort(list,function(a, b )
                if a.rewardType ~= b.rewardType then
                    return (a.rewardType == RewardType.HERO and true or false)
                else
                    return a.sortOrder < b.sortOrder
                end
            end)

            local param = {}
            param.rewardList = list
            param.title = Localization:GetString(GameDialogDefine.CONGRATULATION_REWARD_GET)
            self:SetParam(param)
        end
        
        if DataCenter.GuideManager:IsCanShowReward() then
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Ue_GetReward)
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide})
        else
            DataCenter.GuideManager:SetGuideEndCallBack(function()
                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Ue_GetReward)
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide})
            end)
        end
    end
end

local function ShowMineCaveRewards(self, message, title, tip, titleType)
    self:ShowCommonReward(message, title, nil, nil, nil, nil, tip, titleType)
end

local function ShowCommonHeroReward(self,message)
    local list = {}
    list.rewardType =  RewardType.HERO
    list.sortOrder = 0
    list.itemId = message["heroId"]
    list.count = message["heroCount"]
    list.heroUuid = message["uuid"]
    list.isHeroBox = true
    local param = {}
    param.rewardList = {}
    table.insert(param.rewardList,list)
    param.title = Localization:GetString(GameDialogDefine.CONGRATULATION_REWARD_GET)
    self:SetParam(param)
    if DataCenter.GuideManager:IsCanShowReward() then
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Ue_GetReward)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide})
    else
        DataCenter.GuideManager:SetGuideEndCallBack(function()
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Ue_GetReward)
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide})
        end)
    end
    --DataCenter.UIPopWindowManager:Push(UIWindowNames.UIGiftPackageRewardGet,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide})
end

--用于消息返回数据处理
local function ReturnRewardParamForMessage(self,list)
    local params = {}
    local Player = LuaEntry.Player
    local sortOrder = 0
    if list == nil then
        return nil
    end
    for k,v in pairs(list) do
        local type = v["type"]
        if type == RewardType.ITEM_EFFECT then
            type = RewardType.GOODS
        end
        local param = {}
        param.rewardType = type
        param.sortOrder = sortOrder
        sortOrder = sortOrder + 1
        if type == RewardType.GOODS or type == RewardType.ITEM_EFFECT then
            local dic = v["value"]
            if dic ~= nil then
                if dic["id"] ~= nil then
                    param.itemId = dic["id"]
                elseif dic["itemId"] ~= nil then
                    param.itemId = dic["itemId"]
                elseif dic["goodsId"] ~= nil then
                    param.itemId = dic["goodsId"]
                end
                local good = DataCenter.ItemData:GetItemById(param.itemId)
                local num = 0
                if good ~= nil then
                    num = good.count
                end

                local sm_addNum = 0
                if dic["rewardAdd"] then
                    sm_addNum = dic["rewardAdd"]
                elseif dic["count"] ~= nil then
                    sm_addNum = dic["count"] - num
                elseif dic["num"] ~= nil then
                    sm_addNum = dic["num"]
                end
                if sm_addNum <= 0 and good ~= nil then
                    sm_addNum = good.sm_addCount
                end
                param.count = sm_addNum
            end
        elseif type == RewardType.GOLD then
            if v["value"] then
                param.count = v["value"]
            end
            param.itemId = ""
        elseif type == RewardType.EXP then
            local sm_addNum = v["value"]
            if sm_addNum <= 0 and v["total"] ~= nil then
                sm_addNum = v["total"] - Player.exp
            end
            param.count = sm_addNum
        elseif type == RewardType.POWER then
            local sm_addNum = v["value"]
            if sm_addNum <= 0 and v["total"] ~= nil then
                sm_addNum = v["total"] - Player.questPower
            end
            param.count = sm_addNum
        elseif type == RewardType.OIL or type == RewardType.WATER
                or type == RewardType.MONEY or type == RewardType.METAL
                or type == RewardType.ELECTRICITY or type == RewardType.PVE_POINT 
                or type == RewardType.DETECT_EVENT or type == RewardType.FORMATION_STAMINA
                or type == RewardType.WOOD or type == RewardType.PVE_STAMINA or type == RewardType.PEOPLE then
            param.count = v["value"]
        elseif type == RewardType.ARM then
            local dic = v["value"]
            if dic ~= nil then
                param.itemId = dic["itemId"] or dic["id"]
                param.count = dic["count"] or dic["num"]
            end
        elseif type == RewardType.EQUIP then
            local dic = v["value"]
            if dic ~= nil then
                if dic["equipId"] ~= nil then
                    param.itemId = dic["equipId"]
                elseif dic["id"] ~= nil then
                    param.itemId = dic["id"]
                end
                param.count = dic["num"]
            end
        elseif type == RewardType.PTGOLD then
            local sm_addNum = v["value"]
            if sm_addNum <= 0 and v["total"] ~= nil then
                sm_addNum = v["total"] - Player.ptGold
            end
            param.count = sm_addNum
        elseif type == RewardType.HERO then
            local dic = v["value"]
            if dic ~= nil then
                param.itemId = dic["heroId"] or dic["id"]
                param.count = dic["rewardAdd"] or dic["num"]
                param.heroUuid = dic["uuid"] or dic["heroUuid"]
            end
        elseif type == RewardType.HONOR or type == RewardType.ALLIANCE_POINT then
            param.count = v["value"]
        elseif type == RewardType.CAR_EQUIP then
            local dic = v["value"]
            if dic ~= nil then
                param.itemId = dic["id"]
                param.count = dic["rewardAdd"]
            end
        elseif type == RewardType.RESIDENT then
            local dic = v["value"]
            if dic then
                param.itemId = dic["id"]
            end
        elseif type == RewardType.HERO_EQUIP then
            local dic = v["value"]
            if dic ~= nil then
                if dic["id"] ~= nil then
                    param.itemId = dic["id"]
                end
                param.count = dic["rewardAdd"]
            end
        else
            local dic = v["value"]
            if dic ~= nil then
                param.count = dic
            end
        end
        if param.count ~= 0 then
            table.insert(params,param)
        end
        --end
    end
    if #params > 0 then
        return params
    end
    return nil
end

local function GetGolloesRewards(self, message)
    local retList = {}
    if message.freeSpeedNumAdd and message.freeSpeedNumAdd > 0 then
        local oneData = {}
        oneData.sortOrder = 0
        oneData.rewardType = RewardType.Golloes
        oneData.itemId = GolloesType.Worker
        oneData.count = message.freeSpeedNumAdd
        table.insert(retList, oneData)
    end
    if message.spyNumAdd and message.spyNumAdd > 0 then
        local oneData = {}
        oneData.sortOrder = 0
        oneData.rewardType = RewardType.Golloes
        oneData.itemId = GolloesType.Explorer
        oneData.count = message.spyNumAdd
        table.insert(retList, oneData)
    end
    if message.caravanNumAdd and message.caravanNumAdd > 0 then
        local oneData = {}
        oneData.sortOrder = 0
        oneData.rewardType = RewardType.Golloes
        oneData.itemId = GolloesType.Trader
        oneData.count = message.caravanNumAdd
        table.insert(retList, oneData)
    end
    if message.statusNumAdd and message.statusNumAdd > 0 then
        local oneData = {}
        oneData.sortOrder = 0
        oneData.rewardType = RewardType.Golloes
        oneData.itemId = GolloesType.Warrior
        oneData.count = message.statusNumAdd
        table.insert(retList, oneData)
    end

    return retList
end

local function GetActGiftBox(self,message)
    local retList = {}
    if message["lotteryItems"] then
        for i = 1 ,table.count(message["lotteryItems"]) do
            local oneData = {}
            local template =  DataCenter.ActGiftBoxData:GetActBoxInfoByItemId(message["lotteryItems"][i])
            if template.reward_icon == "" then
                oneData.sortOrder = 1
                oneData.rewardType = RewardType.GOODS
                local str = string.split(template.goods,";")
                oneData.itemId = str[1]
                oneData.count = str[2]
            else
                oneData.sortOrder = 0
                oneData.rewardType = RewardType.ActGiftBox
                oneData.count = 1
                oneData.itemId = message["lotteryItems"][i]
            end
       
            table.insert(retList, oneData)
        end
        table.sort(retList,function(a, b)
            if a.sortOrder < b.sortOrder then
                return true
            end
            return false
        end)
    end
    return retList
end

--用于页面展示数据处理
local function ReturnRewardParamForView(self,list)
    local params = {}
    for k,v in pairs(list) do
        local type = v["type"]
        if type ~= RewardType.ITEM_EFFECT then
            local param = {}
            param.rewardType = type
            if type == RewardType.GOODS then
                local dic = v["value"]
                if dic ~= nil then
                    if dic["id"] ~= nil then
                        param.itemId = dic["id"]
                    elseif dic["itemId"] ~= nil then
                        param.itemId = dic["itemId"]
                    end
                    local sm_addNum = 0
                    if dic["num"] ~= nil then
                        sm_addNum = dic["num"]
                    elseif dic["rewardAdd"] ~= nil then
                        sm_addNum = dic["rewardAdd"]
                    end
                    param.count = sm_addNum
                end
            elseif type == ResourceType.Gold then
                param.itemId = ""
                param.count = LuaEntry.Player.sm_addGoldCount
            elseif type == RewardType.EXP then
                local sm_addNum = v["value"]
                param.count = sm_addNum
            elseif type == RewardType.POWER then
                local sm_addNum = v["value"]
                param.count = sm_addNum
            elseif type == RewardType.OIL or type == RewardType.WATER
                    or type == RewardType.MONEY or type == RewardType.METAL
                    or type == RewardType.ELECTRICITY or type == RewardType.PVE_POINT 
                    or type == RewardType.DETECT_EVENT or type == RewardType.FORMATION_STAMINA
                    or type == RewardType.WOOD or type == RewardType.PVE_STAMINA or type == RewardType.PEOPLE  then
                param.count = v["value"]
            elseif type == RewardType.ARM then
                local dic = v["value"]
                if dic ~= nil then
                    param.itemId = dic["itemId"] or dic["id"]
                    param.count = dic["count"] or dic["num"]
                end
            elseif type == RewardType.EQUIP then
                local dic = v["value"]
                if dic ~= nil then
                    if dic["equipId"] ~= nil then
                        param.itemId = dic["equipId"]
                    elseif dic["id"] ~= nil then
                        param.itemId = dic["id"]
                    end
                    param.count = dic["num"]
                end
            elseif type == RewardType.PTGOLD then
                local sm_addNum = v["value"]
                param.count = sm_addNum
            elseif type == RewardType.HERO then
                local dic = v["value"]
                if dic ~= nil then
                    param.itemId = dic["id"] or dic["heroId"]
                    param.count = dic["num"] or dic["rewardAdd"]
                end
            elseif type == RewardType.HONOR or type == RewardType.ALLIANCE_POINT then
                param.count = v["value"]
            elseif type == RewardType.RESIDENT then
                local dic = v["value"]
                if dic then
                    param.itemId = dic["id"]
                end
            else
                local dic = v["value"]
                if dic ~= nil then
                    param.count = dic
                end
            end
            table.insert(params,param)
        end
    end
    if #params > 0 then
        return params
    end
    return nil
end

local function GetPicByType(self,rewardType,id)
    if RewardToResType[rewardType] ~= nil then
        return DataCenter.ResourceManager:GetResourceIconByType(RewardToResType[rewardType])
    elseif rewardType == RewardType.POWER then
        return "icon_combat"
    elseif rewardType == RewardType.EXP then
        return "Assets/Main/Sprites/ResLackIcons/defeat_icon_exp.png"
    elseif rewardType == RewardType.HERO_EXP then
        return "Assets/Main/Sprites/ItemIcons/item230001.png"
    elseif rewardType == RewardType.CAR_EQUIP then
        return EquipmentUtil.GetEquipmentIcon(id)
    elseif rewardType == RewardType.GOODS then
        --return CS.CommonUtils.GetIcon(id)
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(id)
        if goods ~= nil then
            return string.format(LoadPath.ItemPath, goods.icon)
        end
    elseif rewardType == RewardType.HONOR then
        return "u_alliance_contributeicon02"
    elseif rewardType == RewardType.ALLIANCE_POINT then
        return "u_alliance_contributeicon01"
    elseif rewardType == RewardType.BATTLE_HONOR then
        return "Commond7_icon_3"
    elseif rewardType == RewardType.ARM then
        local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(id)
        if army ~= nil then
            return string.format(LoadPath.SoldierIcons,army.icon)
        end
    elseif rewardType == RewardType.PTGOLD then
        return "FB_IC_jinbixiao"
    elseif rewardType == RewardType.PVE_ACT_SCORE then
        return "Assets/Main/Sprites/UI/Common/Common_icon_act_point.png"
    elseif rewardType == RewardType.HERO then
        local xmlData = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), id)
        if xmlData ~= nil then
            return string.format("Assets/Main/Sprites/HeroIconsBig/%s",xmlData.hero_icon)
        end
    elseif rewardType == RewardType.HeroPlugin then
        return DataCenter.HeroPluginManager:GetCampIconName(id)
    elseif rewardType == RewardType.PVE_STAMINA or rewardType == RewardType.FORMATION_STAMINA then
        return string.format(LoadPath.CommonPath, "Common_icon_stamina")
    elseif rewardType == RewardType.DECORATION then
        local template = DataCenter.DecorationTemplateManager:GetTemplate(id)
        if template then
            return template.icon
        end
    elseif rewardType == RewardType.RESIDENT then
        local icon = GetTableData(TableName.VitaResident, id, "icon")
        return string.format(LoadPath.Resident, icon)
    end
    return ""
end

local function GetNameByType(self,rewardType,id)
    if RewardToResType[rewardType] ~= nil then
        return DataCenter.ResourceManager:GetResourceNameByType(RewardToResType[rewardType])
    elseif rewardType == RewardType.POWER then
        return Localization:GetString("100181")
    elseif rewardType == RewardType.EXP then
        return Localization:GetString("100001")
    elseif rewardType == RewardType.HERO_EXP then
        return Localization:GetString("100180")
    elseif rewardType == RewardType.MASTERY_POINT then
        return Localization:GetString("111031")
    elseif rewardType == RewardType.CAR_EQUIP then
        local template = DataCenter.EquipmentTemplateManager:GetTemplate(id)
        return template and Localization:GetString(template.name) or ""
    elseif rewardType == RewardType.GOODS then
        return DataCenter.ItemTemplateManager:GetName(id)
    elseif rewardType == RewardType.HONOR then
        return Localization:GetString("390261")
    elseif rewardType == RewardType.ALLIANCE_POINT then
        return Localization:GetString("390266")
    elseif rewardType == RewardType.BATTLE_HONOR then
        return Localization:GetString("360180")
    elseif rewardType == RewardType.PTGOLD then
        return ""
    elseif rewardType == RewardType.PVE_ACT_SCORE then
        return Localization:GetString("180003")
    elseif rewardType == RewardType.SAPPHIRE then
        return Localization:GetString("390967")
    elseif rewardType == RewardType.ARM then
        local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(id)
        if army ~= nil then
            return Localization:GetString(army.name)
        end
    elseif rewardType == RewardType.HeroPlugin then
        return Localization:GetString(GameDialogDefine.HERO_PLUGIN_TITLE)
    elseif rewardType == RewardType.PVE_STAMINA then
        return Localization:GetString("100510")
    elseif rewardType == RewardType.DECORATION then
        local template = DataCenter.DecorationTemplateManager:GetTemplate(id)
        if template then
            return Localization:GetString(template.name)
        end
    elseif rewardType == RewardType.RESIDENT then
        local name = GetTableData(TableName.VitaResident, id, "name")
        return Localization:GetString(name)
    end
    return ""
end

local function GetDescByType(self, rewardType, id)
    if rewardType == RewardType.GOODS then
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(id)
        if goods ~= nil then
            if goods.type == GOODS_TYPE.GOODS_TYPE_99 then
                local num = goods.para1
                local heroId = goods.para2
                local heroName = GetTableData(HeroUtils.GetHeroXmlName(), heroId,"name")
                return Localization:GetString(goods.description, num, Localization:GetString(heroName))
            end
            return Localization:GetString(goods.description)
        end
    elseif RewardToResType[rewardType] ~= nil then
        local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(RewardToResType[rewardType])
        if template then
            return Localization:GetString(template.description)
        end
    elseif rewardType == RewardType.EXP then
        return Localization:GetString("100523")
    elseif rewardType == RewardType.HERO_EXP then
        return Localization:GetString("100180")
    elseif rewardType == RewardType.MASTERY_POINT then
        return Localization:GetString("111031")
    elseif rewardType == RewardType.CAR_EQUIP then
        local template = DataCenter.EquipmentTemplateManager:GetTemplate(id)
        return template and Localization:GetString(template.description) or ""
    elseif rewardType == RewardType.HeroPlugin then
        return Localization:GetString(GameDialogDefine.HERO_PLUGIN_LOCK_DES)
    elseif rewardType == RewardType.PVE_STAMINA then
        return Localization:GetString("100510")
    elseif rewardType == RewardType.DECORATION then
        local template = DataCenter.DecorationTemplateManager:GetTemplate(id)
        if template then
            return Localization:GetString(template.goods_desc)
        end
    end
    return ""
end

function RewardManager:GetIconColorByRewardType(rewardType, id)
    if rewardType == RewardType.GOODS then
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(id)
        if goods ~= nil then
            return DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
        end
    elseif rewardType == RewardType.GOLD then
        return DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE)
    elseif RewardToResType[rewardType] ~= nil then
        return DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE)
    elseif rewardType == RewardType.EXP then
        return DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.GREEN)
    elseif rewardType == RewardType.HeroPlugin then
        return string.format(LoadPath.HeroAdvancePath, "UI_cj_yuanboard")
    elseif rewardType == RewardType.DECORATION then
        local template = DataCenter.DecorationTemplateManager:GetTemplate(id)
        if template then
            return DataCenter.ItemTemplateManager:GetToolBgByColor(template.quality)
        end
    elseif rewardType == RewardType.RESIDENT then
        return DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.WHITE)
    end
    
    return DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.WHITE)
end


local function GetMailReward(self,list)
    local params = {}
    for k,v in pairs(list) do
        local param = {}
        if v["t"] ~= nil then
            param.itemId = v["t"]
            if v["v"] ~= nil then
                param.count = v["v"]

            end
            table.insert(params,param)
        end
    end
    return params
end

local function SetMailFightReward(self,list)
    if list ~= nil then
        table.walk(list,function (k,v)
            self:AddOneReward(v)
            --DataCenter.ItemData:UpdateOneItem(v)
        end)
    end
end

--展示日常任务奖励
local function ShowDailyTaskReward(self,message)
    local list = {}

    if message["rewardList"] ~= nil then
        list = self:ReturnRewardParamForMessage(message["rewardList"])
    end

    local param = {}
    param.rewardList = list
    param.title = Localization:GetString("130067")

    self:SetParam(param)
    --DataCenter.UIPopWindowManager:Push(UIWindowNames.UIGiftPackageRewardGet,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide})
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide})
end

--显示Talent选择结果
local function ShowTalentChoose(self, talentId)
    local param = {}
    param.title = Localization:GetString("130067")
    local list = {}
    local tempParam = {}
    tempParam.rewardType = RewardType.TALENT
    tempParam.itemId = talentId
    if tempParam.count ~= 0 then
        table.insert(list,tempParam)
    end
    param.rewardList = list
    self:SetParam(param)

    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide})
end


local function GetParam(self)
    if self.param and #self.param > 0 then
        return self.param[1]
    else
        return nil
    end
end

local function SetParam(self,param)
    table.insert(self.param, param)
end

local function ClearParam(self)
    table.remove(self.param, 1)
end

--通用奖励弹窗关闭后再次弹出的窗口
local function SetCloseViewName(self,name,param)
    self.viewParam = {name = name,extra = param}
end

local function ClearViewParam(self)
    self.viewParam = nil
end

local function GetViewParam(self)
    return self.viewParam
end

local function GetRewardNames(self, reward)
    local nameList = {}
    for _, v in ipairs(reward) do
        local rewardType = v.type or v.rewardType
        local itemId = v.value.itemId or v.value.id
        local name = self:GetNameByType(rewardType, itemId)
        table.insert(nameList, name)
    end
    return nameList
end

--isCount  是否处理带数量   index  是否只取某个组
local function StrRewardHandle(self,str,isCount,index)
    if str == "" then
        return nil
    end
    local list = {}
    local rewardList = string.split(str,"|")
    if isCount then
        for i = 1 ,#rewardList do
            local reward = string.split(rewardList[i],";")
            local param = {}
            param.itemId = tonumber(reward[1])
            param.count  = tonumber(reward[2])
            table.insert(list,param)
        end
    else
        for i = 1 ,#rewardList do
            local reward = string.split(rewardList[i],";")
            if index then
                if index == i then
                    for k = 1 ,#reward do
                        local param = {}
                        param.itemId = tonumber(reward[k])
                        param.count  = 1
                        table.insert(list,param)
                    end
                    break
                end
            else
                for k = 1 ,#reward do
                    local param = {}
                    param.itemId = tonumber(reward[k])
                    param.count  = 1
                    table.insert(list,param)
                end
            end
        end
    end
    
    return list
end

--处理奖励字符串三字符
local function StrRewardToNumHandle(self,str,index)
    if str == "" then
        return nil
    end
    local list = {}
    local rewardList = string.split(str,"|")
    for i = 1 ,#rewardList do
        local reward = string.split(rewardList[i],";")
        if index then
            if index == i then
                for k = 1 ,#reward do
                    local str1 = string.split(reward[k],",")
                    local param = {}
                    param.itemId = tonumber(str1[1])
                    param.count  = tonumber(str1[2])
                    table.insert(list,param)
                end
                break
            end
        end
    end
    return list
end

local function GetRewardNumsInPveScene(self, num, notShowNum, rewardType)
    local tmp = {}

    local GetOnePicEqualsNum = function(rewardType, num)
        if rewardType == RewardType.GOODS or rewardType == RewardType.PVE_ACT_SCORE then
            if num <= 20 then
                return 1
            elseif num <= 40 then
                return 2
            else
                return 5
            end
        end
        if rewardType == RewardType.WATER then
            return 10
        end
        if rewardType == RewardType.METAL or rewardType == RewardType.WOOD or rewardType == RewardType.MONEY 
                or rewardType == RewardType.ELECTRICITY  or rewardType == RewardType.PEOPLE then
            if num <= 2000 then
                return 100
            elseif num <= 5000 then
                return 200
            else
                return 500
            end
        end
        --避免其他的数量太多，限制一下
        if num >= 200 then
            return num // 20
        end
        return 5
    end
    
    if not notShowNum then
        local onePicEqualsNum = GetOnePicEqualsNum(rewardType, num)
        onePicEqualsNum = math.max(onePicEqualsNum, 1)
        local maxNum = math.ceil(num / onePicEqualsNum)
        local count = num
        local index = 1
        local total = math.min(count, maxNum)
        local currentNum = 0
        while index <= total do
            if currentNum >= count then
                break
            end
            if index == total then
                if notShowNum then
                    table.insert(tmp, -1)
                else
                    table.insert(tmp, count - currentNum)
                end
            else
                if notShowNum then
                    table.insert(tmp, -1)
                else
                    table.insert(tmp, onePicEqualsNum)
                end
                currentNum = currentNum + onePicEqualsNum
            end
            index = index + 1
        end
    else
        local bigNum = math.floor(num / 5)
        local smallNum = math.floor(num / 5) + num - (math.floor(num / 5) * 4 + math.floor(num / 5))
        local index = 1
        while index <= bigNum do
            table.insert(tmp, -1)
            index = index + 1
        end
        index = 1
        while index <= smallNum do
            local insertIndex = Mathf.Round(math.random() * (bigNum + index - 1)) 
            insertIndex = math.max(1, math.min(bigNum + index - 1, insertIndex))
            table.insert(tmp, insertIndex, -2)
            index = index + 1
        end
    end
    return tmp
end

local function ParsePackReward(self, pack)
    local rewardList = {}
    
    -- 英雄
    local heroStr = pack:getHeroesStr()
    if not string.IsNullOrEmpty(heroStr) then
        local spls = string.split(heroStr, ";")
        if #spls == 2 then
            local reward =
            {
                rewardType = RewardType.HERO,
                itemId = tonumber(spls[1]),
                count = tonumber(spls[2]),
            }
            table.insert(rewardList, reward)
        end
    end

    -- 立即使用道具
    local itemUseStrs = string.split(pack:getItemUse(), "|")
    for _, itemUseStr in ipairs(itemUseStrs) do
        local spls = string.split(itemUseStr, ";")
        if #spls == 2 then
            local reward =
            {
                rewardType = RewardType.GOODS,
                itemId = tonumber(spls[1]),
                count = tonumber(spls[2]),
            }
            table.insert(rewardList, reward)
        end
    end

    -- 资源
    local resStrs = string.split(pack:getResourceStr(), "|")
    for _, resStr in ipairs(resStrs) do
        local spls = string.split(resStr, ";")
        if #spls == 2 then
            local reward =
            {
                rewardType = ResTypeToReward[tonumber(spls[1])],
                count = tonumber(spls[2]),
            }
            table.insert(rewardList, reward)
        end
    end

    -- 普通道具
    local itemStrs = string.split(pack:getItemsStr(), "|")
    for _, itemStr in ipairs(itemStrs) do
        local spls = string.split(itemStr, ";")
        if #spls == 2 then
            local reward =
            {
                rewardType = RewardType.GOODS,
                itemId = tonumber(spls[1]),
                count = tonumber(spls[2]),
            }
            table.insert(rewardList, reward)
        end
    end

    -- 联盟道具
    local alStrs = pack:getAllianceGift()
    if alStrs ~= nil then
        if type(alStrs) == "table" and not table.IsNullOrEmpty(alStrs) then
            for _, alStr in ipairs(alStrs) do
                if not string.IsNullOrEmpty(alStr) then
                    local spls = string.split(alStr, ";")
                    if #spls == 5 then
                        local reward =
                        {
                            rewardType = RewardType.GOODS,
                            iconName = string.format(LoadPath.UIAllianceGift, spls[1]),
                            itemName = spls[2],
                            itemDesc = spls[3],
                            count = spls[4],
                            itemColor = spls[5],
                        }
                        table.insert(rewardList, reward)
                    end
                end
            end
        elseif type(alStrs) == "string" and not string.IsNullOrEmpty(alStrs) then
            for _, alStr in ipairs(string.split(alStrs, "|")) do
                if not string.IsNullOrEmpty(alStr) then
                    local spls = string.split(alStr, ";")
                    if #spls == 5 then
                        local reward =
                        {
                            rewardType = RewardType.GOODS,
                            iconName = string.format(LoadPath.UIAllianceGift, spls[1]),
                            itemName = spls[2],
                            itemDesc = spls[3],
                            count = spls[4],
                            itemColor = spls[5],
                        }
                        table.insert(rewardList, reward)
                    end
                end
            end
        end
    end

    return rewardList
end

local function DealWithHeroOrPoster(self, t)
    local rewardList = {}
    if t["hero"] then
        local reward =
        {
            rewardType = RewardType.HERO,
            itemId = t["heroId"],
        }
        table.insert(rewardList, reward)
    end
    --if t["poster"] then
    --    local reward =
    --    {
    --        type = RewardType.GOODS,
    --        value = {id = t["poster"]["goodsId"], rewardAdd = t["poster"]["num"]},
    --    }
    --    table.insert(rewardList, reward)
    --end
    if #rewardList > 0 then
        DataCenter.RewardManager:ShowCommonReward({ reward = rewardList })
    end
end

--很多页面需要显示图标，把方法提出来全调用这个
function RewardManager:GetShowRewardList(rewardList)
    local reward = {}
    if rewardList == nil then
        return reward
    end
    for k,v in pairs(rewardList) do
        local item = {}
        item.count = v.count
        item.rewardType = v.rewardType
        item.itemName = self:GetNameByType(v.rewardType, v.itemId)
        item.iconName = self:GetPicByType(v.rewardType, v.itemId)
        item.itemDesc = self:GetDescByType(v.rewardType, v.itemId)
        item.itemColor = self:GetIconColorByRewardType(v.rewardType, v.itemId)
        item.itemId = v.itemId
        item.isLocal = true
        if v.rewardType == RewardType.GOODS then
            if v.itemId ~= nil then
                --物品或英雄
                item.itemId = v.itemId
                local goods = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
                if goods ~= nil then
                    if goods.icon_big~=nil and goods.icon_big~="" then
                        item.icon_big = string.format(LoadPath.ItemPath, goods.icon_big)
                    end
                    local join_method = -1
                    local icon_join = nil
                    if goods.join_method ~= nil and goods.join_method > 0 and goods.icon_join ~= nil and goods.icon_join ~= "" then
                        join_method = goods.join_method
                        icon_join = goods.icon_join
                    end

                    if join_method > 0 and icon_join ~= nil and icon_join ~= "" then
                        local tempJoin = string.split(icon_join, ";")
                        if #tempJoin > 1 then
                            item.itemColor = tempJoin[2]
                        end
                        if #tempJoin > 2 then
                            item.iconName = tempJoin[3]
                        end
                    else
                        --物品
                        local itemType = goods.type
                        item.goodsType = goods.type
                        item.para2 = goods.para2
                        if itemType == GOODS_TYPE.GOODS_TYPE_2 then
                            -- SPD
                            if goods.para1 ~= nil and goods.para1 ~= "" then
                                local para1 = goods.para1
                                local temp = string.split(para1, ';')
                                if temp ~= nil and #temp > 1 then
                                    item.itemFlag = temp[1] .. temp[2]
                                end
                            end
                        elseif itemType == GOODS_TYPE.GOODS_TYPE_3 then
                            -- USE
                            local type2 = goods.type2
                            if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
                                local res_num = tonumber(goods.para)
                                item.itemFlag = string.GetFormattedStr(res_num)
                            end
                        elseif itemType == GOODS_TYPE.GOODS_TYPE_5 then
                            if goods.para3 ~= nil and goods.para3 ~= "" then
                                local res_num = tonumber(goods.para3)
                                item.itemFlag = string.GetFormattedStr(res_num)
                            end
                        end
                    end
                end
            end
        end
        table.insert(reward, item)
    end
    return reward
end

--展示英雄插件
function RewardManager:ShowHeroPluginReward(campType)
    local list = {}
    local tempParam = {}
    tempParam.rewardType = RewardType.HeroPlugin
    tempParam.itemId = campType
    table.insert(list,tempParam)
    local param = {}
    param.rewardList = list
    param.title = Localization:GetString(GameDialogDefine.CONGRATULATION_REWARD_GET)
    self:SetParam(param)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide})
end

RewardManager.__init = __init
RewardManager.__delete = __delete
RewardManager.AddOneReward = AddOneReward
RewardManager.GetPicByType = GetPicByType
RewardManager.GetNameByType = GetNameByType
RewardManager.ShowGiftReward = ShowGiftReward
RewardManager.ShowCommonReward = ShowCommonReward
RewardManager.ReturnRewardParamForMessage = ReturnRewardParamForMessage
RewardManager.ReturnRewardParamForView = ReturnRewardParamForView
RewardManager.GetGolloesRewards = GetGolloesRewards
RewardManager.GetActGiftBox = GetActGiftBox
RewardManager.GetMailReward = GetMailReward
RewardManager.SetMailFightReward = SetMailFightReward
RewardManager.ShowDailyTaskReward = ShowDailyTaskReward
RewardManager.GetParam = GetParam
RewardManager.ClearParam = ClearParam
RewardManager.SetCloseViewName = SetCloseViewName
RewardManager.ClearViewParam = ClearViewParam
RewardManager.GetViewParam = GetViewParam
RewardManager.SetParam = SetParam
RewardManager.GetDescByType = GetDescByType
RewardManager.ShowCommonHeroReward = ShowCommonHeroReward
RewardManager.ShowMineCaveRewards = ShowMineCaveRewards
RewardManager.GetRewardNames = GetRewardNames
RewardManager.StrRewardHandle = StrRewardHandle
RewardManager.ShowTalentChoose = ShowTalentChoose
RewardManager.StrRewardToNumHandle = StrRewardToNumHandle
RewardManager.GetRewardNumsInPveScene = GetRewardNumsInPveScene
RewardManager.ParsePackReward = ParsePackReward
RewardManager.DealWithHeroOrPoster = DealWithHeroOrPoster
RewardManager.ShowCommonRewards = ShowCommonRewards

return RewardManager