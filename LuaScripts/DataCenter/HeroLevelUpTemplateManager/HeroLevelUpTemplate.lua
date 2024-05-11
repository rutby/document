--- Created by shimin
--- DateTime: 2023/9/4 17:30
--- 英雄升级表

local HeroLevelUpTemplate = BaseClass("HeroLevelUpTemplate")

local MaxSeason = 20--暂定登录读20个赛季 不够再加
local MaxRarity = 4--目前4个品质，加表要改

function HeroLevelUpTemplate:__init()
    self.id = 0--等级
    self.exp = 0--升级所需经验
    self.exp_ = {}--赛季经验
    self.lv_attr_atk = {}--不同品质的攻击力
    self.lv_attr_def = {}--不同品质的防御力
    self.army_num = {}----不同品质的带兵量
    self.spend = 0--升级消耗的金币
    self.break_require = 0
    self.break_require_rank = 0
    self.break_require_base = 0
end

function HeroLevelUpTemplate:__delete()
   
end

function HeroLevelUpTemplate:InitData(row)
    if row ==nil then
        return
    end
    self.id = row:getValue("id") or 0
    self.exp = row:getValue("exp") or 0
    self.exp_ = {}
    local temp = nil
    for i = 1, MaxSeason, 1 do
        temp = row:getValue("exp_" .. i) or 0
        if temp ~= 0 then
            self.exp_[i] = temp
        end
    end
    self.spend = row:getValue("spend") or 0
    self.lv_attr_atk = {}
    self.lv_attr_def = {}
    self.army_num = {}
    for i = 1, MaxRarity, 1 do
        temp = row:getValue("lv_attr_atk" .. i) or 0
        if temp ~= 0 then
            self.lv_attr_atk[i] = temp
        end

        temp = row:getValue("lv_attr_def" .. i) or 0
        if temp ~= 0 then
            self.lv_attr_def[i] = temp
        end

        temp = row:getValue("army_num" .. i) or 0
        if temp ~= 0 then
            self.army_num[i] = temp
        end
    end
    self.break_require = row:getValue("break_require") or 0
    self.break_require_rank = row:getValue("break_require_rank") or 0
    self.break_require_base = row:getValue("break_require_base") or 0
end

--获取升级的经验值
function HeroLevelUpTemplate:GetExp()
    local season = SeasonUtil.GetSeason() or 0
    return self.exp_[season] or self.exp
end

--通过品质获取攻击力
function HeroLevelUpTemplate:GetAtk(rarity)
    return self.lv_attr_atk[rarity] or 0
end

--通过品质获取攻击力
function HeroLevelUpTemplate:GetDef(rarity)
    return self.lv_attr_def[rarity] or 0
end

--通过品质获取带兵量
function HeroLevelUpTemplate:GetArmyNum(rarity)
    return self.army_num[rarity] or 0
end

return HeroLevelUpTemplate