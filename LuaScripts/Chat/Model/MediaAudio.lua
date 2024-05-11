--[[
    这个类是声音的数据结构
    是从C#层 chatRoomManager.cs 拆出来的
    add by sunliwen
]]

local MediaAudio = BaseClass("MediaAudio")

function MediaAudio:__init()
    self.audio   = ""    
    self.duration = ""     
end

return MediaAudio
