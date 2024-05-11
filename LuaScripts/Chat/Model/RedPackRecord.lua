--[[
    这个类是红包被抢记录的信息
    是从C#层 chatRoomManager.cs 拆出来的
    有的变量名词不达意！！！先还原之后再说吧
    add by sunliwen
]]

local RedPackRecord = BaseClass("RedPackRecord")

function RedPackRecord:__init()
	self.gold    = 0 		-- 被抢金币
	self.uid     = ""       -- 抢红包的人的UID
	self.uName   = ""       -- 抢红包的人名字
	self.getTime = 0        -- 抢红包的时间
	self.picV    = 0        -- 应该是头像版本吗？
	self.pic     = ""       -- 头像名字
end

return RedPackRecord

