--- Created by shimin.
--- DateTime: 2023/7/19 19:16
--- 英雄勋章兑换管理器

local HeroMedalRedemptionManager = BaseClass("HeroMedalRedemptionManager")
local OpenSeasonId = 4

function HeroMedalRedemptionManager:__init()
    self.heroPageNum = nil--英雄海报兑换代币数量<rarity, <quality, num>>
    self.metalNum = nil--勋章兑换代币数量<color, num>
end

function HeroMedalRedemptionManager:__delete()
    self.heroPageNum = nil--英雄海报兑换代币数量<rarity, <quality, num>>
    self.metalNum = nil--勋章兑换代币数量<color, num>
end

function HeroMedalRedemptionManager:Startup()
end

--发送英雄海报兑换代币
function HeroMedalRedemptionManager:SendHeroPosterExchangeToken(heroArr)
    SFSNetwork.SendMessage(MsgDefines.HeroPosterExchangeToken, {heroArr = heroArr})
end

--英雄海报兑换代币回调
function HeroMedalRedemptionManager:HeroPosterExchangeTokenHandle(message)
    local errCode = message["errorCode"]
    if errCode == nil then
        local heroArr = message["heroArr"]
        if heroArr ~= nil then
            DataCenter.HeroDataManager:RemoveHeroes(heroArr)
        end
        EventManager:GetInstance():Broadcast(EventId.PosterExchangeSuccess)
        UIUtil.ShowTipsId(GameDialogDefine.REDEMPTION_SUCCESS)
    else
        UIUtil.ShowTipsId(errCode)
    end
end

--发送英雄海报兑换代币
function HeroMedalRedemptionManager:SendHeroMedalExchangeToken(costGoods)
    SFSNetwork.SendMessage(MsgDefines.HeroMedalExchangeToken, {costGoods = costGoods})
end

--英雄勋章兑换代币回调
function HeroMedalRedemptionManager:HeroMedalExchangeTokenHandle(message)
    local errCode = message["errorCode"]
    if errCode == nil then
        EventManager:GetInstance():Broadcast(EventId.PosterExchangeSuccess)
        UIUtil.ShowTipsId(GameDialogDefine.REDEMPTION_SUCCESS)
    else
        UIUtil.ShowTipsId(errCode)
    end
end

--发送英雄海报兑换代币
function HeroMedalRedemptionManager:IsOpen()
    return DataCenter.HeroPluginManager:IsOpen()
end

--获取兑换物品id
function HeroMedalRedemptionManager:GetRedemptionItemId()
    return LuaEntry.DataConfig:TryGetNum("medal_redemption", "k3")
end

--获取海报兑换数量 quality 星级  rarity 稀有度 num 数量
function HeroMedalRedemptionManager:GetRedemptionNumByHeroPage(quality, rarity, num)
    local result = 0
    if self.heroPageNum == nil then
        self:InitHeroPageNum()
    end
    if self.heroPageNum[rarity] ~= nil and self.heroPageNum[rarity][quality] ~= nil then
        result = num * self.heroPageNum[rarity][quality]
    end
    return result
end

--初始化海报兑换关系
function HeroMedalRedemptionManager:InitHeroPageNum()
    self.heroPageNum = {}
    local temp = LuaEntry.DataConfig:TryGetStr("medal_redemption", "k1") or ""
    if temp ~= "" then
        local str = string.split_ss_array(temp, "|")
        for k, v in ipairs(str) do
            local str1 = string.split_ss_array(v, ";")
            if str1[2] ~= nil then
                self.heroPageNum[tonumber(str1[1])] = string.split_ii_array(str1[2], ",")
            end
        end
    end
end

--获取勋章兑换数量 color 稀有度 num 数量
function HeroMedalRedemptionManager:GetRedemptionNumByMetal(color, num)
    local result = 0
    if self.metalNum == nil then
        self:InitMetalNum()
    end
    if self.metalNum[color] ~= nil then
        result = num * self.metalNum[color]
    end
    return result
end

--初始化勋章兑换关系
function HeroMedalRedemptionManager:InitMetalNum()
    self.metalNum = {}
    local temp = LuaEntry.DataConfig:TryGetStr("medal_redemption", "k2") or ""
    if temp ~= "" then
        local str = string.split_ss_array(temp, "|")
        for k, v in ipairs(str) do
            local str1 = string.split_ii_array(v, ";")
            if str1[2] ~= nil then
                self.metalNum[str1[1]] = str1[2]
            end
        end
    end
end

return HeroMedalRedemptionManager
