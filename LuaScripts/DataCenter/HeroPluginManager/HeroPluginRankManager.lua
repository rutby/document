--- Created by shimin.
--- DateTime: 2023/6/1 18:39
--- 英雄插件管理器

local HeroPluginRankManager = BaseClass("HeroPluginRankManager")
local HeroPluginRankInfo = require "DataCenter.HeroPluginManager.HeroPluginRankInfo"


function HeroPluginRankManager:__init()
    self.rankList = {}--插件排行榜
    self.selfRank = nil--自己的排行
end

function HeroPluginRankManager:__delete()
    self.rankList = {}--插件排行榜
    self.selfRank = nil--自己的排行
end

function HeroPluginRankManager:Startup()
end

--发送获取插件排行榜
function HeroPluginRankManager:SendGetPluginRank()
    SFSNetwork.SendMessage(MsgDefines.GetPluginRank)
end

--获取插件排行榜回调
function HeroPluginRankManager:GetPluginRankHandle(message)
    local errCode = message["errorCode"]
    if errCode == nil then
        self.rankList = {}
        self.selfRank = nil
        local uid = LuaEntry.Player.uid
        local rankList = message["rankList"]
        if rankList ~= nil then
            for k, v in pairs(rankList) do
                local info = HeroPluginRankInfo.New()
                info:UpdateInfo(v)
                self.rankList[info.rank] = info
                if info.uid == uid and (self.selfRank == nil or self.selfRank.rank > info.rank) then
                    self.selfRank = info
                end
            end
        end
      
        EventManager:GetInstance():Broadcast(EventId.RefreshHeroPluginRank)
    else
        UIUtil.ShowTipsId(errCode)
    end
end

--获取插件排行榜
function HeroPluginRankManager:GetRankList()
    return self.rankList
end

--获取插件排行榜
function HeroPluginRankManager:GetSelfRank()
    return self.selfRank
end

return HeroPluginRankManager
