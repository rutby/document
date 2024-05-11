---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 6/22/21 5:17 PM
---
local GiftPackInfoBase = BaseClass("GiftPackInfoBase")
local M = GiftPackInfoBase
local Timer = CS.GameEntry.Timer
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization

function M:__init()
    self._serverData = nil -- 服务器传过来的礼包数据
    self._showTypeParsed = false
    self._weekPopupParsed = false
    self._chooseIndexParsed = false
    self._combDescParsed = false
    self._combDescs = nil
    self._packageDiscountTips = {}
    self._chooseIndex = -1
end

---更新数据
---@param data table
function M:update(data)
    if data == nil then
        logErrorWithTag("GiftPackInfoBase", "Server data null")
    end
    self._serverData = data
    self._showTypeParsed = false
    self._weekPopupParsed = false
    self._chooseIndexParsed = false
    self._packageDiscountTips = nil
    self._combDescParsed = false
    self._combDescs = nil
    self._chooseIndex = -1
end

---礼包ID
function M:getID()
    return self._serverData and self._serverData.id or "-1"
end

---礼包类型
---@return GiftPackType
function M:getType()
    -- 礼包类型因为传过来的是string，需要转换类型，所以用个变量存下来
    if self._type == nil then
        self._type = self._serverData and tonumber(self._serverData.type) or GiftPackType.Unknown
    end

    return self._type
end

---礼包名称（多语言id）
function M:getName()
    return self._serverData and self._serverData.name or ""
end

function M:getSubName()
    return self._serverData and self._serverData.sub_name or ""
end

function M:GetSubNameTxt()
    local desc = self:getSubName()
    if string.contains(desc, '|') then
        local arr = string.split(desc, '|')
        local paramArray = string.split(arr[2], "#")
        local args = {}
        for _, p in ipairs(paramArray) do
            if string.startswith(p, "$") then
                table.insert(args, Localization:GetString(string.sub(p, 2)))
            else
                table.insert(args, p)
            end
        end
        return Localization:GetString(arr[1], table.unpack(args))
    else
        return Localization:GetString(desc)
    end
end

function M:hasSubName()
    return not string.IsNullOrEmpty(self:getSubName())
end

---礼包名称 (实际名称)
function M:getNameText()
    local name = self:getName()
    if string.contains(name, '|') then
        local arr = string.split(name, '|')
        return Localization:GetString(arr[1], arr[2])
    else
        return Localization:GetString(name)
    end
end

---礼包描述（多语言id）
function M:getDescription()
    return self._serverData and self._serverData.description or ""
end

---礼包条表现
function M:getPopupImageMini()
    return self._serverData and self._serverData.popup_image_mini or ""
end

function M:GetPopupImageMiniBand()
    return self._serverData and self._serverData.popup_image_mini_band or ""
end

function M:GetDiscountTips()
    local retTb = {}
    if self._serverData and self._serverData.image_show then
        local discountTb = string.split(self._serverData.image_show, "|")
        for i, v in ipairs(discountTb) do
            local type_dialog = string.split(v, ";")
            local tempK = tonumber(type_dialog[1])
            if tempK == 4 then
                local arrParams = string.split(type_dialog[2], "@")
                local arrItems = {}
                for m, n in ipairs(arrParams) do
                    local itemParam = string.split(n, "_")
                    local pos = tonumber(itemParam[1])
                    local temp = {}
                    temp.itemId = itemParam[2]
                    temp.count = itemParam[3]
                    temp.rewardType = RewardType.GOODS
                    arrItems[pos] = temp
                end
                retTb[tempK] = arrItems
            elseif tempK == 5 then
                retTb[tempK] = tonumber(type_dialog[2]) or 0
            else
                retTb[tempK] = ""
                if #type_dialog == 2 then
                    local dialog_param = string.split(type_dialog[2], "@")
                    if #dialog_param == 2 then
                        local params = string.split(dialog_param[2], "_")
                        retTb[tempK] = Localization:GetString(dialog_param[1], table.unpack(params))
                    else
                        retTb[tempK] = Localization:GetString(dialog_param[1])
                    end
                end
            end
        end
    end
    return retTb
end

--UIResourceBag界面用的礼包图
function M:getPopupImageB()
    return self._serverData and self._serverData.popup_image_b or ""
end

---目前用来确定 RobotPack 的礼包板子，即预制体名字（策划：扬骋）
---最新用途：弹出礼包的背景组参数
---最新用途new：滑动礼包的背景
function M:getPopupImageH()
    return self._serverData and self._serverData.popup_image_h or ""
end

function M:getDescText()
    self:tryParseCombDesc()

    local index = self:getChooseIndex()
    if index > #self._combDescs then
        index = 1
    end
    local desc = self._combDescs[index]
    if string.contains(desc, '|') then
        local arr = string.split(desc, '|')
        local paramArray = string.split(arr[2], "#")
        local args = {}
        for _, p in ipairs(paramArray) do
            if string.startswith(p, "$") then
                table.insert(args, Localization:GetString(string.sub(p, 2)))
            else
                table.insert(args, p)
            end
        end
        return Localization:GetString(arr[1], table.unpack(args))
    else
        return Localization:GetString(desc)
    end
end

function M:tryParseCombDesc()
    if self._combDescParsed then
        return
    end

    self._combDescParsed = true

    local desc = self:getDescription()
    local arr = string.split(desc, '@')
    self._combDescs = {}
    for _, v in ipairs(arr) do
        table.insert(self._combDescs, v)
    end
end

---礼包表现 （UI表现: 弹窗与Icon)
---@return string
function M:getUIKey()
    return self._serverData and self._serverData.popup_image or ""
end

function M:getQuality()
    return self._serverData and self._serverData.image_mini_quality or 0
end

---礼包md5值
function M:getMD5()
    return self._serverData and self._serverData.md5_v3 or ""
end

function M:getTimeType()
    return self._serverData and self._serverData.time_type or -1
end

---开始时间（毫秒）
function M:getStartTime()
    return self._serverData and self._serverData.start or -1
end

---结束时间（毫秒）
function M:getEndTime()
    return self._serverData and self._serverData["end"] or -1 -- lua中end是关键字，所以这里用key取值
end

---倒计时（毫秒）
function M:getCountdown()

    local serverTime = Timer:GetServerTime()
    local startTime = self:getStartTime()
    local endTime = self:getEndTime()
    local timeType = self:getTimeType()

    if timeType == 1 then
        --- 1: 倒计时即结束时间减当前时间
        return endTime - serverTime
    elseif timeType == 2 or timeType == 6 then
        --- 2: 在时间段内即有效
        --- 倒计时为假的 
        --- 在有效时间段内根据配置的时间段无限循环

        if serverTime > endTime or serverTime < startTime then
            return -1
        end

        local duration = self:getParaTime() * 1000
        if duration <= 0 then
            return -1
        end

        local i = 1
        while true do
            local tEndTime = startTime + i * duration
            if serverTime < tEndTime then
                if tEndTime > endTime then
                    tEndTime = endTime
                end
                return tEndTime - serverTime
            end
            i = i + 1
        end

    elseif timeType == 3 then
        --- 3: 由条件触发 
        --- 定时消失
        --- 前台处理方式应该和 1 一样
        return endTime - serverTime
    elseif timeType == 7 then
        return endTime - serverTime
    else
        return endTime - serverTime
    end
end

--- 获取 time 字段的值 (秒)
--- @return number
function M:getParaTime()
    return self._serverData and self._serverData.time or 0
end

---礼包时间是否合法
function M:isTimeValid()
    local serverTime = Timer:GetServerTime()
    return self:getStartTime() <= serverTime and serverTime <= self:getEndTime() and self:getCountdown() > 0
end

---条件排序规则
function M:getConditionPopup()
    return self._serverData and self._serverData["condition-popup"] or 0 -- 服务器传过来的字段命名比较奇怪，所以这里用key取值
end

---排序规则（越大越靠前）
function M:getPopup()

    local weekDay = Timer:GetServerWeekDay()

    local result
    if self:hasWeekPopup(weekDay) then
        result = self:getWeekPopup(weekDay)
    else
        -- 因为传过来的是string，需要转换类型，所以用个变量存下来
        if self._popup == nil then
            self._popup = self._serverData and tonumber(self._serverData.popup) or 0
        end

        result = self._popup
    end

    return result
end

--- 周排序 根据所在周几获取排序 优先级高于Popup字段
---@param weekDay number
function M:getWeekPopup(weekDay)
    self:tryParseWeekPopup()
    local popup = self._weekPopupArr[weekDay]
    if popup ~= nil then
        return popup
    else
        return -1
    end
end

function M:hasWeekPopup(weekDay)
    self:tryParseWeekPopup()
    local popup = self._weekPopupArr[weekDay]
    if popup ~= nil then
        return true
    else
        return false
    end
end

function M:tryParseWeekPopup()
    if self._weekPopupParsed then
        return
    end

    self._weekPopupParsed = true;
    self._weekPopupArr = {}
    local str = self._serverData.popup_week
    if string.IsNullOrEmpty(str) then
        return
    end
    local arr = string.split(str, '|')
    for _, v in ipairs(arr) do
        if not string.IsNullOrEmpty(v) then
            local arr1 = string.split(v, ';')
            if #arr1 ~= 2 then
                printError("Week popup error")
            else
                self:onParseWeekPopupItem(tonumber(arr1[1]), tonumber(arr1[2]))
            end
        end
    end
end

function M:onParseWeekPopupItem(k, v)
    self._weekPopupArr[k] = v
end

---是否购买过改礼包,比如那种限购一次的,有可能需要做展示使用
function M:isBought()
    return self._serverData and self._serverData.bought
end

---购买次数
function M:getBuyTimes()
    return self._serverData and self._serverData.buy_times or 0
end

---礼包给的钻石数量
function M:getDiamond()
    return self._serverData and self._serverData.gold_doller or 0
end

---礼包价格
function M:getPrice()
    return self._serverData and self._serverData.dollar or 0
end

---本地化后的价格描述
function M:getPriceText()
    if self.priceTxt == nil then
        local productId = self:getProductID()
        local price = self:getPrice()
        --self.priceTxt = CS.PayController.Instance:getDollarText(price, productId)
        self.priceTxt = DataCenter.PayManager:GetDollarText(price, productId)
    end
    return self.priceTxt
end

---打折百分比
function M:getPercent()
    return self._serverData and self._serverData.percent
end

---是否打折
function M:hasPercent()
    return self:getPercent() ~= nil
end

function M:getIsShow()
    return self._serverData and self._serverData.is_show
end

---是否是超值礼包
function M:isPremiumPack()
    return self:getIsShow() == nil or self:getIsShow() == "0" or self:getIsShow() == "4"
end

---是否是商城礼包
function M:isStorePack()
    return self:getIsShow() == "2"
end

function M:IsWeeklyPackage()
    local isShow = self:getIsShow()
    return isShow == "4"
end

function M:IsWeeklyPackageNew()
    local isShow = self:getIsShow()
    return isShow == "5"
end

function M:TryGetRechargeId()
    local isShow = self:getIsShow()
    if not string.IsNullOrEmpty(isShow) then
        local spls = string.split(isShow, ";")
        if #spls == 2 and spls[1] == "6" then
            return true, spls[2]
        end
    end
    return false
end

function M:IsHeroMedalPackage()
    return false
end

---是否是单屏礼包
function M:isRobotPack()
    local lineData = self:getRechargeLineData()
    return lineData ~= nil and lineData.type == WelfareTagType.RobotPack
end

-- 是否是存钱罐礼包
function M:isPiggyBankPack()
    local lineData = self:getRechargeLineData()
    return lineData ~= nil and lineData.type == WelfareTagType.PiggyBank
end

-- 是否是存钱罐礼包
function M:isEnergyBankPack()
    local lineData = self:getRechargeLineData()
    return lineData ~= nil and lineData.type == WelfareTagType.EnergyBank
end

-- 是否是通行证礼包
function M:isGrowthPlanPack()
    local lineData = self:getRechargeLineData()
    return lineData ~= nil and lineData.type == WelfareTagType.GrowthPlan
end

-- 是否是滑动礼包
function M:isScrollPack()
    local lineData = self:getRechargeLineData()
    return lineData ~= nil and lineData.type == WelfareTagType.ScrollPack
end

-- 是否是PVE关内礼包
function M:isPvePack()
    local lineData = self:getRechargeLineData()
    return lineData ~= nil and lineData.type == WelfareTagType.PvePack
end

---是否是某种类型的单屏礼包
function M:isRechargeId(rechargeId)
    if rechargeId == nil then
        return false
    end
    
    local lineData = self:getRechargeLineData()
    return lineData ~= nil and lineData:getValue("id") == rechargeId
end

function M:isHeroMonthCardPack()
    local lineData = self:getRechargeLineData()
    return lineData ~= nil and lineData.type == WelfareTagType.HeroMonthCardNew
end

---这里刘文要求 isShow 是 1 或 3 的都是特殊礼包
---但是pop界面只展示 isShow 为 1 的
---福利中心界面两种都展示  
function M:isSpecialPackCanInPop()

    ---vip 礼包特殊处理
    if self:getID() == "40001" then
        return CS.LF.LuaInterfaceCommon.IsVipUnlock(1) and self:getIsShow() == "1"
    end

    return self:getIsShow() == "1"
end

--- 用于UI显示用的一个临时变量
--- 不是从服务器数据来的
--- 临时放在这。。。
function M:setWillInPop(inPop)
    self.willInPop = inPop
end

function M:getInPop()
    return self.willInPop
end

--- 这里新增超值礼包 is_show 为 4
--- 在 Pop 窗口不显示
function M:isPremiumPackCanInPop()
    return self:getIsShow() ~= "4"
end

function M:getProductID()
    if CS.SDKManager.IS_UNITY_ANDROID() then
        return self._serverData and self._serverData.product_id_google
    elseif CS.SDKManager.IS_UNITY_IPHONE() then
        return self._serverData and self._serverData.product_id_ios
    end
end

function M:isFree()
    return self:getProductID() == "free"
end

function M:canGet()
    return self:getHasGetCount() < self:getBuyTimes()
end

--- 礼包已领取或购买次数
function M:getHasGetCount()
    return self._serverData and self._serverData.buys or 0
end

function M:getGroup()
    return ""
end

function M:getGiftData()
    return self._serverData and self._serverData.giftData or ""
end

---这个地方有一个show_type之后会是使用比较常见的一个参数，这个的参数配置为 5;2  表示大类型是5,小类型是2
---对于程序理解为 5 为资源类型  2表示钞票,有些地方需要展示指定的礼包列表,比如说在指定的界面只显示资源为5,所有的钞票礼包
---
---show_type的配置类型为  type;value|type2;value2,value3,value4
---@param mainType string
---@param subType string
---@return boolean
function M:isContainShowType(mainType, subType)
    self:tryParseShowType()
    if string.IsNullOrEmpty(mainType) and string.IsNullOrEmpty(subType) then
        return false
    end

    if string.IsNullOrEmpty(mainType) then
        return false
    end

    if string.IsNullOrEmpty(subType) then
        return self._showTypeArr and self._showTypeArr[mainType]
    else
        if self._showTypeArr and self._showTypeArr[mainType] then
            if tonumber( mainType) == 11 then
                local str = string.split(self._showTypeArr[mainType], '#')
                for i = 1 ,table.count(str) do
                    local resTypes = string.split(str[i], ',')
                    if resTypes[1] == subType then
                        return resTypes[2]
                    end
                end
                return false
            end
            local resTypes = string.split(self._showTypeArr[mainType], ',')
            for i, v in ipairs(resTypes) do
                if v == subType then
                    return true
                end
            end
        end
        --return self._showTypeArr and self._showTypeArr[mainType] and string.contains(self._showTypeArr[mainType], subType, false)
    end
    return false
end

---根据show_type字段进行具体内容解析
function M:tryParseShowType()
    if self._showTypeParsed then
        return
    end

    ---@type table<string, string>
    self._showTypeArr = {}

    self._showTypeParsed = true
    local showType = self._serverData and self._serverData.show_type or ""
    if string.IsNullOrEmpty(showType) then
        return
    end

    local arr = string.split(showType, '|')
    for _, v in ipairs(arr) do
        if not string.IsNullOrEmpty(v) then
            local arr1 = string.split(v, ';')
            if #arr1 == 2 then
                self:onParseShowTypeItem(arr1[1], arr1[2])
            end
        end
    end
end

---@param k string key
---@param v string value
function M:onParseShowTypeItem(k, v)
    self._showTypeArr[k] = v;
end

---@param type string key
---@return string show_type value
function M:getShowType(type)

    if string.IsNullOrEmpty(type) then
        return nil
    end

    self:tryParseShowType()

    if self._showTypeArr == nil then
        return nil
    end

    return self._showTypeArr[type]
end

function M:isDirectBuyCoin()
    return self:getShowType("14") ~= nil
end

function M:setTagID(value)
    self._tagID = value
end

function M:getTagID()
    return self._tagID
end

function M:getItemsStr()
    return self._serverData and self._serverData.item or ""
end

function M:getItem2Str()
    return self._serverData and self._serverData.item2 or ""
end

function M:getHeroesStr()
    return self._serverData and self._serverData.hero or ""
end

function M:getItemUse()
    return self._serverData and self._serverData.item_use or ""
end

function M:getResourceStr()
    return self._serverData and self._serverData.resource or ""
end

-- 联盟礼物  .这个地方返回的有可能是个table,这个如果出错了，需要修改
function M:getAllianceGift()
    return self._serverData and self._serverData.giftData or ""
end

--- 购买前设置组合礼包选择项
---@param value number index
function M:setChooseIndex(value)
    self._chooseIndex = value
end

--- 获取组合礼包选择的 index
function M:getChooseIndex()
    self:tryGetChooseIndexFromLocal()
    return self._chooseIndex
end

---获取礼包对应积分  累充活动开启时用
function M:getRechargePoint()
    local isCumulativeShow = DataCenter.CumulativeRechargeManager:CheckIsShow()
    local isPaidLotteryShow = DataCenter.PaidLotteryManager:CheckIfPaidLotteryOpen()
    local isKeepPayShow = DataCenter.KeepPayManager:IsOpen()
    local isShow = (isCumulativeShow or isPaidLotteryShow or isKeepPayShow)
    if isShow then
        return self._serverData and self._serverData.recharge_point  or 0
    end
    return 0
end

--- 关闭页面时保存选择信息
function M:saveChooseInfo()
    Setting:SetInt("GIFT_PACK_COMBINE" .. self:getID(), self:getChooseIndex())
end

--- 从本地读取上次礼包选择的 index
--- 默认为 1 选择后记录到本地
---
function M:tryGetChooseIndexFromLocal()
    -- 若已经赋值过说明已经设置过 组合选项 就不从本地读取了
    if self._chooseIndex > 0 then
        self._chooseIndexParsed = true
        return
    end

    if self._chooseIndexParsed then
        return
    end
    self._chooseIndex = Setting:GetInt("GIFT_PACK_COMBINE" .. self:getID(), 1);
    self._chooseIndexParsed = true
end

function M:dispose()
    self._serverData = nil
    self._showTypeParsed = false
    self._showTypeArr = nil
    self._weekPopupParsed = false
    self._weekPopupArr = nil
    self._chooseIndexParsed = false
    self._combDescParsed = false
    self._combDescs = nil
    self._chooseIndex = -1
end

function M:toJson(...)
    local rapidjson = require('Common.dkjson')

    -- TODO 抽离出是否包含组合礼包的接口
    -- 添加组合礼包选择项信息
    if self._serverData.item_combine ~= nil then
        if self._chooseIndex == nil or self._chooseIndex < 0 then
            --printError("<color=#ff0000>------------_____ Combine pack choose index error ______---------</color>")
            self._chooseIndex = 1
        end
        self._serverData["chooseItem"] = string.split(self._serverData.item_combine, '@')[self._chooseIndex]
        self._serverData["chooseHero"] = string.split(self._serverData.hero_combine, '@')[self._chooseIndex]
    end

    -- 免费礼包由 Product_id 决定
    if self:isFree() then
        self._serverData["isFree"] = true
    end

    local jsonData = rapidjson.encode(self._serverData)
    return jsonData
end

function M:toJsonForGiftBar(...)
    local info = {}
    info["name"] = self:getNameText()
    info["desc"] = self:getDescText()
    info["countDown"] = self:getCountdown()
    info["priceText"] = self:getPriceText()
    info["id"] = self:getID()
    info["giftPackBarUI"] = self:getPopupImageMini()
    info["diamond"] = self:getDiamond()

    local rapidjson = require('Common.dkjson')
    local jsonData = rapidjson.encode(info)
    return jsonData
end

---获取该礼包在 recharge 表中的 lineData
function M:getRechargeLineData()
    local tempId = self:getID()
    local line = GiftPackageData.GetRechargeDataByPackageId(tempId)
    return line
    
    --local line = nil
    --LocalController:instance():visitTable("recharge", function(_, lineData)
    --    if line == nil then
    --        local strs = string.split(lineData:getValue("para1"), ";")
    --        for i, str in ipairs(strs) do
    --            if self:getID() == str then
    --                line = {}
    --                for k, v in pairs(lineData) do
    --                    line[k] = v
    --                end
    --                break
    --            end
    --        end
    --    end
    --end)
    --return line
end

function M:GetRewardList()
    local listParam = {}
    
    local diamondWorth = tonumber(self:getDiamond())
    if diamondWorth and diamondWorth > 0 then
        local param = {}
        param.rewardType = RewardType.GOLD
        param.count = diamondWorth
        table.insert(listParam,param)
    end

    -- 英雄
    local heroStr = self:getHeroesStr()
    if (not string.IsNullOrEmpty(heroStr)) then
        local arr = string.split(heroStr, ";")
        if (#arr == 2) then
            local param = {}-- UIGiftPackageCell.Param.New()
            param.rewardType = RewardType.HERO
            param.itemId = arr[1]
            param.count = arr[2]
            table.insert(listParam,param)
        end
    end

    -- 普通道具
    local str = self:getItemsStr()
    local _item_use = self:getItemUse()
    if _item_use ~= nil and _item_use ~= "" then
        str = _item_use .. "|" .. str
    end

    local arrMiddle = string.split(str,"|")
    if arrMiddle ~= nil and #arrMiddle > 0 then
        for k,v in ipairs(arrMiddle) do
            local arr = string.split(v,";")
            if arr[1] ~= "" then
                local param = {}-- UIGiftPackageCell.Param.New()
                param.rewardType = RewardType.GOODS
                param.itemId = arr[1]
                local numCount = tonumber(arr[2])
                param.count = string.GetFormattedSeperatorNum(numCount)
                table.insert(listParam,param)
            end
        end
    end

    local resourceStr = self:getResourceStr()
    if resourceStr and resourceStr ~= "" then
        local resource = string.split(resourceStr,";")
        local param = {}
        param.rewardType = ResTypeToReward[tonumber(resource[1])]
        param.count = string.GetFormattedSeperatorNum(tonumber(resource[2]))
        table.insert(listParam,2,param)
    end

    local temp = self:GetDiscountTips()
    if temp then
        if temp[4] then
            local replace = temp[4]
            for i ,v in pairs(replace) do
                if listParam[i] then
                    listParam[i] = v
                end
            end
        end
    end

    return listParam
end

return M