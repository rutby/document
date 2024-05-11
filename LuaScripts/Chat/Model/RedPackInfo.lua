--[[
    这个类是红包的数据结构
    是从C#层 chatRoomManager.cs 拆出来的
    有的变量名词不达意！！！先还原之后再说吧
    add by sunliwen
]]

local RedPackInfo = BaseClass("RedPackInfo")

function RedPackInfo:__init()
    self.rawData = nil  -- 红包消息的原始数据  存储结构为ChatMessage
    self.uuid   = ""    -- 红包uid
    self.server = 0     -- 服务器id
    self.status = 0     -- 红包状态
    self.uid    = ""    -- 发红包的人的uid   
    self.name   = ""    -- 发红包的人的名字
    self.total  = 0     -- 红包总金币数
    self.cost   = 0     -- 红包当前已经被抢了的金币
    self.curPeople = 0  -- 当前有几个红包被抢
    self.totalPeople = 0 -- 总共有几个红包
    self.picV   = 0     -- 发红包的人的头像
    self.pic    = ""    -- 发红包的人的头像
    self.time   = 0     -- 发红包的时间
    self.record = {}    -- 红包被抢记录，存储结构为RedPackRecord
    self.recordGold = 0 -- 我在这个红包里抢了多少
end
---设置红包状态
function RedPackInfo:setStatus(status)
    self.status = status
end

return RedPackInfo

