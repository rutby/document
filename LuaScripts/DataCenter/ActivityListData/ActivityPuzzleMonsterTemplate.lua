--- Created by shimin
--- DateTime: 2023/9/25 16:23
---

local ActivityPuzzleMonsterTemplate = BaseClass("ActivityPuzzleMonsterTemplate")
local Localization = CS.GameEntry.Localization

function ActivityPuzzleMonsterTemplate:__init()
    self.id = 0
    self.name = 0
    self.monsterId = 0
    self.consumeType = ConsumeType.ConsumeType_Nil
    self.reward_show = {}
    self.consumeId = 0
    self.consumeNum = 0
    self.color = ""
    self.unlock = ""
    self.reward_detail = {}
    self.type = PuzzleMonsterType.Activity
    self.unlock_monster = 0--解锁需要的前置id,为0则不需要
end

function ActivityPuzzleMonsterTemplate:__delete()
    self.id = 0
    self.name = 0
    self.monsterId = 0
    self.consumeType = ConsumeType.ConsumeType_Nil
    self.reward_show = {}
    self.consumeId = 0
    self.consumeNum = 0
    self.color = ""
    self.unlock = ""
    self.reward_detail = {}
    self.type = PuzzleMonsterType.Activity
    self.unlock_monster = 0--解锁需要的前置id,为0则不需要
end

function ActivityPuzzleMonsterTemplate:InitData(row)
    self.id = row:getValue("id")
    self.name = row:getValue("name")
    self.monsterId = row:getValue("monster_id")
    self.reward_show = {}
    local temp = row:getValue("reward_show") or ""
    if temp ~= "" then
        local spl = string.split_ss_array(temp, "|")
        for k, v in ipairs(spl) do
            local spl1 = string.split_ii_array(v, ";")
            if spl1[2] ~= nil then
                local param = {}
                param.itemId = spl1[1]
                param.rewardType = spl1[2]
                param.count = 1
                table.insert(self.reward_show, param)
            end
        end
    end
    self.reward_detail = {}
    temp = row:getValue("reward_detail") or ""
    if temp ~= "" then
        local spl = string.split_ss_array(temp, "|")
        for k, v in ipairs(spl) do
            local spl1 = string.split_ii_array(v, ";")
            if spl1[3] ~= nil then
                local param = {}
                param.itemId = spl1[1]
                param.rewardType = spl1[2]
                param.count = spl1[3]
                table.insert(self.reward_detail, param)
            end
        end
    end

    self.color = row:getValue("color")
    self.unlock = toInt(row:getValue("unlock")) or 0
    temp = row:getValue("consume") or ""
    if string.IsNullOrEmpty(temp) then
        self.consumeType = ConsumeType.ConsumeType_Nil
    else
        local vec = string.split_ii_array(temp, ";")
        if vec[3] ~= nil then
            self.consumeType = vec[1]
            self.consumeId = vec[2]
            self.consumeNum = vec[3]
        else
            self.consumeType = ConsumeType.ConsumeType_Nil
        end
    end
    self.type = row:getValue("type") or PuzzleMonsterType.Activity
    self.unlock_monster = toInt(row:getValue("unlock_monster")) or 0
end

function ActivityPuzzleMonsterTemplate:GetColorName()
    if self.color == "UIpuzzle_green" then
        return string.format(TextColorStr, "#94e138", Localization:GetString(self.name))
    elseif self.color == "UIpuzzle_yellow" then
        return string.format(TextColorStr, "#5fa3ed", Localization:GetString(self.name))
    elseif self.color == "UIpuzzle_white" then
        return Localization:GetString(self.name)
    elseif self.color == "UIpuzzle_purple" then
        return string.format(TextColorStr, "#f265ff", Localization:GetString(self.name))
    elseif self.color == "UIpuzzle_orange" then
        return string.format(TextColorStr, "#ffde46", Localization:GetString(self.name))
    end
    return Localization:GetString(self.name)
end

return ActivityPuzzleMonsterTemplate