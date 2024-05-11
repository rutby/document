---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/4/6 15:39
---

local UIChatKick = BaseClass("UIChatKick", UIBaseView)
local base = UIBaseView
local UIChatInviteItem = require "UI.UIChatRoom.UIChatInvite.Component.UIChatInviteItem"
local Localization = CS.GameEntry.Localization

local return_path = "UICommonMidPopUpTitle/panel"
local close_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local title_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local scroll_view_path = "Vert/ScrollView"

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self:ReInit()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.return_btn = self:AddComponent(UIButton, return_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.title_text:SetLocalText(290063)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
end

local function ComponentDestroy(self)
    
end

local function DataDefine(self)
    self.roomId = ""
    self.roomData = nil
    self.dataList = {}
    self.itemList = {}
end

local function DataDestroy(self)
    
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(ChatInterface.getEventEnum().CHAT_REFRESH_CHANNEL, self.OnGetRoomList)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(ChatInterface.getEventEnum().CHAT_REFRESH_CHANNEL, self.OnGetRoomList)
    base.OnRemoveListener(self)
end

local function OnCreateCell(self, itemObj, index)
    itemObj.name = tostring(index)
    local data = self.dataList[index]
    local item = self.scroll_view:AddComponent(UIChatInviteItem, itemObj)
    item:SetData(data)
    item:SetOnClick(function()
        self:OnItemClick(index)
    end)
    item:SetState(UIChatInviteItem.State.Unselected)
    self.itemList[index] = item
end

local function OnDeleteCell(self, itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIChatInviteItem)
    self.itemList[index] = nil
end

local function ShowScroll(self)
    local count = #self.dataList
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    else
        self.scroll_view:ClearCells()
        self.scroll_view:RemoveComponents(UIChatInviteItem)
        self.itemList = {}
    end
end

local function ReInit(self)
    self.roomId = self:GetUserData()
    self:Refresh()
end

local function Refresh(self)
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UIChatInviteItem)
    self.roomData = ChatInterface.getRoomData(self.roomId)
    self.dataList = self:GetDataListInternal()
    self:ShowScroll()
end

local function GetDataListInternal(self)
    local dataList = {}
    for _, uid in ipairs(self.roomData:getMemberList()) do
        if uid ~= LuaEntry.Player.uid then
            local userInfo = ChatManager2:GetInstance().User:getChatUserInfo(uid)
            if userInfo then
                local data = {}
                data.uid = userInfo.uid
                data.name = userInfo.userName
                data.pic = userInfo.headPic
                data.picVer = userInfo.headPicVer
                data.headSkinId = userInfo.headSkinId
                data.headSkinET = userInfo.headSkinET
                data.abbr = userInfo.allianceSimpleName
                data.serverId = userInfo.serverId
                data.power = userInfo.power
                table.insert(dataList, data)
            end
        end
    end
    return dataList
end

local function OnItemClick(self, index)
    local data = self.dataList[index]
    UIUtil.ShowMessage(Localization:GetString("290073", data.name), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        local param = {}
        param.roomId = self.roomData.roomId
        param.uidArr = { data.uid }
        EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().ROOM_KICK_COMMAND, param)
    end)
end

local function OnGetRoomList(self)
    self:Refresh()
end

UIChatKick.OnCreate = OnCreate
UIChatKick.OnDestroy = OnDestroy
UIChatKick.OnEnable = OnEnable
UIChatKick.OnDisable = OnDisable
UIChatKick.ComponentDefine = ComponentDefine
UIChatKick.ComponentDestroy = ComponentDestroy
UIChatKick.DataDefine = DataDefine
UIChatKick.DataDestroy = DataDestroy
UIChatKick.OnAddListener = OnAddListener
UIChatKick.OnRemoveListener = OnRemoveListener

UIChatKick.OnCreateCell = OnCreateCell
UIChatKick.OnDeleteCell = OnDeleteCell
UIChatKick.ShowScroll = ShowScroll

UIChatKick.ReInit = ReInit
UIChatKick.Refresh = Refresh
UIChatKick.GetDataListInternal = GetDataListInternal

UIChatKick.OnItemClick = OnItemClick

UIChatKick.OnGetRoomList = OnGetRoomList

return UIChatKick