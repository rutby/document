--- Created by shimin
--- DateTime: 2023/9/25 12:17
--- 雷达召唤海盗船

local RadarBossManager = BaseClass("RadarBossManager");

local Localization = CS.GameEntry.Localization
local RadarBossInfo = require "DataCenter.RadarBossManager.RadarBossInfo"
local ActBossData = require "DataCenter.ActBossDataManager.ActBossData"
local ActBossRankDataList = require "DataCenter.ActBossDataManager.ActBossRankDataList"
local Setting = CS.GameEntry.Setting

function RadarBossManager:__init()
    self.info = nil
    self.bossRewardList = {}
    self.bossRankList = {}
    self.puzzleMarches = {}
    self.count = 0--每天实际领取奖励的次数
    self.dmgRate = 0--当前伤害
end

function RadarBossManager:__delete()
    self.info = nil
    self.bossRewardList = {}
    self.bossRankList = {}
    self.puzzleMarches = {}
    self.count = 0--每天实际领取奖励的次数
    self.dmgRate = 0--当前伤害
end

function RadarBossManager:Startup()
end

--是否在雷达界面显示海盗船按钮
function RadarBossManager:IsShowBtn()
    --大本和开关
    if LuaEntry.DataConfig:CheckSwitch("boss_in_radar") then
        local mainLv = DataCenter.BuildManager.MainLv
        local needLevel = LuaEntry.DataConfig:TryGetNum("radar_puzzle", "k6")
        if mainLv >= needLevel then
            return true
        end
    end
    return false
end

--海盗船红点个数
function RadarBossManager:GetRedNun()
    local result = table.count(self.puzzleMarches)
    --加上自己
    if self:CanCreatePuzzleBoss() then
        result = result + 1
    end
    return result
end

--海盗船红点个数
function RadarBossManager:GetUIMainRedNun()
    local result = 0
    if self:CanCreatePuzzleBoss() then
        result = result + 1
    end
    return result
end

--是否可以召唤海盗
function RadarBossManager:CanCreatePuzzleBoss()
    local progress = DataCenter.RadarCenterDataManager:GetBossProgress()
    local needProgress = self:GetNeedProgress()
    if progress >= needProgress then
        local callTime = math.floor(DataCenter.RadarCenterDataManager:GetCallBossTime() / 1000)
        local curTime = UITimeManager:GetInstance():GetServerSeconds()
        local isSameDay = UITimeManager:GetInstance():IsSameDayForServer(curTime, callTime)
        if not isSameDay then
            return true
        end
    end
    return false
end

--是否可以召唤海盗
function RadarBossManager:GetNeedProgress()
    return LuaEntry.DataConfig:TryGetNum("radar_puzzle", "k7")
end

--获得每天可获得奖励的次数
function RadarBossManager:GetAllDailyGetRewardTime()
    return LuaEntry.DataConfig:TryGetNum("radar_puzzle", "k1")
end

--获得每天可获得奖励的次数
function RadarBossManager:GetDailyLeftGetRewardTime()
    local result = self:GetAllDailyGetRewardTime() - self:GetDailyGetRewardTime()
    if result < 0 then
        result = 0
    end
    return result
end

--发送召唤雷达boss
function RadarBossManager:SendCallRadarBoss(monsterId)
    SFSNetwork.SendMessage(MsgDefines.CallRadarBoss, {monsterId = monsterId})
end

function RadarBossManager:CallRadarBossHandle(message)
    local errorCode = message["errorCode"]
    if errorCode ~= nil then
        if errorCode ~= SeverErrorCode then
            UIUtil.ShowTipsId(errorCode)
        end
    else
        local callBossTime = message["callBossTime"]
        if callBossTime ~= nil then
            DataCenter.RadarCenterDataManager:SetCallBossTime(callBossTime)
        end
        self:UpdateInfo(message)
        GoToUtil.CloseAllWindows()
        if message["monsterPointId"] then
            GoToUtil.MoveToWorldPointAndOpen(message["monsterPointId"])
        end
    end
end

function RadarBossManager:IsBossUnlock(bossId)
    local unlock = DataCenter.MonsterTemplateManager:GetTableValue(bossId, "unlock")
    if unlock == nil then
        return false, 0, 0
    end
    local needDmg = unlock
    local dmgRate = DataCenter.RadarCenterDataManager:GetDmgRate(monster.unlock_monster)
    return dmgRate >= needDmg, needDmg, dmgRate
end

function RadarBossManager:SendGetRadarBossMarch()
    SFSNetwork.SendMessage(MsgDefines.GetRadarBossMarch)
end

function RadarBossManager:GetRadarBossMarchHandle(message)
    local errorCode = message["errorCode"]
    if errorCode ~= nil then
        if errorCode ~= SeverErrorCode then
            UIUtil.ShowTipsId(errorCode)
        end
    else
        self.puzzleMarches = {}
        local marches = message["marches"]
        if marches ~= nil then
            for k, v in pairs(marches) do
                local oneData = ActBossData.New()
                oneData:ParseData(v)
                if oneData.uuid ~= 0 then
                    self.puzzleMarches[oneData.uuid] = oneData
                end
            end
        end
        EventManager:GetInstance():Broadcast(EventId.OnPuzzleMonsterDataRefresh)
    end
end

function RadarBossManager:GetPuzzleMarches()
    return self.puzzleMarches
end

function RadarBossManager:GetPuzzleMarchByUuid(uuid)
    return self.puzzleMarches[uuid]
end

--获取雷达boss参数
function RadarBossManager:GetRadarBoss()
    local boss = self:GetMyBoss()
    if boss ~= nil then
        local reward_detail = GetTableData(TableName.boss.monsterId, "reward_detail")
        if reward_detail ~= nil then
            local param = {}
            param.id = boss.monsterId
            param.reward = reward_detail
            param.pointId = boss.startPos
            param.uuid = boss.uuid
            param.state = DetectEventState.DETECT_EVENT_STATE_NOT_FINISH
            param.fromType = DetectEventFromType.RadarBoss
            param.endTime = boss.actEndTime
            return param
        end
    end
    return nil
end

--获取我自己的boss
function RadarBossManager:GetMyBoss()
    local result = nil
    local time = 0
    local myUid = LuaEntry.Player:GetUid()
    for k,v in pairs(self.puzzleMarches) do
        if v.bossOwnerUid == myUid and time < v.actEndTime then
            time = v.actStartTime
            result = v
        end
    end
    return result
end

--获取今天已经获奖的次数
function RadarBossManager:GetDailyGetRewardTime()
    return self.count
end

--获取今天已经获奖的次数
function RadarBossManager:CanGetReward()
    return self:GetDailyLeftGetRewardTime() > 0
end

function RadarBossManager:SendUserGetRadarBossRank(uuid)
    SFSNetwork.SendMessage(MsgDefines.UserGetRadarBossRank, {uuid = uuid})
end

function RadarBossManager:UserGetRadarBossRankHandle(message)
    local errorCode = message["errorCode"]
    if errorCode ~= nil then
        if errorCode ~= SeverErrorCode then
            UIUtil.ShowTipsId(errorCode)
        end
    else
        local oneData = ActBossRankDataList.New()
        oneData:ParseData(message)
        if oneData.uuid~=0 then
            self.bossRankList[oneData.uuid] = oneData
        end

        EventManager:GetInstance():Broadcast(EventId.OnPuzzleMonsterRankRefresh)
    end
end

function RadarBossManager:SendGetRadarBossRewardCount()
    SFSNetwork.SendMessage(MsgDefines.GetRadarBossRewardCount)
end

function RadarBossManager:GetRadarBossRewardCountHandle(message)
    local errorCode = message["errorCode"]
    if errorCode ~= nil then
        if errorCode ~= SeverErrorCode then
            UIUtil.ShowTipsId(errorCode)
        end
    else
        self.count = message["count"]
        EventManager:GetInstance():Broadcast(EventId.RefreshRadarBossDailyRewardCount)
    end
end

function RadarBossManager:GetBossRankDataByUuid(uuid)
    return self.bossRankList[uuid]
end


function RadarBossManager:SendGetRadarBossRankRewardInfo(uuid)
    SFSNetwork.SendMessage(MsgDefines.GetRadarBossRankRewardInfo, {uuid = uuid})
end

function RadarBossManager:GetRadarBossRankRewardInfoHandle(message)
    local errorCode = message["errorCode"]
    if errorCode ~= nil then
        if errorCode ~= SeverErrorCode then
            UIUtil.ShowTipsId(errorCode)
        end
    else
        self.dmgRate = message["dmgRate"] or 0
        local GetRewardList = function(rewardList)
            local reward = {}
            table.walk(rewardList, function (_, v)
                local item = {}
                item.count = v.count
                item.itemId = v.itemId
                item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.WHITE)
                item.rewardType = v.rewardType
                local desc = DataCenter.RewardManager:GetDescByType(v.rewardType, v.itemId)
                local name = DataCenter.RewardManager:GetNameByType(v.rewardType, v.itemId)
                item.itemName = name
                item.itemDesc = desc
                item.isLocal = true
                if v.rewardType == RewardType.GOODS then
                    if v.itemId ~= nil then
                        --物品或英雄
                        --item.itemName = Localization:GetString(name)
                        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
                        if goods ~= nil then
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
                                item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
                                local itemType = goods.type
                                if itemType == 2 then
                                    -- SPD
                                    if goods.para1 ~= nil and goods.para1 ~= "" then
                                        local para1 = goods.para1
                                        local temp = string.split(para1, ';')
                                        if temp ~= nil and #temp > 1 then
                                            item.itemFlag = temp[1] .. temp[2]
                                        end
                                    end
                                elseif itemType == 3 then
                                    -- USE
                                    local type2 = goods.type2
                                    if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
                                        local res_num = tonumber(goods.para)
                                        item.itemFlag = string.GetFormattedStr(res_num)
                                    end
                                end

                                item.iconName = string.format(LoadPath.ItemPath, goods.icon)
                            end
                        end
                    end
                elseif v.rewardType == RewardType.GOLD then
                    item.iconName = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
                    item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE)
                elseif v.rewardType == RewardType.OIL or v.rewardType == RewardType.METAL or v.rewardType == RewardType.FORMATION_STAMINA
                        or v.rewardType == RewardType.WATER or v.rewardType == RewardType.PVE_POINT or v.rewardType == RewardType.DETECT_EVENT
                        or v.rewardType == RewardType.MONEY or v.rewardType == RewardType.ELECTRICITY then
                    item.iconName = DataCenter.RewardManager:GetPicByType(v.rewardType)
                    item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE)
                end
                table.insert(reward, item)
            end)
            return reward
        end

        self.bossReward = {}
        local title1 = {}
        title1.title = 372247
        table.insert(self.bossReward, title1)

        if message["callReward"] then
            local rewardList = DataCenter.RewardManager:ReturnRewardParamForView(message["callReward"])
            local reward = GetRewardList(rewardList)
            local oneData = {}
            oneData.rewardStr  = reward
            oneData.createrName = message["userName"] or ""
            table.insert(self.bossReward, oneData)
        end

        local title2 = {}
        title2.title = 372248
        table.insert(self.bossReward, title2)

        if message["partakeReward"] ~= nil then
            local rewardList = DataCenter.RewardManager:ReturnRewardParamForView(message["partakeReward"])
            local reward = GetRewardList(rewardList)
            local oneData = {}
            oneData.rewardStr  = reward
            oneData.attacked = message["attacked"] or 0
            table.insert(self.bossReward, oneData)
        end

        local title3 = {}
        title3.title = GameDialogDefine.RADAR_BOSS_DAM_REWARD
        table.insert(self.bossReward, title3)

        local title4 = {}
        title4.noUseLocal = true
        title4.noShowBg = true
        title4.title = Localization:GetString(GameDialogDefine.RADAR_BOSS_CUR_DAM, self.dmgRate) 
        table.insert(self.bossReward, title4)

        local damageRewardArr = message["damageRewardArr"]
        if damageRewardArr ~= nil then
            local curIndex = -1
            for k, v in ipairs(damageRewardArr) do
                if v.damageRate <= self.dmgRate then
                    curIndex = k
                end
            end
            for k, v in ipairs(damageRewardArr) do
                local rewardList = DataCenter.RewardManager:ReturnRewardParamForView(v.reward)
                local reward = GetRewardList(rewardList)
                local oneData = {}
                oneData.rankStr = Localization:GetString(GameDialogDefine.RADAR_BOSS_DAM_WITH, v.damageRate)
                if curIndex == k then
                    oneData.select = true
                    oneData.selectStr = Localization:GetString(GameDialogDefine.RADAR_BOSS_FIGHT_GET_CUR_REWARD)
                else
                    oneData.select = false
                end
                oneData.rewardStr  = reward
                table.insert(self.bossReward, oneData)
            end
        end
     
        EventManager:GetInstance():Broadcast(EventId.OnPuzzleMonsterRankRefresh)
    end
end

function RadarBossManager:GetBossRankReward(uuid)
    return self.bossReward
end

function RadarBossManager:ResetBossRankReward(uuid)
    self.bossReward = nil
end

function RadarBossManager:UpdateInfo(info)
    if self.info == nil then
        self.info = RadarBossInfo.New()
    end
    self.info:ParseData(info)
    EventManager:GetInstance():Broadcast(EventId.PuzzleDataUpdate)
end

function RadarBossManager:GetCurDmgRate()
    return self.dmgRate
end

function RadarBossManager:SaveBossUnlockAnimationPlay(bossId)
    local settingStr = "PuzzleMonsterOpenEffectShow_" .. LuaEntry.Player.uid.."__"..bossId
    Setting:SetString(settingStr, "1")
end

function RadarBossManager:GetBossUnlockAnimationPlay(bossId)
    local settingStr = "PuzzleMonsterOpenEffectShow_" .. LuaEntry.Player.uid.."__"..bossId
    local str = Setting:GetString(settingStr, "")
    return not string.IsNullOrEmpty(str)
end

function RadarBossManager:SaveBossRewardRedDot(bossId)
    local time = DataCenter.RadarCenterDataManager:GetCallBossTime()
    local settingStr = "BossRewardRedDot_" .. LuaEntry.Player.uid.."__"..bossId.."_"..time
    Setting:SetString(settingStr, "1")
end

function RadarBossManager:GetBossRewardRedDot(bossId)
    local time = DataCenter.RadarCenterDataManager:GetCallBossTime()
    local settingStr = "BossRewardRedDot_" .. LuaEntry.Player.uid.."__"..bossId.."_"..time
    local str = Setting:GetString(settingStr, "")
    return string.IsNullOrEmpty(str)
end

return RadarBossManager