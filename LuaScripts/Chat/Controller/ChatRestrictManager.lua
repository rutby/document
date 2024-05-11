--[[
	聊天被限制的一些操作管理 比如 屏蔽 和 禁言
]]

local ChatRestrictManager = BaseClass("ChatRestrictManager")
local ChatShieldInfo = require "Chat.Model.ChatShieldInfo"

function ChatRestrictManager:__init()
    self:resetData()
end 


function ChatRestrictManager:resetData()
      -- 屏蔽列表 存储屏蔽信息
    self.shieldInfoList          = {} 
     -- 禁言列表
    self.banNameList            = {}

    self.chatShieldMax          = 0
    
    self.shareGiveLikeList = {}--记录从游戏登录开始点赞的消息id及点赞时间
    self.shareGiveLikeAnim = {} --记录是否在做点赞动画
end

function ChatRestrictManager:SetGiveLikeMsgTime(type,timeStamp)
    self.shareGiveLikeList[type] = timeStamp
end

function ChatRestrictManager:GetGiveLikeMsgTime(type)
    if self.shareGiveLikeList[type]~=nil then
        return self.shareGiveLikeList[type]
    end
    return 0
end

function ChatRestrictManager:SetGiveLikeAnim(type,num)
    self.shareGiveLikeAnim[type] = num
end

function ChatRestrictManager:GetGiveLikeAnim(type)
    if self.shareGiveLikeAnim[type]~=nil then
        return self.shareGiveLikeAnim[type]
    end
    return 0
end
function ChatRestrictManager:GetMaxShield()
	return self.chatShieldMax
end

function ChatRestrictManager:GetShieldInfoList()
	return self.shieldInfoList
end

function ChatRestrictManager:releaseData()
   self:resetData()
end

function ChatRestrictManager:onServerInfo(data)
    self.shieldInfoList = {}
    self:SetChatShieldMax(LuaEntry.DataConfig:TryGetNum("chat_max", "k2"))
    if not table.IsNullOrEmpty(data["chatShield"]) then
		for _, v in ipairs(data["chatShield"]) do
			local shieldInfo = self:CreateChatShieldInfo()
			shieldInfo:onParseServerData(v)
			self:addShieldInfo(shieldInfo)
		end
	end
end
	
	
function ChatRestrictManager:CreateChatShieldInfo()
	return ChatShieldInfo.New()
end

--设置屏蔽的最大数量
function ChatRestrictManager:SetChatShieldMax(num)
    ChatPrint("chatShieldMax = %d",num)
    self.chatShieldMax = num
end

--是否到达屏蔽最大数
function ChatRestrictManager:isReachShieldLimit()
    return #self.shieldInfoList >= self.chatShieldMax
end

--添加屏蔽信息
function ChatRestrictManager:addShieldInfo(shieldInfo)
    table.insert(self.shieldInfoList,shieldInfo)
end

--通过uuid获取屏蔽信息
function ChatRestrictManager:getShieldInfoByUuid(uuid)
    for _, v in ipairs(self.shieldInfoList) do
        if v.uuid == uuid then 
            return v
        end 
    end 
    return nil
end

--添加禁言信息
function ChatRestrictManager:addBanList(uid)
    table.insert(self.banNameList,uid)
end

--移除玩家限制
function ChatRestrictManager:removeRestrictUser(uid,type)
    if type == RestrictType.BLOCK then 
        for i = 1, #self.shieldInfoList do 
            local shieldInfo = self.shieldInfoList[i]
            if shieldInfo.uid == uid then 
                table.remove(self.shieldInfoList,i)
                break
            end 
        end 
    elseif type == RestrictType.BAN then 
        table.removebyvalue(self.banNameList,uid)
    end
end

--玩家id 是否在限制列表
function ChatRestrictManager:isInRestrictList(uid,type)
     if type == RestrictType.BLOCK then     --屏蔽
        for i = 1, #self.shieldInfoList do 
            local shieldInfo = self.shieldInfoList[i]
            if shieldInfo.uid == uid then 
                return true
            end 
        end 
    elseif type == RestrictType.BAN then         --禁言
        if table.hasvalue(self.banNameList,uid) then 
            return true
        end 
    end
    return false;
end
function ChatRestrictManager:GetRestrictUuid(uid,type)
    if type == RestrictType.BLOCK then     --屏蔽
        for i = 1, #self.shieldInfoList do
            local shieldInfo = self.shieldInfoList[i]
            if shieldInfo.uid == uid then
                return shieldInfo.uuid
            end
        end
    end
end

--更新禁言信息
function ChatRestrictManager:chatBanOrUnBan(uid,banGMName,banTime,type)
    local currentTime = ChatInterface.getServerTime()
    local addBan = (banTime == -1) or (banTime - currentTime > 24*3600)
  
    if banTime == 0  then 
        self:removeRestrictUser(uid,RestrictType.BAN)
    elseif addBan then 
        self:addBanList(uid)
    end
end

return ChatRestrictManager