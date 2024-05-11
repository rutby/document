---
--- Created by shimin
--- DateTime: 2021/7/5 19:07
---
local UavDialogueTemplate = BaseClass("UavDialogueTemplate")

local function __init(self)
    self.id = 0 --id
    self.building = {} --建筑条件
    self.dialog = ""--对话多语言
    self.type = BuildQueueTalkShowType.Free--触发方式
    self.dialog_cd= 0 --同一对话间隔时间
    self.public_cd= 0 --其他对话间隔时间
    self.order= 0 --优先级
end

local function __delete(self)
    self.id = nil
    self.building = nil
    self.dialog = nil
    self.type = nil
    self.dialog_cd= nil
    self.public_cd= nil
    self.order= nil
end

local function InitData(self,row)
    if row ==nil then
        return
    end
    self.id = row:getValue("id")
    self.dialog = row:getValue("dialog")
    self.type = row:getValue("type")
    self.dialog_cd = row:getValue("dialog_cd")
    self.public_cd = row:getValue("public_cd")
    self.order = row:getValue("order")
    local building = row:getValue("building")
    if building ~= nil and building ~= "" then
        local sub = string.split(building,";")
        for k,v in ipairs(sub) do
            local sub2 = string.split(building,",")
            if table.count(sub2) > 2 then
                local need = {}
                need.buildId = tonumber(sub2[1])
                need.minLevel = tonumber(sub2[2])
                need.maxLevel = tonumber(sub2[3])
                table.insert(self.building,need)
            end
        end
    end
end

UavDialogueTemplate.__init = __init
UavDialogueTemplate.__delete = __delete
UavDialogueTemplate.InitData = InitData

return UavDialogueTemplate