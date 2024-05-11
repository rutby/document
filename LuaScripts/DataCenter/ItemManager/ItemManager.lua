local ItemManager = BaseClass("ItemManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
    self.lastType = nil
end

local function __delete(self)
    self.lastType = nil
end

local function ItemBuyHandle(self,message)
	local Player = LuaEntry.Player
    if message["errorCode"] == nil then
        if message["remainGold"] ~= nil and  message["costGold"] ~= nil then
            Player.gold = message["remainGold"]
            Player.payTotal = message["costGold"]
            EventManager:GetInstance():Broadcast(EventId.UpdateGold)
        end
        local itemSFS = message["item"]
        if itemSFS ~= nil then
            if itemSFS["id"] ~= nil then
                itemSFS["itemId"] = itemSFS["id"]
            end
        end
        local id = itemSFS["itemId"]
        --UIUtil.ShowTips(Localization:GetString("120643",DataCenter.ItemTemplateManager:GetName(id)))
        
        DataCenter.ItemData:UpdateOneItem(itemSFS)
        EventManager:GetInstance():Broadcast(EventId.RefreshItems)
    else
        UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
    end
end


local function ItemUseHandle(self,message)
    if message["errorCode"] == nil then
        if message["resource"] ~= nil then
            LuaEntry.Resource:UpdateResource(message["resource"])
        end
        local itemId = message["itemId"]
        local item = DataCenter.ItemData:GetItemById(itemId)
        local preCount = 0
        if item ~= nil then
            preCount = item.count
        end
        DataCenter.ItemData:UpdateOneItem(message,false)
        DataCenter.ItemData:OnUseRet(message)
        EventManager:GetInstance():Broadcast(EventId.UseItemSuccess,itemId)
        local dcnt = preCount - message["count"]
        local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
        if template ~= nil then
            local type = template.type
            local type2 = template.type2
            local para = template.para
            local paras = {}
            if para ~= nil and para ~= "" then
                paras = string.split(para,";")
            end

            if type == GOODS_TYPE.GOODS_TYPE_3 then
                if itemId == 200815 then
                    UIUtil.ShowTips(Localization:GetString("320023", dcnt))
                elseif itemId == 200816 then
                    UIUtil.ShowTips(Localization:GetString("320024", dcnt))
                elseif itemId == 200817 then
                    UIUtil.ShowTips(Localization:GetString("320025", dcnt))
                elseif itemId == 200818 then
                    UIUtil.ShowTips(Localization:GetString("320026", dcnt))
                elseif type2 == 999 and paras[3] ~= nil then
                    local resName = CommonUtil.GetResourceNameByType(paras[3])
                    resName = resName..(tonumber(paras[2]) * dcnt)
                    UIUtil.ShowTips(Localization:GetString("120028", resName))
                elseif tonumber(template.para1) == 110 then
                    --vip点数道具，可数量叠加使用
                    local useNum = 1
                    if message["usedItemNum"] then
                        useNum = message["usedItemNum"]
                    end
                    UIUtil.ShowTips(Localization:GetString("320273", tonumber(template.para2)*useNum))
                else
                    UIUtil.ShowTips(Localization:GetString("120028", DataCenter.ItemTemplateManager:GetName(itemId,message["usedItemNum"],message["usedItemNum"])))
                end
            elseif type == GOODS_TYPE.GOODS_TYPE_4 and type2 == 4 then
                UIUtil.ShowTips(Localization:GetString("372580", DataCenter.ItemTemplateManager:GetName(itemId)))
            elseif type == GOODS_TYPE.GOODS_TYPE_39 then
                UIUtil.ShowTips(Localization:GetString("260008", DataCenter.ItemTemplateManager:GetName(itemId)))
            elseif type == GOODS_TYPE.GOODS_TYPE_15 then
                UIUtil.ShowTips(Localization:GetString("390488"))
			elseif type == GOODS_TYPE.GOODS_TYPE_204 then
				local baseNum =  DataCenter.BuildManager:GetAdaptiveBoxBaseNumByGroupAndLevel(tonumber(template.para1) ,DataCenter.BuildManager.MainLv)
				if baseNum ~= nil then
					local retNum = template.para2 * baseNum
					local tipsStr = Localization:GetString(template.para3,string.GetFormattedSeperatorNum(math.floor(retNum)))
					UIUtil.ShowTips(Localization:GetString("120028", tipsStr))
				end
            elseif type ~= GOODS_TYPE.GOODS_TYPE_5 and type ~= GOODS_TYPE.GOODS_TYPE_13 and type ~= GOODS_TYPE.GOODS_TYPE_33 and type ~= GOODS_TYPE.GOODS_TYPE_106 then
                local activtiy_around = template.activtiy_around
                if activtiy_around ~= nil and activtiy_around ~= "" and not CS.ActivityMapCommonController.Instance:IsOpenByActId(activtiy_around) then
                    local overId = template.overdue
                    if overId ~= nil and overId ~= "" then
                        local overItem = DataCenter.ItemTemplateManager:GetItemTemplate(overId)
                        if overItem ~= nil then
                            local name = DataCenter.ItemTemplateManager:GetName(overId).." * "..dcnt
                            UIUtil.ShowTips(Localization:GetString("120028", name))
                        end
                    end
                else
                    UIUtil.ShowTips(Localization:GetString("120026",DataCenter.ItemTemplateManager:GetName(itemId)))
                end
            end

            local showReward = true
            if itemId == "200401" then
                showReward = false
            end

            --道具合成使用时，跟打宝箱一样
            if type == GOODS_TYPE.GOODS_TYPE_5 or type == GOODS_TYPE.GOODS_TYPE_25 or type == GOODS_TYPE.GOODS_TYPE_13 or type == GOODS_TYPE.GOODS_TYPE_46 or type == GOODS_TYPE.GOODS_TYPE_59
                 or type == GOODS_TYPE.GOODS_TYPE_102 or type == GOODS_TYPE.GOODS_TYPE_107  or type == GOODS_TYPE.GOODS_TYPE_106 or type == GOODS_TYPE.GOODS_TYPE_108 or type == GOODS_TYPE.GOODS_TYPE_122 or type == GOODS_TYPE.GOODS_TYPE_123
                    or type == GOODS_TYPE.CALL_BOSS_OR_REWARD then
                if message["itemEffectObj"] ~= nil then
                    local reward = message["itemEffectObj"]["reward"]
                    if reward ~= nil and table.count(reward) > 0 then
                        if showReward and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIResourceBag) then
                            DataCenter.RewardManager:ShowCommonReward(message["itemEffectObj"])
                        end
                        for k,v in pairs(reward) do
                            DataCenter.RewardManager:AddOneReward(v)
                        end
                    elseif message["itemEffectObj"]["heroId"] then
                        DataCenter.RewardManager:ShowCommonHeroReward(message["itemEffectObj"])
                    else
                        DataCenter.RewardManager:DealWithHeroOrPoster(message["itemEffectObj"])
                    end
                    if type == GOODS_TYPE.GOODS_TYPE_122 then
                        if reward and reward[1] then
                            local lastCount = 0
                            local army = DataCenter.ArmyManager:FindArmy(reward[1].value.itemId)
                            if army ~= nil then
                                lastCount = army.free
                            end
                            local temp = DataCenter.ArmyTemplateManager:GetArmyTemplate(reward[1].value.itemId)
                            local str = Localization:GetString("130058",Localization:GetString(temp.name).." x"..(army.free - lastCount))
                            local max = DataCenter.ArmyManager:GetArmyNumMax(temp.arm)
                            local total = DataCenter.ArmyManager:GetTotalArmyNum(temp.arm)
                            UIManager:GetInstance():OpenWindow(UIWindowNames.UISoliderGetTip, {anim = true}, str, army.free - lastCount, total, max, max, temp.arm)
                        end
                     
                    end
                end
            end
        end
        if message["itemEffectObj"] ~= nil then
            local itemEffectObj = message["itemEffectObj"]
            if itemEffectObj ~= nil and itemEffectObj["staminaInfo"]~=nil then
                LuaEntry.Player:SetStaminaData(itemEffectObj["staminaInfo"])
                EventManager:GetInstance():Broadcast(EventId.FormationStaminaUpdate)
                EventManager:GetInstance():Broadcast(EventId.UserItemCoverStamina)
            end
            if itemEffectObj ~= nil and itemEffectObj["pveStaminaInfo"]~=nil then
                LuaEntry.Player:SetPveStaminaData(itemEffectObj["pveStaminaInfo"])
                EventManager:GetInstance():Broadcast(EventId.PveStaminaUpdate)
            end

            if itemEffectObj ~= nil and itemEffectObj["remainGold"] ~= nil then
                LuaEntry.Player.gold = itemEffectObj["remainGold"]
                EventManager:GetInstance():Broadcast(EventId.UpdateGold)
            end
            if itemEffectObj ~= nil and itemEffectObj["resetPage"] ~= nil then
                DataCenter.MasteryManager:OnReset(itemEffectObj)
            end
            if itemEffectObj ~= nil and itemEffectObj["resetPage"] ~= nil then
                DataCenter.MasteryManager:OnReset(itemEffectObj)
            end
            if itemEffectObj ~= nil and itemEffectObj["changePageObj"] ~= nil then
                local changePageObj = itemEffectObj["changePageObj"]
                if changePageObj then
                    local desertTalent = changePageObj["desertTalent"]
                    DataCenter.MasteryManager:HandleInit(changePageObj)
                    DataCenter.MasteryManager:SetMasteryTempPage(0)
                    EventManager:GetInstance():Broadcast(EventId.MasteryUpdate)
                end
            end
            if itemEffectObj ~= nil and itemEffectObj["callBossObj"] ~= nil then
                DataCenter.ActDrakeBossManager:UseItemHandle(itemEffectObj["callBossObj"])
            end
        end

        if DataCenter.VIPManager:IsVipPointItem(tonumber(itemId)) then
            DataCenter.VIPManager:RequestLatestVipInfo()
        end
        EventManager:GetInstance():Broadcast(EventId.RefreshItems,true)
    else
        UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
    end
end



local function ItemBuyAndUseHandle(self,message)
    if message["errorCode"] == nil then
        if message["state"] == 1 then --代表成功
            self:ItemUseHandle(message)
        end
        
    else
        UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
    end
end

local function PushItemDelHandle(self,message)
    DataCenter.ItemData:UpdateOneItem(message,true)
end

local function ItemEffectStateList(self,message)
    if message["errorCode"] == nil then
        local stateObj = message["effectState"]
        local list = {}
        if stateObj ~= nil then
            for k,v in pairs(stateObj) do
                local intKey = tonumber(k)
                local numValue = tonumber(v)
                local param = {}
                param.intKey = intKey
                param.numValue = numValue
                list[intKey] = numValue
                --table.insert(list,param)
            end
            DataCenter.ItemData:SetAllStatusItem(list)
        end
    end
end

local function SetLastType(self,type)
    self.lastType = type
end

local function GetLastType(self)
    return self.lastType
end

--获取资源自选箱里面的信息 传入id 类型 返回每个奖励per数量 索引 
--252004 : 
function ItemManager:GetCustomResourceInfoByIdResType(itemId,resType)
    local temp = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    local canChooseIdGroup = string.split(temp.para1,"|")
    local itemTable = {}
    if #canChooseIdGroup > 0 then
        for i = 1, #canChooseIdGroup do
            local strSpl = string.split(canChooseIdGroup[i],",")
            table.insert(itemTable,{id = strSpl[1],num =strSpl[2],index = i})
        end
    end
    for i = 1, #itemTable do
        local itemTemp = DataCenter.ItemTemplateManager:GetItemTemplate(itemTable[i].id)
        if itemTemp.type2 == resType then
            return itemTemp.para2 * itemTable[i].num ,itemTable[i].index
        end
    end
    return 1,1
end

--获取一键补充资源使用的道具
function ItemManager:GetReplenishUseResourceArr(list)
    local result = {}
    if list ~= nil then
        local customResItem = DataCenter.ItemData:GetItemById(tonumber(252004))
        local customCount = 0
        if customResItem and customResItem.count > 0 then
            customCount = customResItem.count
        end
        for k,v in ipairs(list) do
            local need = v.need
            local own = LuaEntry.Resource:GetCntByResType(v.resType)
            local left = need - own
            if left > 0 then
                local ownList = {}
                local allOwn = 0
                for k1, v1 in ipairs(v.itemArr) do
                    if v1 == 252004 then  --资源自选宝箱
                        local item = DataCenter.ItemData:GetItemById(v1)
                        if item ~= nil and customCount > 0 then
                            local param = {}
                            param.itemId = v1
                            param.own = customCount
                            param.count = param.own
                            local per,index = self:GetCustomResourceInfoByIdResType(v1,v.resType)
                            param.per = per
                            param.index = index --选择的哪个索引
                            param.uuid = item.uuid
                            param.rewardType = RewardType.GOODS
                            param.resType = v.resType
                            param.useOrder = ResLackResTypeOrder.Custom
                            table.insert(ownList, param)
                            allOwn = allOwn + param.own * param.per
                        end
                    else
                        local item = DataCenter.ItemData:GetItemById(v1)
                        if item ~= nil and item.count > 0 then
                            --这里可能会有坑，显示前端是读表，但计算使用服务器的值，这俩值一旦不相等就炸
                            local param = {}
                            param.itemId = v1
                            param.own = item.count
                            param.count = param.own
                            if item.type == GOODS_TYPE.GOODS_TYPE_204 then
                                local tempItem = DataCenter.ItemTemplateManager:GetItemTemplate(v1)
                                local perNum = 0
                                if tempItem.para1 then
                                    local getBaseNum = DataCenter.BuildManager:GetAdaptiveBoxBaseNumByGroupAndLevel(tempItem.para1,DataCenter.BuildManager.MainLv)
                                    if getBaseNum and getBaseNum > 0 then
                                        perNum = getBaseNum
                                    end
                                end
                                param.per = perNum > 0 and perNum or 1
                                param.useOrder = ResLackResTypeOrder.Adapt
                            else
                                param.per = tonumber(item.para2) or 1
                                param.useOrder = ResLackResTypeOrder.Normal
                            end
                            param.uuid = item.uuid
                            param.rewardType = RewardType.GOODS
                            param.resType = v.resType
                            table.insert(ownList, param)
                            allOwn = allOwn + param.own * param.per
                        end
                    end
                end
                if ownList[2] ~= nil then
                    table.sort(ownList, function(a, b)
                        return b.per < a.per
                    end)
                end

                if ownList[1] ~= nil then
                    if left >= allOwn then
                        for k1, v1 in ipairs(ownList) do
                            table.insert(result, v1)
                            if v1.useOrder == ResLackResTypeOrder.Custom then
                                customCount = customCount - v1.count
                            end
                        end
                    else
                        for k1, v1 in ipairs(ownList) do
                            if left > 0 then
                                allOwn = allOwn - v1.own * v1.per
                                local maxUse = math.floor(left / v1.per)
                                if maxUse >= v1.own then
                                    maxUse = v1.own
                                else
                                    --判断剩余是否足够，不够就+1结束
                                    if allOwn < (left - maxUse * v1.per) then
                                        maxUse = maxUse + 1
                                    end
                                end
                                v1.count = maxUse
                                if maxUse > 0 then
                                    left = left - maxUse * v1.per
                                    table.insert(result, v1)
                                    if v1.useOrder == ResLackResTypeOrder.Custom then
                                        customCount = customCount - maxUse
                                    end
                                end
                            else
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    return result
end
--获取一键补充加速使用的道具
function ItemManager:GetReplenishUseSpeedArr(left, list)
    --改成先用光专用，再用通用
    local result = {}
    if left > 0 and list[1] ~= nil then
        local specialList = {}--专用
        local commonList = {}--通用
        local specialOwn = 0
        local commonOwn = 0
        for k, v in ipairs(list) do
            local item = v.item
            local time = 0
            local para1 = GetTableData(DataCenter.ItemTemplateManager:GetTableName(), v.itemId,"para1", "")
            local temp = string.split_ss_array(para1, ';')
            if temp[2] ~= nil then
                time = DataCenter.ItemTemplateManager:GetShowTime(temp[1], temp[2])
            end
            
            local param = {}
            param.itemId = v.itemId
            param.own = item.count
            param.count = param.own
            param.per = time
            param.uuid = item.uuid
            param.type2 = v.type2
            param.rewardType = RewardType.GOODS
            if param.type2 == ItemSpdMenu.ItemSpdMenu_ALL then
                table.insert(commonList, param)
                commonOwn = commonOwn + param.own * param.per
            else
                table.insert(specialList, param)
                specialOwn = specialOwn + param.own * param.per
            end
           
        end
        if commonList[2] ~= nil then
            table.sort(commonList, function(a, b)
                return b.per < a.per
            end)
        end
        if specialList[2] ~= nil then
            table.sort(specialList, function(a, b)
                return b.per < a.per
            end)
        end

        if specialList[1] ~= nil then
            if left >= specialOwn then
                for k1, v1 in ipairs(specialList) do
                    table.insert(result, v1)
                end
                left = left - specialOwn

                if commonList[1] ~= nil then
                    if left >= commonOwn then
                        for k1, v1 in ipairs(commonList) do
                            table.insert(result, v1)
                        end
                    else
                        for k1, v1 in ipairs(commonList) do
                            if left > 0 then
                                commonOwn = commonOwn - v1.own * v1.per
                                local maxUse = math.floor(left / v1.per)
                                if maxUse >= v1.own then
                                    maxUse = v1.own
                                else
                                    --判断剩余是否足够，不够就+1结束
                                    if commonOwn < (left - maxUse * v1.per) then
                                        maxUse = maxUse + 1
                                    end
                                end
                                v1.count = maxUse
                                if maxUse > 0 then
                                    left = left - maxUse * v1.per
                                    table.insert(result, v1)
                                end
                            else
                                break
                            end
                        end
                    end
                end
            else
                for k1, v1 in ipairs(specialList) do
                    if left > 0 then
                        specialOwn = specialOwn - v1.own * v1.per
                        local maxUse = math.floor(left / v1.per)
                        if maxUse >= v1.own then
                            maxUse = v1.own
                        else
                            --判断剩余是否足够，不够就+1结束
                            if specialOwn < (left - maxUse * v1.per) then
                                maxUse = maxUse + 1
                            end
                        end
                        v1.count = maxUse
                        if maxUse > 0 then
                            left = left - maxUse * v1.per
                            table.insert(result, v1)
                        end
                    else
                        break
                    end
                end
            end
        else
            if commonList[1] ~= nil then
                if left >= commonOwn then
                    for k1, v1 in ipairs(commonList) do
                        table.insert(result, v1)
                    end
                else
                    for k1, v1 in ipairs(commonList) do
                        if left > 0 then
                            commonOwn = commonOwn - v1.own * v1.per
                            local maxUse = math.floor(left / v1.per)
                            if maxUse >= v1.own then
                                maxUse = v1.own
                            else
                                --判断剩余是否足够，不够就+1结束
                                if commonOwn < (left - maxUse * v1.per) then
                                    maxUse = maxUse + 1
                                end
                            end
                            v1.count = maxUse
                            if maxUse > 0 then
                                left = left - maxUse * v1.per
                                table.insert(result, v1)
                            end
                        else
                            break
                        end
                    end
                end
            end
        end
    end
    return result
end

function ItemManager:UseResItemMultiHandle(message)
    local errorCode = message["errorCode"]
    if errorCode == nil then
        if message["resource"] ~= nil then
            LuaEntry.Resource:UpdateResource(message["resource"])
        end
        self:UpdateItems(message["items"])
    else
        UIUtil.ShowTipsId(errorCode)
    end
end

function ItemManager:UpdateItems(message)
    if message ~= nil then
        for k,v in ipairs(message) do
            DataCenter.ItemData:UpdateOneItem(v, false)
            DataCenter.ItemData:OnUseRet(v)
        end
        EventManager:GetInstance():Broadcast(EventId.RefreshItems)
    end
end

function ItemManager:PushItemUpdateHandle(message)
    self:UpdateItems(message["items"])
end

ItemManager.__init = __init
ItemManager.__delete = __delete
ItemManager.ItemBuyHandle = ItemBuyHandle
ItemManager.ItemUseHandle = ItemUseHandle
ItemManager.ItemBuyAndUseHandle = ItemBuyAndUseHandle
ItemManager.PushItemDelHandle = PushItemDelHandle
ItemManager.ItemEffectStateList = ItemEffectStateList
ItemManager.SetLastType = SetLastType
ItemManager.GetLastType =  GetLastType
return ItemManager