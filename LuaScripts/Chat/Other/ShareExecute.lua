--[[
	ShareExecute
	主要用来做AttachmentId的执行
	不同的post表示不同的执行方式
	不同的AttachmentId表示不同的参数
]]

local ShareExecute = {}


--世界坐标分享
local function Execute_PointShare(t)
	if not SceneUtils.CheckCanGotoWorld() then
		return UIUtil.ShowTipsId(120018)
	end
	
	if t.x == nil or t.y == nil then
		return
	end
	
	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().LF_CloseChatView,true)

	local _x = tonumber(t.x) or 1
	local _y = tonumber(t.y) or 1
	local worldId = tonumber(t.worldId) or 0
	local serverId = tonumber(t.sid) or LuaEntry.Player:GetSelfServerId()
	local v2 = {}
	v2.x = _x
	v2.y = _y
	local pointId = SceneUtils.TileToWorld(v2,ForceChangeScene.World)
	GoToUtil.GotoWorldPos(pointId, nil,ookAtFocusTime,function()
	end, serverId,worldId)
end


--联盟任务
local function Execute_AllianceTaskShare(t)
	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().LF_CloseChatView,true)
	UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceTask)
end


-- 联盟招募世界分享:
local function Execute_AllianceInvite(t, chatData)
	local tid = t.aid
	local name = t.name or ""
	if t.aid == nil then
		return 
	end
	
	-- 有可能联盟不存在了
	
	
	UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail,
		{ anim = true},	name, tid)
end


-- 联盟等级调整联盟分享:
local function Execute_AllianceRankChange(t)

	return nil
end

local function Execute_ActMonsterTowerHelp(t,chatData)
	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().LF_CloseChatView,true)
	GoToUtil.MoveToWorldPointAndOpen(t.pointId)
	--local pointId = SceneUtils.TileIndexToWorld(t.pointId,ForceChangeScene.World)
	--GoToUtil.GotoWorldPos(pointId)
end

-- 分享解码相关的表格
local ExecuteTable =
{
	[PostType.Text_PointShare] = Execute_PointShare,
	[PostType.Text_AllianceInvite] = Execute_AllianceInvite,
	[PostType.Text_AllianceRankChange] = Execute_AllianceRankChange,
	[PostType.Text_AllianceOfficialChange] = Execute_AllianceRankChange,
	[PostType.Text_AllianceTaskShare] = Execute_AllianceTaskShare,
	[PostType.Text_ActMonsterTowerHelp] = Execute_ActMonsterTowerHelp,
}


-- 进行聊天框的执行
-- post = 聊天的类型
-- t = 从attachmentId解析出来的参数table
function ShareExecute.Execute(chatData, t)

	local f = ExecuteTable[chatData.post]

	-- 返回类型相关的参数表格
	if f and t then
		f(t, chatData)
	else
		ChatPrint("share execute not found! type : " .. tostring(post))
	end
end


return ShareExecute
