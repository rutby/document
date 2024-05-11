---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/5/30 11:21
---RefreshCommonShopMessage


local UserHeroMedalShopBuy = BaseClass("UserHeroMedalShopBuy", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, medalShopId, id, num)
    base.OnCreate(self)
    self.sfsObj:PutInt("medalShopId", medalShopId)
    self.sfsObj:PutInt("id", id)
    self.sfsObj:PutInt("num", num)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        -- "medalShopId"		//int 英雄商店组id
		-- 	"id"				//int 商品id
		-- 	"buyTimes"			//int 已购买次数
		-- 	"resource"			//sfs obj 如果是消耗资源有该字段，用来同步剩余资源数量。
		-- 	"heroes"			//sfs arr  购买获得的英雄信息  可以参考"user.shop.buy.new"协议返回的"heroes"字段
        DataCenter.HeroMedalShopDataManager:UpdateMedalShopData(t['medalShopId'], t['id'], t['buyTimes'])

        -- 解析英雄数据 谈奖励弹窗
        if t.heroes and #t.heroes > 0 then
            local heroUuid = nil
            for i, v in ipairs(t.heroes) do
                v.type = RewardType.HERO
                v.value = {heroId = v.heroId,uuid = v.uuid,num = 1}
                if(heroUuid == nil) then
                    heroUuid = v.uuid
                end
                local hero = v
                if hero ~= nil then
                    local uuid = hero["uuid"]
                    local power = 0
                    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
                    if heroData ~= nil then
                        power = HeroUtils.GetHeroPower(heroData)
                    end
                    DataCenter.HeroDataManager:UpdateOneHero(hero)
                    heroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
                    if heroData ~= nil then
                        power = HeroUtils.GetHeroPower(heroData) - power
                    end
                    if power > 0 then
                        GoToUtil.ShowPower({power = power})
                    end
                end
            end 

            if heroUuid ~= nil and DataCenter.HeroDataManager:NeedShowNewHeroWindow(heroUuid) then
                UIManager:GetInstance():OpenWindow(UIWindowNames.UINewHero, heroUuid)
            end
            
            t.reward ={}
            t.reward = t.heroes
            DataCenter.RewardManager:ShowCommonReward(t)
            UIUtil.ShowTipsId(120120)
        else
            DataCenter.RewardManager:DealWithHeroOrPoster(t)
        end

        -- 如果有资源消耗 同步资源
        if t['resource'] then
            LuaEntry.Resource:UpdateResource(t["resource"])
        end

        -- 购买完同步界面道具数量
        EventManager:GetInstance():Broadcast(EventId.UpdateHeroMedalShopItem)
    end
end

UserHeroMedalShopBuy.OnCreate = OnCreate
UserHeroMedalShopBuy.HandleMessage = HandleMessage

return UserHeroMedalShopBuy
