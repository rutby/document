---
--- Pve trigger配置管理
---
---@class DataCenter.LWSound.LWSoundManager
local LWSoundManager = BaseClass("LWSoundManager")
local Sound = CS.GameEntry.Sound
local LWSoundTimer = require("DataCenter.LWSound.LWSoundTimer")
local Localization = CS.GameEntry.Localization

function LWSoundManager:__init()
    self.templateDict = {}
    self.busy = {}
    for i = 1, SoundLimitType.MAX do
        self.busy[i]={}
    end
    self.limit = {
        [SoundLimitType.UnitDeath]=1,--同一时刻单位死亡音效最多可以播放多少个
        [SoundLimitType.BulletHit]=1,--同一时刻子弹击中音效最多可以播放多少个
        [SoundLimitType.BulletCreate]=1,--同一时刻子弹创建音效最多可以播放多少个
        [SoundLimitType.TroopAttackCity]=1,--同一时刻军队攻击音效最多可以播放多少个
        [SoundLimitType.TroopMarching]=1,--同一时刻军队行军音效最多可以播放多少个
    }
    self:AddUpdateTimer()
    self.isEffectOn = CS.GameEntry.Setting:GetBool(SettingKeys.EFFECT_MUSIC_ON, true)--音效开关：控制音效额外音轨
    self.effectExtraGroup = {}--音效额外音轨集合

    self.loopTimerList = {} -- 循环音效计时器  k: SoundLimitType v:timerId {}
    self.loopTimerIdList = {} -- 用来查找Timer， k: timerId  v: LWSoundTimer
end

function LWSoundManager:__delete()
    self:RemoveUpdateTimer()
    self.busy = {}
    self.limit = {}
    self.loopTimerList = {}
    self.loopTimerIdList = {}
    
    if self.templateDict then
        for _,v in pairs(self.templateDict) do
            v.sound:Delete()
        end
        self.templateDict = nil
    end
end

function LWSoundManager:AddUpdateTimer()
    if self.updateTimer == nil then
        self.updateTimer = function() self:OnUpdate() end
        UpdateManager:GetInstance():AddUpdate(self.updateTimer)
    end
end

function LWSoundManager:RemoveUpdateTimer()
    if self.updateTimer then
        UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
        self.updateTimer = nil
    end
end

function LWSoundManager:OnUpdate()
    local deltaTime = Time.deltaTime
    for i = 1, SoundLimitType.MAX do
        for j = 1, self.limit[i] do
            if self.busy[i][j] then
                self.busy[i][j] = self.busy[i][j] - deltaTime
                if self.busy[i][j]<0 then
                    self.busy[i][j]=nil
                end
            end
        end
    end
end

function LWSoundManager:GetTemplate(id)
    id = tonumber(id)
    if table.containsKey(self.templateDict,id) then
        return self.templateDict[id]
    end

    local lineData = LocalController:instance():getLine(TableName.LW_Sound,id)
    if lineData == nil then
        Logger.LogError("lw_sound GetTemplate lineData is nil id:"..id)
        return nil
    end

    local template = {
        id = id,
        sound_num = lineData:getValue("sound_num") or 1,
        sound_time = lineData:getValue("sound_time") or 0,
        --is_cycle = tonumber(lineData:getValue("is_cycle"))==1,
        sound = StringPool.New(lineData:getValue("sound"),";")
    }
    self.templateDict[id] = template

    return template
end

function LWSoundManager:GetSound(id)
    local meta = self:GetTemplate(id)
    if not meta then
        return
    end
    local assetName = meta.sound:GetRandom()
    if not assetName then
        Logger.LogError(string.format("lw_sound表%s行sound列为空",id))
        return
    end
    return assetName
end


function LWSoundManager:StopSound(id)
    if id and id>0 then
        Sound:StopSound(id) 
    end
end

function LWSoundManager:StopAllSounds()
    Sound:StopAllSounds()
end


--loop：是否循环
--independent：是否使用独立音轨
function LWSoundManager:PlaySound(id,loop,independent)
    local meta = self:GetTemplate(id)
    if not meta then
        return 0
    end
    local assetName = meta.sound:GetRandom()
    if not assetName then
        Logger.LogError(string.format("lw_sound表%s行sound列为空",id))
        return 0
    end
    return self:PlaySoundByAssetName(assetName,loop,independent)
end

--loop：是否循环
--independent：是否使用独立音轨
function LWSoundManager:PlaySoundByAssetName(assetName,loop,independent)
    if string.IsNullOrEmpty(assetName) then
        return 0
    end
    if loop then--循环
        -- TODO: Beef 先不播
        --if self.isEffectOn then
        --    local param = CS.SoundComponent.PlaySoundParams()
        --    param.Loop = true
        --    local soundGroupName = independent and assetName or "LoopEffect"--"LoopEffect"为循环音效默认音轨
        --    self.effectExtraGroup[soundGroupName] = true
        --    return Sound:PlaySound(
        --            string.format(LoadPath.SoundEffect,assetName),
        --            soundGroupName,param,nil)
        --end
    else--单次
        return Sound:PlayEffect(assetName)
    end
end

--有限播放：同一时刻可以播放数量有限  
---@param id number  lw_sound Id
function LWSoundManager:PlaySoundByIdWithLimit(id,limitType, isLoop)
    local meta = self:GetTemplate(id)
    if not meta then
        return 0
    end
    local assetName = meta.sound:GetRandom()
    if not assetName then
        Logger.LogError(string.format("lw_sound表%s行sound列为空",id))
        return 0
    end

    if SoundIdToLimitType[id] then
        self.limit[SoundIdToLimitType[id]] = meta.sound_num
    end
    if isLoop and meta.sound_time > 0 then
        return self:PlayLoopSoundWithLimit(assetName, limitType, meta.sound_time / 1000)
    else
        return self:PlaySoundWithLimit(assetName,limitType)
    end
end

--停止循环有限音效播放
function LWSoundManager:StopPlayLoopSoundWithLimit(limitType, timer)

    if timer and timer.timerId then
        local timerId = timer.timerId
        if self.loopTimerList[limitType] and self.loopTimerIdList[timerId] then
            table.removebyvalue(self.loopTimerList[limitType], timerId)
        end
        local timer = self.loopTimerIdList[timerId]
        self.loopTimerIdList[timerId] = nil
        timer:Stop()
    end
end

--有限播放：同一时刻可以播放数量有限
function LWSoundManager:PlaySoundWithLimit(assetName,limitType)
    for i = 1, self.limit[limitType] do
        if self.busy[limitType][i]==nil then
            self.busy[limitType][i]=0.5
            return Sound:PlayEffect(assetName)
        end
    end
end




--有限播放：同一时刻可以播放数量有限
---return Timer timer
function LWSoundManager:PlayLoopSoundWithLimit(assetName,limitType, soundLength)
    local timerIdList = {}
    if self.loopTimerList[limitType] then
        timerIdList = self.loopTimerList[limitType]
    else
        self.loopTimerList[limitType] = timerIdList
    end

    if table.count(timerIdList) < self.limit[limitType] then
        local soundTimer = LWSoundTimer.New(assetName, soundLength)
        table.insert(timerIdList, soundTimer.timerId)
        self.loopTimerIdList[soundTimer.timerId] = soundTimer
        return soundTimer
    end
end


function LWSoundManager:SetSoundEffectOnOff(isOn)
    self.isEffectOn = isOn
    for name,_ in pairs(self.effectExtraGroup) do
        Sound:SetSoundGroupMute(name,not isOn)
    end
end

--播放英雄语音
function LWSoundManager:PlayHeroSound(name,soundGroup)
    local lang = Localization:GetLanguageName()
    local assetPath = string.format(LoadPath.SoundHero,lang,name);
    if not CS.GameEntry.Resource:HasAsset(assetPath) then
        assetPath = string.format("Assets/Main/Sound/Hero/en/%s.ogg", name);
    end
    return Sound:PlaySound(assetPath,soundGroup)
end



return LWSoundManager