local HeroMedalShopDataManager = BaseClass("HeroMedalShopDataManager")

local function __init(self)
    --[[
        "medalShopId"		//int 英雄商店组id
        "name"				//string  英雄组的名字
        "startTime"			//long 开始时间 单位毫秒
        "endTime"			//long 结束时间 单位毫秒
        "itemArr"			//sfs arr 该组里可兑换的英雄商品
            "id"			//int 商品id
            "goods_num"     //单次购买商品数量
            "currency"		//string 购买消耗 格式  costType + ";" + costId   costType=1时表示消耗资源，costId为资源类型。 2表示消耗道具，costId为道具id
            "currency_num"  //int 购买消耗数量
            "cycle_times"   //int 商品可购买次数上限 0表示无上限
            "order"         //int 商品排序
            "hero"          //string 英雄的Id
            "buyTimes"	    //int 已购买次数
    ]]
    self.medalShopArr = {}
    -- arr 通用奖励格式  每日免费奖励
    self.dailyReward = {}
    -- 每日免费奖励领取状态 0未领取 1已领取
    self.dailyRewardState = 1
    self.storageConfirmFlag = false
end

local function __delete(self)
    self.medalShopArr = nil
    self.dailyReward = nil
    self.dailyRewardState = nil
end

local function SetMedalShopData(self, dataArr, dailyReward, dailyRewardState)
    if(dataArr ~= nil) then
        self.medalShopArr = dataArr
        local now = UITimeManager:GetInstance():GetServerTime()
        table.sort(self.medalShopArr, function(a, b)
            local aOpen = now - a.startTime > 0
            local bOpen = now - b.startTime > 0
            if bOpen == true and aOpen == false then
                --开放的优先在前面
                return false
            elseif bOpen == true and aOpen == true then
                return a.startTime > b.startTime
            elseif bOpen == false and aOpen == false then
                return a.startTime < b.startTime
            else
                return true
            end
        end)
    end
    if(dailyReward ~= nil) then
        self.dailyReward = dailyReward
    end
    if(dailyRewardState ~= nil) then
        self.dailyRewardState = dailyRewardState
    end
end

local function UpdateMedalShopData(self, medalShopId, id, buyTimes)
    if buyTimes == nil then
        -- 容错
        return
    end
    for _, v in pairs(self.medalShopArr) do
        if v.medalShopId == medalShopId then
            for _, v2 in pairs(v.itemArr) do
                if v2.id == id then
                    v2.buyTimes = buyTimes
                end
            end
        end
    end
end

local function updateDailyRewardState(self, dailyRewardState)
    if dailyRewardState == nil then
        return
    end

    self.dailyRewardState = dailyRewardState
end

local function GetMedalShopArr(self)
    return self.medalShopArr
end

-- 是否可以显示英雄勋章建筑气泡
local function GetCanShowHeroMedalBubble(self)
    -- 判断开启等级
    --大本等级s
	local k2 = LuaEntry.DataConfig:TryGetStr("free_heroes", "k2")
	if string.IsNullOrEmpty(k2) then
		return false
	end
	local vec = string.split(k2, ";")
	local mainLv = DataCenter.BuildManager.MainLv
	if table.count(vec) < 6 then
		return false 
	end

	return mainLv >= toInt(vec[6]) and self.dailyRewardState == 0
end

local function DailyReward(self)
    return self.dailyReward
end

local function GetDailyReward(self)
    SFSNetwork.SendMessage(MsgDefines.ReceiveHeroMedalShopDailyReward)
end

-- 请求英雄勋章商店数据
local function OnRequestData(self)
    SFSNetwork.SendMessage(MsgDefines.GetHeroMedalShopInfoCmd)
end

-- 在英雄勋章商店里面购买某个物品
local function OnBuyHeroDedalShopItem(self, param)
    local medalShopId = param.medalShopId
    local id = param.id
    local num = param.num
    SFSNetwork.SendMessage(MsgDefines.UserHeroMedalShopBuy, medalShopId, id, num)
end

-- 是否今日不再弹出奖励溢出
local function SetStorageFullConfirmFlag(self, flag)
    self.storageConfirmFlag = flag
end

local function GetStorageFullConfirmFlag(self)
    return self.storageConfirmFlag
end

local function GetHeroMedalItemId(self)
    return 222021
end

HeroMedalShopDataManager.__init = __init
HeroMedalShopDataManager.__delete = __delete
HeroMedalShopDataManager.GetCanShowHeroMedalBubble = GetCanShowHeroMedalBubble
HeroMedalShopDataManager.GetMedalShopArr = GetMedalShopArr
HeroMedalShopDataManager.SetMedalShopData = SetMedalShopData
HeroMedalShopDataManager.OnRequestData = OnRequestData
HeroMedalShopDataManager.OnBuyHeroDedalShopItem = OnBuyHeroDedalShopItem
HeroMedalShopDataManager.UpdateMedalShopData = UpdateMedalShopData
HeroMedalShopDataManager.updateDailyRewardState = updateDailyRewardState
HeroMedalShopDataManager.GetDailyReward = GetDailyReward
HeroMedalShopDataManager.SetStorageFullConfirmFlag = SetStorageFullConfirmFlag
HeroMedalShopDataManager.GetStorageFullConfirmFlag = GetStorageFullConfirmFlag
HeroMedalShopDataManager.DailyReward = DailyReward
HeroMedalShopDataManager.GetHeroMedalItemId = GetHeroMedalItemId

return HeroMedalShopDataManager
