--- Created by shimin.
--- DateTime: 2023/6/1 18:39
--- 英雄插件管理器

local HeroPluginManager = BaseClass("HeroPluginManager")
local Localization = CS.GameEntry.Localization

function HeroPluginManager:__init()
    self.qualityLevel = {}--品质对应的等级
    self.needCondition = {}--显示条件
    self.lockCost = {} --锁定消耗
    self.unlockScience = {} --解锁插件对应科技
    self.numLevel = {}--数量对应的等级
    self.unlockMaxLevelScience = {} --解锁插件最大等级对应科技
    self.science_without_limit = nil--aps_science_tab.xml（前端）中k14填写的的科技树的unlock_condition字段失效
    self.new_human_param = nil--机器人阵营特殊参数
end

function HeroPluginManager:__delete()
    self.qualityLevel = {}--品质对应的等级
    self.needCondition = {}--显示条件
    self.lockCost = {} --锁定消耗
    self.unlockScience = {} --解锁插件对应科技
    self.numLevel = {}--数量对应的等级
    self.unlockMaxLevelScience = {} --解锁插件最大等级对应科技
    self.science_without_limit = nil--aps_science_tab.xml（前端）中k14填写的的科技树的unlock_condition字段失效
    self.new_human_param = nil--机器人阵营特殊参数
end

function HeroPluginManager:Startup()
end

--发送升级英雄插件
function HeroPluginManager:SendUpgradeHeroPlugin(heroUuid)
    SFSNetwork.SendMessage(MsgDefines.UpgradeHeroPlugin, {heroUuid = heroUuid})
end

--升级英雄插件回调
function HeroPluginManager:UpgradeHeroPluginHandle(message)
    local errCode =  message["errorCode"]
    if errCode == nil then
        local result = {}
        local hero = message["hero"]
        if hero ~= nil then
            local uuid = hero["uuid"]
            local power = 0
            local heroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
            if heroData ~= nil then
                power = HeroUtils.GetHeroPower(heroData)
            end
            DataCenter.HeroDataManager:UpdateOneHero(hero)
            heroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
            if heroData ~= nil then
                power = HeroUtils.GetHeroPower(heroData) - power
            end
            if power > 0 then
                GoToUtil.ShowPower({power = power})
            end
            if uuid ~= nil then
                table.insert(result,uuid)
            end
            if hero["plugin"] ~= nil and hero["plugin"]["lv"] ~= nil then
                local level = hero["plugin"]["lv"]
                if level > 1 then
                    local qualityParam = self:GetUnlockNewQuality(level)
                    if qualityParam ~= nil then
                        local param = {}
                        param.uuid = uuid
                        param.qualityParam = qualityParam
                        param.level = level
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPluginUpgradeQualitySuccess, { anim = true, playEffect = false }, param)
                    end
                end
            end
        end
        if message["gold"] then
            LuaEntry.Player.gold = message["gold"]
            EventManager:GetInstance():Broadcast(EventId.UpdateGold)
        end
        EventManager:GetInstance():Broadcast(EventId.RefreshHeroPlugin, result)
    else
        UIUtil.ShowTipsId(errCode)
    end
end

--发送随机英雄插件
function HeroPluginManager:SendRefineHeroPlugin(heroUuid)
    SFSNetwork.SendMessage(MsgDefines.RefineHeroPlugin, {heroUuid = heroUuid})
end

--随机英雄插件回调
function HeroPluginManager:RefineHeroPluginHandle(message)
    local errCode =  message["errorCode"]
    if errCode == nil then
        local result = {}
        local hero = message["hero"]
        if hero ~= nil then
            DataCenter.HeroDataManager:UpdateOneHero(hero)
            if hero["uuid"] ~= nil then
                table.insert(result, hero["uuid"])
            end
        end
        
        if message["gold"] then
            LuaEntry.Player.gold = message["gold"]
            EventManager:GetInstance():Broadcast(EventId.UpdateGold)
        end
        EventManager:GetInstance():Broadcast(EventId.RefreshHeroPlugin, result)
    else
        UIUtil.ShowTipsId(errCode)
    end
end

--发送保存英雄插件
function HeroPluginManager:SendSaveHeroPlugin(heroUuid, type)
    SFSNetwork.SendMessage(MsgDefines.SaveHeroPlugin, {heroUuid = heroUuid, type = type})
end

--保存英雄插件回调
function HeroPluginManager:SaveHeroPluginHandle(message)
    local errCode =  message["errorCode"]
    if errCode == nil then
        local result = {}
        local hero = message["hero"]
        if hero ~= nil then
            local uuid = hero["uuid"]
            local power = 0
            local heroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
            if heroData ~= nil then
                power = HeroUtils.GetHeroPower(heroData)
            end
            DataCenter.HeroDataManager:UpdateOneHero(hero)
            heroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
            if heroData ~= nil then
                power = HeroUtils.GetHeroPower(heroData) - power
            end
            if power > 0 then
                GoToUtil.ShowPower({power = power})
            end
            
            if uuid ~= nil then
                table.insert(result, uuid)
            end
        end
        
        EventManager:GetInstance():Broadcast(EventId.RefreshHeroPlugin, result)
    else
        UIUtil.ShowTipsId(errCode)
    end
end

--发送升锁英雄插件
function HeroPluginManager:SendLockHeroPlugin(heroUuid, index)
    SFSNetwork.SendMessage(MsgDefines.LockHeroPlugin, {heroUuid = heroUuid, index = index})
end

--锁英雄插件回调
function HeroPluginManager:LockHeroPluginHandle(message)
    local errCode =  message["errorCode"]
    if errCode == nil then
        local result = {}
        local hero = message["hero"]
        if hero ~= nil then
            DataCenter.HeroDataManager:UpdateOneHero(hero)
            if hero["uuid"] ~= nil then
                table.insert(result, hero["uuid"])
            end
        end
  
        EventManager:GetInstance():Broadcast(EventId.RefreshHeroPlugin, result)
    else
        UIUtil.ShowTipsId(errCode)
    end
end

--发送解锁英雄插件
function HeroPluginManager:SendUnlockHeroPlugin(heroUuid, index)
    SFSNetwork.SendMessage(MsgDefines.UnlockHeroPlugin, {heroUuid = heroUuid, index = index})
end

--解锁英雄插件回调
function HeroPluginManager:UnlockHeroPluginHandle(message)
    local errCode =  message["errorCode"]
    if errCode == nil then
        local result = {}
        local hero = message["hero"]
        if hero ~= nil then
            local uuid = hero["uuid"]
            local power = 0
            local heroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
            if heroData ~= nil then
                power = HeroUtils.GetHeroPower(heroData)
            end
            DataCenter.HeroDataManager:UpdateOneHero(hero)
            heroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
            if heroData ~= nil then
                power = HeroUtils.GetHeroPower(heroData) - power
            end
            if power > 0 then
                GoToUtil.ShowPower({power = power})
            end
            
            if uuid ~= nil then
                table.insert(result, uuid)
            end
        end
        
        EventManager:GetInstance():Broadcast(EventId.RefreshHeroPlugin, result)
    else
        UIUtil.ShowTipsId(errCode)
    end
end

--发送交换英雄插件
function HeroPluginManager:SendExchangeHeroPlugin(heroUuidA, heroUuidB)
    SFSNetwork.SendMessage(MsgDefines.ExchangeHeroPlugin, {heroUuidA = heroUuidA, heroUuidB = heroUuidB})
end

--交换英雄插件回调
function HeroPluginManager:ExchangeHeroPluginHandle(message)
    local errCode =  message["errorCode"]
    if errCode == nil then
        local result = {}
        local hero = message["heroA"]
        if hero ~= nil then
            DataCenter.HeroDataManager:UpdateOneHero(hero)
            if hero["uuid"] ~= nil then
                table.insert(result, hero["uuid"])
            end
        end
        hero = message["heroB"]
        if hero ~= nil then
            DataCenter.HeroDataManager:UpdateOneHero(hero)
            if hero["uuid"] ~= nil then
                table.insert(result, hero["uuid"])
            end
        end
        EventManager:GetInstance():Broadcast(EventId.RefreshHeroPlugin, result)
    else
        UIUtil.ShowTipsId(errCode)
    end
end

--获取英雄插件最大等级(当前解锁)
function HeroPluginManager:GetCurMaxLevel(campType)
    local result = LuaEntry.DataConfig:TryGetNum("random_plug_config", "k1")
    if campType == HeroCamp.MAFIA then
        result = result + LuaEntry.Effect:GetGameEffect(EffectDefine.HERO_PLUG_LEVEL_MAX_MAFIA)
    elseif campType == HeroCamp.NEW_HUMAN then
        local param = self:NewHumanCampParam()
        if param ~= nil then
            result = param.level or 0
        end
    elseif campType == HeroCamp.UNION then
        result = result + LuaEntry.Effect:GetGameEffect(EffectDefine.HERO_PLUG_LEVEL_MAX_UNION)
    elseif campType == HeroCamp.ZELOT then
        result = result + LuaEntry.Effect:GetGameEffect(EffectDefine.HERO_PLUG_LEVEL_MAX_ZEALOT)
    end
    return result
end

--获取英雄插件品质
function HeroPluginManager:GetQuality(level)
    if self.qualityLevel[1] == nil then
        self:InitUnlockQuality()
    end
    local num = #self.qualityLevel
    if num > 0 then
        for i = num, 1, -1 do
            if self.qualityLevel[i].level <= level then
                return self.qualityLevel[i].quality
            end
        end
    end
    
    return HeroPluginQualityType.White
end

--英雄插件是否已解锁
function HeroPluginManager:IsUnlock(campType, heroUuid)
    local result = 0
    if campType == HeroCamp.MAFIA then
        result = LuaEntry.Effect:GetGameEffect(EffectDefine.HERO_PLUG_UNLOCK_MAFIA)
    elseif campType == HeroCamp.NEW_HUMAN then
        if self:IsOpenSwitchCamp() then
            local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
            if heroData ~= nil and heroData.plugin ~= nil then
                result = 1
            end
        end
    elseif campType == HeroCamp.UNION then
        result = LuaEntry.Effect:GetGameEffect(EffectDefine.HERO_PLUG_UNLOCK_UNION)
    elseif campType == HeroCamp.ZELOT then
        result = LuaEntry.Effect:GetGameEffect(EffectDefine.HERO_PLUG_UNLOCK_ZEALOT)
    end
    return result > 0
end

--获取英雄插件功能是否可以显示
function HeroPluginManager:IsOpen()
    if self.needCondition.mainLv == nil then
        self.needCondition = {}
        local k3 = LuaEntry.DataConfig:TryGetStr("random_plug_config", "k3")
        if k3 ~= "" then
            local spl1 = string.split_ii_array(k3, ";")
            if spl1[2] ~= nil then
                self.needCondition.mainLv = spl1[1]
                self.needCondition.season = spl1[2]
            end
        end
    end
  
    if self.needCondition.mainLv ~= nil and DataCenter.BuildManager.MainLv >= self.needCondition.mainLv then
        if self:IsSkipSeasonLimit() then
            return true
        end
        local season = DataCenter.SeasonDataManager:GetSeason() or 0
        if self.needCondition.season ~= nil and season >= self.needCondition.season then
            return true
        end
    end

    return false
end

--获取英雄插件锁定词条的数目
function HeroPluginManager:IsUnlockLock(campType)
    return self:GetLockNum(campType) > 0
end

--获取英雄插件锁定词条的数目
function HeroPluginManager:GetLockNum(campType)
    local result = 0
    if campType == HeroCamp.MAFIA then
        result = LuaEntry.Effect:GetGameEffect(EffectDefine.HERO_PLUG_LOCK_NUM_MAFIA)
    elseif campType == HeroCamp.NEW_HUMAN then
        local param = self:NewHumanCampParam()
        if param ~= nil then
            result = param.lockNum or 0
        end
    elseif campType == HeroCamp.UNION then
        result = LuaEntry.Effect:GetGameEffect(EffectDefine.HERO_PLUG_LOCK_NUM_UNION)
    elseif campType == HeroCamp.ZELOT then
        result = LuaEntry.Effect:GetGameEffect(EffectDefine.HERO_PLUG_LOCK_NUM_ZEALOT)
    end
    return result
end

--是否可以锁定
function HeroPluginManager:CanSetLock(heroUuid, lock)
    if lock then
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
        if heroData ~= nil then
            local campType = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
            local all = self:GetLockNum(campType)
            local now = heroData:GetLockPluginNum()
            return now < all
        end
    else
        return true
    end
    return false
end

--是否全部锁定
function HeroPluginManager:IsAllLock(heroUuid)
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData ~= nil then
        local all = heroData:GetPluginNum()
        local now = heroData:GetLockPluginNum()
        return now > 0 and now >= all
    end
    return false
end


--获取英雄插件锁定的消耗
function HeroPluginManager:GetLockCostNum(lockNum)
    if self.lockCost[1] == nil then
        self.lockCost = {}
        local k5 = LuaEntry.DataConfig:TryGetStr("random_plug_config", "k5")
        if k5 ~= "" then
            self.lockCost = string.split_ii_array(k5, ";")
        end
    end
    if self.lockCost[lockNum] ~= nil then
        return self.lockCost[lockNum]
    end
    return 0
end

--获取英雄插件解锁科技
function HeroPluginManager:GetUnlockScienceId(campType)
    if self.unlockScience[campType] == nil then
        self.unlockScience = {}
        local k6 = LuaEntry.DataConfig:TryGetStr("random_plug_config", "k6")
        if k6 ~= "" then
            local spl = string.split_ss_array(k6, "|")
            for k, v in ipairs(spl) do
                local spl1 = string.split_ii_array(v, ";")
                if spl1[2] ~= nil then
                    self.unlockScience[spl1[1]] = spl1[2]
                end
            end
        end
    end
    if self.unlockScience[campType] ~= nil then
        return self.unlockScience[campType]
    end
    return 0
end

--获取英雄插件品质图片
function HeroPluginManager:GetQualityIconName(level)
    local quality = self:GetQuality(level)
    return string.format(LoadPath.HeroDetailPath, "UI_cj_board0" .. quality)
end

--获取英雄插件阵营图片
function HeroPluginManager:GetCampIconName(campType)
    local result = ""
    if campType == HeroCamp.MAFIA then
        result = string.format(LoadPath.HeroDetailPath, "UI_cj_zi")
    elseif campType == HeroCamp.UNION then
        result = string.format(LoadPath.HeroDetailPath, "UI_cj_lan")
    elseif campType == HeroCamp.ZELOT then
        result = string.format(LoadPath.HeroDetailPath, "UI_cj_huang")
    elseif campType == HeroCamp.NEW_HUMAN then
        result = string.format(LoadPath.HeroDetailPath, "UI_cj_lv")
    end
    return result
end

--获取英雄插件属性条目数量
function HeroPluginManager:GetMaxNum(level)
    if self.numLevel[1] == nil then
        self:InitNumLevel()
    end
    for i = #self.numLevel, 1, -1 do
        if self.numLevel[i].level <= level then
            return self.numLevel[i].num
        end
    end

    return 1
end

--获取英雄插件属性条目数量需要的等级
function HeroPluginManager:GetLevelByNum(num)
    if self.numLevel[1] == nil then
        self:InitNumLevel()
    end
    for i = #self.numLevel, 1, -1 do
        if self.numLevel[i].num == num then
            return self.numLevel[i].level
        end
    end
    return 0
end

function HeroPluginManager:InitNumLevel()
    self.numLevel = {}
    local temp = LuaEntry.DataConfig:TryGetStr("random_plug_config", "k4")
    if temp ~= "" then
        local spl = string.split_ss_array(temp, "|")
        for k, v in ipairs(spl) do
            local spl1 = string.split_ii_array(v, ";")
            if spl1[2] ~= nil then
                local param = {}
                param.level = spl1[1]
                param.num = spl1[2]
                table.insert(self.numLevel, param)
            end
        end
    end
end

function HeroPluginManager:InitUnlockMaxLevelScience()
    self.unlockMaxLevelScience = {}
    local temp = LuaEntry.DataConfig:TryGetStr("random_plug_config", "k7")
    if temp ~= "" then
        local spl = string.split_ss_array(temp, "|")
        for k, v in ipairs(spl) do
            local spl1 = string.split_ss_array(v, ";")
            if spl1[2] ~= nil then
                local campType = tonumber(spl1[1])
                self.unlockMaxLevelScience[campType] = {}
                local spl2 = string.split_ss_array(spl1[2], ",")
                for k1, v1 in ipairs(spl2) do
                    local spl3 = string.split_ii_array(v1, "#")
                    if spl3[2] ~= nil then
                        local param = {}
                        param.level = spl3[1]
                        param.scienceId = spl3[2]
                        table.insert(self.unlockMaxLevelScience[campType], param)
                    end
                end
            end
        end
    end
end


--获取英雄插件可升级的最大等级
function HeroPluginManager:GetMaxLevel()
    return LuaEntry.DataConfig:TryGetNum("random_plug_config", "k8")
end

--获取解锁当前最大等级的科技id
function HeroPluginManager:GetUnlockMaxLevelScienceId(campType, level)
    if self.unlockMaxLevelScience[campType] == nil then
        self:InitUnlockMaxLevelScience()
    end
    local list = self.unlockMaxLevelScience[campType]
    if list ~= nil then
        for k, v in ipairs(list) do
            if v.level == level then
                return v.scienceId
            end
        end
    end
    return 0
end

--获取英雄插件品质名字
function HeroPluginManager:GetQualityNameByLevel(level)
    local result = ""
    local quality = self:GetQuality(level)
    if quality == HeroPluginQualityType.White then
        result = Localization:GetString(GameDialogDefine.HERO_PLUGIN_NAME_WHITE)
    elseif quality == HeroPluginQualityType.Green then
        result = Localization:GetString(GameDialogDefine.HERO_PLUGIN_NAME_GREEN)
    elseif quality == HeroPluginQualityType.Blue then
        result = Localization:GetString(GameDialogDefine.HERO_PLUGIN_NAME_BLUE)
    elseif quality == HeroPluginQualityType.Purple then
        result = Localization:GetString(GameDialogDefine.HERO_PLUGIN_NAME_PURPLE)
    elseif quality == HeroPluginQualityType.Orange then
        result = Localization:GetString(GameDialogDefine.HERO_PLUGIN_NAME_ORANGE)
    elseif quality == HeroPluginQualityType.Gold then
        result = Localization:GetString(GameDialogDefine.HERO_PLUGIN_NAME_RED)
    end
    return string.format(TextColorStr, self:GetTextColorByQuality(quality), result)
end


function HeroPluginManager:InitUnlockQuality()
    self.qualityLevel = {}
    local temp = LuaEntry.DataConfig:TryGetStr("random_plug_config", "k9")
    if temp ~= "" then
        local spl = string.split_ss_array(temp, "|")
        for k, v in ipairs(spl) do
            local param = {}
            self.qualityLevel[k] = param
            param.quality = k
            local spl1 = string.split_ss_array(v, ",")
            if spl1[1] ~= nil then
                param.list = string.split_ii_array(spl1[1], ";")
            end
            if spl1[2] ~= nil then
                param.desc = tonumber(spl1[2])
            end
        end
    end

    local k2 = LuaEntry.DataConfig:TryGetStr("random_plug_config", "k2")
    if k2 ~= "" then
        local spl = string.split_ss_array(k2, "|")
        for k, v in ipairs(spl) do
            local spl1 = string.split_ii_array(v, ";")
            if spl1[2] ~= nil then
                if self.qualityLevel[spl1[2]] ~= nil then
                    self.qualityLevel[spl1[2]].level = spl1[1]
                end
            end
        end
    end
end

--获取解锁品质信息
function HeroPluginManager:GetUnlockQualityParam(quality)
    if self.qualityLevel[1] == nil then
        self:InitUnlockQuality()
    end
    return self.qualityLevel[quality]
end

--获取所有品质
function HeroPluginManager:GetAllUnlockQuality()
    if self.qualityLevel[1] == nil then
        self:InitUnlockQuality()
    end
    return self.qualityLevel
end

--获取所有品质
function HeroPluginManager:GetTextColorByQuality(quality)
    if quality == HeroPluginQualityType.White then
        return TextQualityColorWhite
    elseif quality == HeroPluginQualityType.Green then
        return TextQualityColorGreen
    elseif quality == HeroPluginQualityType.Blue then
        return TextQualityColorBlue
    elseif quality == HeroPluginQualityType.Purple then
        return TextQualityColorPurple
    elseif quality == HeroPluginQualityType.Orange then
        return TextQualityColorOrange
    elseif quality == HeroPluginQualityType.Gold then
        return TextQualityColorGold
    end
    return TextQualityColorWhite
end

--获取解锁的新品质
function HeroPluginManager:GetUnlockNewQuality(level)
    if self.qualityLevel[1] == nil then
        self:InitUnlockQuality()
    end
    for k, v in pairs(self.qualityLevel) do
        if v.level == level then
            return v
        end
    end
    return nil
end

--获取品质对应菱形图标名称
function HeroPluginManager:GetRhombusNameByQuality(quality)
    if quality == HeroPluginQualityType.Gold then
        return string.format(LoadPath.HeroAdvancePath, "UI_icon_big_glugin_star")
    end
    return string.format(LoadPath.HeroAdvancePath, "UI_icon_glugin_point_0" .. quality)
end

--获取英雄插件品质颜色名字
function HeroPluginManager:GetQualityColorNameByLevel(level)
    local result = ""
    local quality = self:GetQuality(level)
    if quality == HeroPluginQualityType.White then
        result = Localization:GetString(GameDialogDefine.COLOR_WHITE)
    elseif quality == HeroPluginQualityType.Green then
        result = Localization:GetString(GameDialogDefine.COLOR_GREEN)
    elseif quality == HeroPluginQualityType.Blue then
        result = Localization:GetString(GameDialogDefine.COLOR_BLUE)
    elseif quality == HeroPluginQualityType.Purple then
        result = Localization:GetString(GameDialogDefine.COLOR_PURPLE)
    elseif quality == HeroPluginQualityType.Orange then
        result = Localization:GetString(GameDialogDefine.COLOR_ORANGE)
    elseif quality == HeroPluginQualityType.Gold then
        result = Localization:GetString(GameDialogDefine.COLOR_GOLD)
    end
    return string.format(TextColorStr, self:GetTextColorByQuality(quality), result)
end

--播放词条出现声音
function HeroPluginManager:PlayShowSound(quality)
    if quality == HeroPluginQualityType.Orange then
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_HERO_PLUGIN_SHOW_ORANGE)
    elseif quality == HeroPluginQualityType.Gold then
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_HERO_PLUGIN_SHOW_GOLD)
    else
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_HERO_PLUGIN_SHOW_NORMAL)
    end
end

--播放升级界面词条出现特效
function HeroPluginManager:GetUpgradeEffectName(quality)
    if quality == HeroPluginQualityType.Orange then
        return UIAssets.UIHeroPluginUpgradeEffectGold
    elseif quality == HeroPluginQualityType.Gold then
        return UIAssets.UIHeroPluginUpgradeEffectOrange
    elseif quality == HeroPluginQualityType.Purple then
        return UIAssets.UIHeroPluginUpgradeEffectPurple
    end
    return nil
end

--播放随机界面词条出现特效
function HeroPluginManager:GetRefineEffectName(quality)
    if quality == HeroPluginQualityType.Orange then
        return UIAssets.UIHeroPluginRefineEffectGold
    elseif quality == HeroPluginQualityType.Gold then
        return UIAssets.UIHeroPluginRefineEffectOrange
    elseif quality == HeroPluginQualityType.Purple then
        return UIAssets.UIHeroPluginRefineEffectPurple
    end
    return nil
end

--插件功能是否跳过赛季限制
function HeroPluginManager:IsSkipSeasonLimit()
    return LuaEntry.DataConfig:CheckSwitch("skip_season_random_plug")
end

--科技解锁是否无视unlock_condition字段
function HeroPluginManager:IsUnlockScienceWithoutLimit(tabId)
    if self.science_without_limit == nil then
        self.science_without_limit = {}
        local temp = LuaEntry.DataConfig:TryGetStr("random_plug_config", "k14")
        if temp ~= "" then
            local spl1 = string.split_ii_array(temp, ";")
            for k, v in ipairs(spl1) do
                self.science_without_limit[v] = true
            end
        end
    end
    if self:IsOpen() then
        return self.science_without_limit[tabId]
    end
    return false
end

--机器人插件解锁的等级上限和锁定数量
function HeroPluginManager:NewHumanCampParam()
    if self.new_human_param == nil then
        self.new_human_param = {}
        local temp = LuaEntry.DataConfig:TryGetStr("random_plug_config", "k15")
        if temp ~= "" then
            local spl1 = string.split_ii_array(temp, ";")
            if spl1[1] ~= nil then
                self.new_human_param.level = spl1[1]
            end
            if spl1[2] ~= nil then
                self.new_human_param.lockNum = spl1[2]
            end
        end
    end
    return self.new_human_param
end

--是否开启阵营切换功能
function HeroPluginManager:IsOpenSwitchCamp()
    return LuaEntry.DataConfig:CheckSwitch("hero_change_camp")
end

return HeroPluginManager
