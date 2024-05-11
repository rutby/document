---
--- Created by zzl
--- DateTime: 
---
local ActBattlePassTemplate = BaseClass("ActBattlePassTemplate")
local Localization = CS.GameEntry.Localization
local function __init(self)
    self.id = 0             
    self.actId = 0          --对应活动ID
    self.level = 0          --通行证等级
    self.levelUpExp = 0    --升级所需经验
    self.highReward = ""
    self.pay_item = ""
    self.free_item = ""
end

local function __delete(self)
    self.id = nil
    self.actId = nil
    self.level = nil
    self.levelUpExp = nil
    self.highReward = nil
    self.pay_item = nil
    self.free_item = nil
end

local function InitData(self,row)
    if row ==nil then
        return
    end
    self.id = row:getValue("id")
    self.actId = row:getValue("activity_panel_Id")
    self.level = row:getValue("level")
    self.levelUpExp = row:getValue("levelup_exp")
    self.highReward = tonumber(row:getValue("highlight_reward"))
    self.free_item = row:getValue("free_item")
    self.pay_item = row:getValue("pay_item")
end



ActBattlePassTemplate.__init = __init
ActBattlePassTemplate.__delete = __delete
ActBattlePassTemplate.InitData = InitData
return ActBattlePassTemplate