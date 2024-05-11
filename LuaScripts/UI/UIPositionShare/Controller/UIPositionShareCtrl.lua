---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Still4.
--- DateTime: 2021/7/2 11:55
---
local UIPositionShareCtrl = BaseClass("UIPositionShareCtrl", UIBaseCtrl)
local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPositionShare)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetChatList(self)
    local _chatRoomManager = ChatInterface.getRoomMgr()
    return _chatRoomManager:GetShareRoom()
end

UIPositionShareCtrl.CloseSelf = CloseSelf
UIPositionShareCtrl.Close = Close
UIPositionShareCtrl.GetChatList = GetChatList

return UIPositionShareCtrl