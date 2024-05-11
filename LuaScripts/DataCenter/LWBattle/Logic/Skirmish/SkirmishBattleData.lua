---

---

local SkirmishBattleData = BaseClass("SkirmishBattleData")


local function __init(self,data)
    self:InitData(data)
end

local function __delete(self)
    self.mailData=nil
    self.extData=nil
    self.heroData=nil
    self.topSoldierId=nil
    self.actions=nil
end


local function Swap(index)--1~5与6~10对调
    if index <= 10 then
        return (index+4)%10+1
    elseif index >= 11 and index <= 12 then
        -- 11 12对调
        return index==11 and 12 or 11
    else
        return index
    end
end

local function InitData(self,mailExtData)
    self.extData = mailExtData
    --邮件的player_index是攻方1，守方2；
    --回放里player_index是下方1，上方2；
    --转化规则是：攻方在下；特殊地，如果我是守方，守方在下

    if mailExtData.isDefend then--如果我是守方，守方在下，攻方在上，
        self.topPlayerWin = mailExtData.attackerWin
    else--攻方在下，守方在上
        self.topPlayerWin = not mailExtData.attackerWin
    end

    if mailExtData.isDefend then--如果我是守方，1与2对调
        mailExtData.player[1],mailExtData.player[2]=mailExtData.player[2],mailExtData.player[1]
    end
    
    --邮件里的hero_index是攻方1~5，守方6~10
    --回放的index是下方1~5，上方6~10，
    --转化规则是：攻方在下；特殊地，如果我是守方，守方在下
    self.heroData = {}
    for _,v in pairs(self.extData.hero) do
        if self.extData.isDefend then--如果我是守方，1~5与6~10对调
            self.heroData[Swap(v.index)] = v
        else
            self.heroData[v.index] = v
        end
    end
    --找出各自的最高级小兵id
    self.topSoldierId={[1]=0,[2]=0}
    for i = 1, 2 do
        for _,soldierLost in pairs(self.extData.player[i].soldierLost) do
            if self.topSoldierId[i]<soldierLost.soldierId then
                self.topSoldierId[i]=soldierLost.soldierId
            end
        end
    end
    
    self.weaponData = {}
    if not table.IsNullOrEmpty(self.extData.weapon) then
        for _,v in pairs(self.extData.weapon) do
            if self.extData.isDefend then--如果我是守方，11 12对调
                self.weaponData[Swap(v.index)] = v
            else
                self.weaponData[v.index] = v
            end
        end
    end

    --每个行动
    self.actions = {}
    local actions = self.extData.pb_BattleReport.detail.actions
    if self.extData.isDefend then--如果我是守方，对调
        for i = 1,#actions do
            local action = DeepCopy(actions[i])
            action.time = action.time / 1000
            action.casterIndex = Swap(action.casterIndex)
            for _,v in pairs(action.targets) do
                v.index = Swap(v.index)
            end
            table.insert(self.actions,action)
        end
    else
        for i = 1,#actions do
            local action = DeepCopy(actions[i])
            action.time = action.time / 1000
            table.insert(self.actions,action)
        end
    end
    --战斗时长=最后一个行动的时间
    if #actions>0 then
        self.fightDuration = self.actions[#actions].time
    else
        self.fightDuration = 0
    end
    --local jsonData = rapidjson.encode(self.actions)
    --Logger.Log(jsonData)
    
    local maxDamage,maxInjured,maxEnhance,maxWeaken = 0,0,0,0
    for k,v in pairs(self.heroData) do
        if v.stat.damage>maxDamage then
            maxDamage = v.stat.damage
        end
        if v.stat.injured>maxInjured then
            maxInjured = v.stat.injured
        end
        if v.stat.enhance>maxEnhance then
            maxEnhance = v.stat.enhance
        end
        if v.stat.weaken>maxWeaken then
            maxWeaken = v.stat.weaken
        end
    end
    for k,v in pairs(self.weaponData) do
        if v.stat.damage>maxDamage then
            maxDamage = v.stat.damage
        end
        if v.stat.injured>maxInjured then
            maxInjured = v.stat.injured
        end
        if v.stat.enhance>maxEnhance then
            maxEnhance = v.stat.enhance
        end
        if v.stat.weaken>maxWeaken then
            maxWeaken = v.stat.weaken
        end
    end

    self.maxDamage,self.maxInjured,self.maxEnhance,self.maxWeaken=maxDamage,maxInjured,maxEnhance,maxWeaken
end


local function MailIndex2PosIndex(self,mailIndex)
    if self.extData.isDefend then--如果我是守方，1~5与6~10对调
        return Swap(mailIndex)
    else
        return mailIndex
    end
end



SkirmishBattleData.__init = __init
SkirmishBattleData.__delete = __delete
SkirmishBattleData.InitData = InitData
SkirmishBattleData.MailIndex2PosIndex = MailIndex2PosIndex
return SkirmishBattleData

