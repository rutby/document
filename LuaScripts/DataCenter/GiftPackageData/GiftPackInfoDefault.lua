---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 6/22/21 5:18 PM
---
local GiftPackInfoBase = require("DataCenter.GiftPackageData.GiftPackInfoBase")

---@class GiftPackInfoDefault : GiftPackInfoBase 默认礼包信息
local GiftPackInfoDefault = BaseClass("GiftPackInfoDefault", GiftPackInfoBase)
local M = GiftPackInfoDefault

function M:__init()
    GiftPackInfoBase.__init(self)
    self._itemsParsed = false
end

---礼包包含的道具列表
function M:getItems()
    self:_tryParseItems()
    return self._items
end

---根据索引查找道具
---@param index number
function M:getItem(index)
    self:_tryParseItems()
    if self._items == nil or index > #self._items then
        return nil
    end
    return self._items[index]
end

---礼包包含的组合礼包列表
---@return
function M:getCombs()
    self:_tryParseItems()
    return self._combItems
end

---根据索引查找组合礼包列表
---@param index number
function M:getComb(index)
    self:_tryParseItems()
    if self._combItems == nil or index > #self._combItems then
        return nil
    end
    return self._combItems[index]
end

function M:hasComb()
    return self._combItems and #self._combItems > 0
end

function M:_tryParseItems()
    if self._itemsParsed then
        return
    end

    self._itemsParsed = true
    -- 礼包包含的道具列表需要解析，所以用个变量存下来
    self._items = {}

    -- serverData 报空 临时加一个判空 可能是更新服务器数据时出错
    -- 理论上来说 severData 不可能为空 除非引用的数据被其他地方删除了
    -- serverData 唯一被释放的时机是 Init 也就是只有 ReloadGame 时才会被清理
    -- 报空堆栈是由 Timer 触发
    -- 断线重连测试之后确实是断线重练的原因，
    -- 系统问题，只能先在这里加一下报空检查，不过意义不大，后面的某些数据还是会有异常

    if self._serverData == nil then
        logErrorWithTag("GiftPackInfoDefault", "Server data null")
        return
    end

    self:_parseAllianceGift(self._items,self._serverData.giftData) --giftData 联盟礼包
    self:_parseItems(self._items, self._serverData.item_use) -- item_use字段
    self._parseHeroes(self._items, self._serverData.hero) -- hero字段
    self:_parseItems(self._items, self._serverData.item) -- item字段
    self._combItems = {} --组合礼包
    self:_parseCombItems(self._combItems, self._serverData.item_combine, self._serverData.hero_combine)
end

function M:_parseItems(t, data)
    if string.IsNullOrEmpty(data) then
        return
    end
    --local DataTable = GameEntry.Table
    local arr1 = string.split(data, '|')
    for _, v in ipairs(arr1) do
        if not string.IsNullOrEmpty(v) then
            local arr2 = string.split(v, ';')
            if #arr2 == 2 then
                -- 校验下，查表不存在的id，不显示了
                local id = arr2[1]
                local config = CS.LF.LuaHelper.Table:GetDataRow(TableName.Goods, id);
                if config then
                    table.insert(t, { id = id, count = tonumber(arr2[2]), rewardType = RewardType.GOODS })
                end
            end
        end
    end
end

function M._parseHeroes(t, data)
    if string.IsNullOrEmpty(data) then
        return
    end

    --local DataTable = GameEntry.Table
    local arr1 = string.split(data, '|')
    for _, v in ipairs(arr1) do
        if not string.IsNullOrEmpty(v) then
            local arr2 = string.split(v, ';')
            if #arr2 == 2 then
                -- 校验下，查表不存在的id，不显示了
                local id = arr2[1]
                local config = CS.LF.LuaHelper.Table:GetDataRow(TableName.Heroes, id);
                if config then
                    table.insert(t, { id = id, count = tonumber(arr2[2]), rewardType = RewardType.HERO })-- RewardType.HERO RewardType.GOODS
                end
            end
        end
    end
end

function M:_parseAllianceGift(t, data)
    if string.IsNullOrEmpty(data) then
        return
    end
    --local DataTable = GameEntry.Table
    local arr1 = string.split(data[1], '|')
    for _, v in ipairs(arr1) do
        if not string.IsNullOrEmpty(v) then
            local arr2 = string.split(v, ';')
            if #arr2 == 5 then
                -- 校验下，查表不存在的id，不显示了
                local name = arr2[2]
                --local config = CS.UIUtils.GetDataRowByStringKey(TableName.AllianceGiftGroup,"name",name)
                --if config then
                --    table.insert(t, { id = config:GetString("id"),name = name, tittle = arr2[3],count = tonumber(arr2[4]), rewardType = RewardType.ALLIANCE_REWARD })
                --end
                --local id = CS.UIUtils.GetAllianceGiftIdByName(name)
                --if id > 0 then
                --    table.insert(t, { id = id,name = name, tittle = arr2[3],count = tonumber(arr2[4]), rewardType = RewardType.ALLIANCE_REWARD })
                --end
            end
        end
    end
end

--- 解析组合礼包
---
function M:_parseCombItems(t, itemData, heroData)

    --组合礼包可能不存在，所以没有不做任何处理
    if string.IsNullOrEmpty(itemData) and string.IsNullOrEmpty(heroData) then
        return
    end

    if string.IsNullOrEmpty(itemData) and not string.IsNullOrEmpty(heroData) then
        printLog("Error", "<color=#ff0000>------------_____ Combine data error ______---------</color>")
        return
    end

    if not string.IsNullOrEmpty(itemData) and string.IsNullOrEmpty(heroData) then
        printLog("Error", "<color=#ff0000>------------_____ Combine data error ______---------</color>")
        return
    end

    local itemPacks = string.split(itemData, '@')
    local herosPacks = string.split(heroData, '@')

    if #itemPacks ~= #herosPacks then
        printLog("Error", "<color=#ff0000>------------_____ Combine data error ______---------</color>")
        return
    end

    for i, v in ipairs(itemPacks) do

        local arrItems = {}
        --为 N 代表没有
        if herosPacks[i] ~= "N" then
            self._parseHeroes(arrItems, herosPacks[i])
        end

        if v ~= "N" then
            self:_parseItems(arrItems, v)
        end

        if arrItems ~= nil and #arrItems > 0 then
            table.insert(t, arrItems)
        end
    end
end


--- 是否是需要特殊表现的礼包
--- 由 exchange 表内 showtype 66 决定
---@param id string
---@return boolean isSpecial
function M:isSpecialShowHero(id)
    self:tryParseSpecialShowHeros()

    if self.specialHeros == nil or #self.specialHeros < 1 then
        return false
    end
    for _, v in ipairs(self.specialHeros) do
        if id == v then
            return true
        end
    end
    return false
end

function M:tryParseSpecialShowHeros()
    if self.specialHeros ~= nil then
        return
    end

    self.specialHeros = {}

    local info = self:getShowType("66")
    if not string.IsNullOrEmpty(info) then
        local arr = string.split(info, ',')
        if arr == nil or #arr < 1 then
            return
        end
        for _, v in ipairs(arr) do
            table.insert(self.specialHeros, v)
        end
    end
end

--- 是否是需要特殊表现的礼包
--- 由 exchange 表内 showtype 65 决定
---@param id string
---@return boolean isSpecial
function M:isSpecialShowItem(id)
    self:tryParseSpecialShowItems()

    if self.specialItems == nil or #self.specialItems < 1 then
        return false
    end
    for _, v in ipairs(self.specialItems) do
        if id == v then
            return true
        end
    end
    return false
end

function M:tryParseSpecialShowItems()
    if self.specialItems ~= nil then
        return
    end

    self.specialItems = {}

    local info = self:getShowType("65")
    if not string.IsNullOrEmpty(info) then
        local arr = string.split(info, ',')
        if arr == nil or #arr < 1 then
            return
        end
        for _, v in ipairs(arr) do
            table.insert(self.specialItems, v)
        end
    end
end

function M:dispose()
    self._itemsParsed = false
    self._items = nil
    self._combItems = nil
    self.specialHeros = nil
    self.specialItems = nil

    GiftPackInfoBase.dispose(self)
end

return M