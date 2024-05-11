---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/3/9 19:13
---
local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushChatUpMessage = BaseClass("PushChatUpMessage", WebSocketBaseMessage)


--[[
    下面的代码，逻辑不应该在这里处理，但是先在这里特殊处理下
    1. A.B.C 三个用户，A将B踢出联盟，AB均显示正常，但是C此时不会收到任何通知。此时C在线的情况下应该收到类似：push.al.event事件，参数t=4则为离开
    2. A.B.C 三个用户，A调整了B的联盟等级。然后ABC在聊天界面中联盟列表界面看到的B的等级信息不是最新的。
        1. 此时ABC均没有收到任何关于B等级信息发生变化的通知
        2. 游戏启动的时候回调用这个命令：chat.room.invitee 获取联盟用户列表，但是返回信息中B对应的lastUpdateTime的值没发生变化，导致客户端检测后判断这个用户的信息不需要更新
        3. 用户信息更新的逻辑是：当用户的信息发生变化时改变服务器中存储的这个用户的lastUpdateTime字段。客户端在对比本地存储和服务器返回的这个字段后，在决定是否去重新请求这个用户的最新用户信息

    -- 由于服务器暂时没时间处理以上两个问题
    但是理论上，这个应该在C++里面处理，不应该在lua中处理。
    先在这里打个补丁。记录下，将处理逻辑写在这里的原因。因为写在这里有些突兀，不符合整体逻辑
]]


local function OnCreate(self, tbl)

end

local function HandleMessage(self, serverData)
    -- self.super.HandleMessage(self, serverData)
    -- ChatPrint("%s,%s", msg.cmd, msg.result.status)

    if serverData.data == nil then
        print("push chat error!!!")
        return
    end

    -- 联盟动态也走这里
    local roomMgr = ChatManager2:GetInstance().Room
    local chatData = roomMgr:CreateChatMessage()
    local userMgr = ChatManager2:GetInstance().User
    chatData:onParseServerData(serverData.data)
    roomMgr:UpdateChatData(chatData)
    -- 如果有senderInfo的话，就需要处理一下；头像更新之类的
    if serverData.data.senderInfo then
        userMgr:__processSenderInfo(serverData.data.sender, serverData.data.senderInfo)
    end
    EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().UPDATE_USER_MSG, chatData)

end

PushChatUpMessage.OnCreate = OnCreate
PushChatUpMessage.HandleMessage = HandleMessage

return PushChatUpMessage