---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/4/6 15:39
---

local UIChatRoomSetting = BaseClass("UIChatRoomSetting", UIBaseView)
local base = UIBaseView
local UIChatRoomPlayer = require "UI.UIChatRoom.UIChatRoomSetting.Component.UIChatRoomPlayer"
local Localization = CS.GameEntry.Localization

local return_path = "UICommonPopUpTitle/panel"
local close_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local title_path = "UICommonPopUpTitle/bg_mid/titleText"
local desc1_path = "Vert/Line1/Desc1"
local name_input_path = "Vert/Line1/NameInput"
local name_btn_path = "Vert/Line1/NameBtn"
local scroll_view_path = "Vert/ScrollView"
local line2_path = "Vert/Line2"
local desc2_path = "Vert/Line2/Desc2"
local add_path = "Vert/Line2/Add"
local line3_path = "Vert/Line3"
local desc3_path = "Vert/Line3/Desc3"
local remove_path = "Vert/Line3/Remove"
local quit_btn_path = "Vert/Quit"
local quit_text_path = "Vert/Quit/QuitText"
local Rect_LineBg = "Vert/Rect_LineBg"
local Rect_LineBg1 = "Vert/Rect_LineBg/Rect_LineBg1"
local Rect_LineBg2 = "Vert/Rect_LineBg/Rect_LineBg2"
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
        self:Close()
    end)
    self.close_btn = self:AddComponent(UIButton, close_path)
    self.close_btn:SetOnClick(function()
        self:Close()
    end)
    self.title_text = self:AddComponent(UIText, title_path)
    self.title_text:SetLocalText(290060)
    self.desc1_text = self:AddComponent(UIText, desc1_path)
    self.desc1_text:SetLocalText(290061)
    self.name_input = self:AddComponent(UIInput, name_input_path)
    self.name_input:SetOnValueChange(function (value)
        self:IptOnValueChange(value)
    end)

    self.name_btn = self:AddComponent(UIButton, name_btn_path)
    self.name_btn:SetOnClick(function()
        self:OnNameClick()
    end)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
    self.line2_go = self:AddComponent(UIBaseContainer, line2_path)
    self.desc2_text = self:AddComponent(UIText, desc2_path)
    self.desc2_text:SetLocalText(290062)
    self.add_btn = self:AddComponent(UIButton, add_path)
    self.add_btn:SetOnClick(function()
        self:OnAddClick()
    end)
    self.line3_go = self:AddComponent(UIBaseContainer, line3_path)
    self.desc3_text = self:AddComponent(UIText, desc3_path)
    self.desc3_text:SetLocalText(290063)
    self.remove_btn = self:AddComponent(UIButton, remove_path)
    self.remove_btn:SetOnClick(function()
        self:OnRemoveClick()
    end)
    self.quit_btn = self:AddComponent(UIButton, quit_btn_path)
    self.quit_btn:SetOnClick(function()
        self:OnQuitClick()
    end)
    self.quit_text = self:AddComponent(UIText, quit_text_path)

    self._lineBg_rect = self:AddComponent(UIBaseContainer, Rect_LineBg)
    self._lineBg1_rect = self:AddComponent(UIBaseContainer, Rect_LineBg1)
    self._lineBg2_rect = self:AddComponent(UIBaseContainer, Rect_LineBg2)
end

local function ComponentDestroy(self)
    
end

local function DataDefine(self)
    self.roomId = ""
    self.roomData = nil
    self.dataList = {}
    self.itemList = {}
    self.oldName = ""
end

local function DataDestroy(self)
    
end

local function OnAddListener(self)
    self:AddUIListener(EventId.UPDATE_MSG_USERINFO, self.OnUpdateUserInfo)
    self:AddUIListener(EventId.ChatRoomDismiss, self.OnChatRoomDismiss)
    self:AddUIListener(ChatInterface.getEventEnum().CHAT_REFRESH_CHANNEL, self.OnGetRoomList)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.UPDATE_MSG_USERINFO, self.OnUpdateUserInfo)
    self:RemoveUIListener(EventId.ChatRoomDismiss, self.OnChatRoomDismiss)
    self:RemoveUIListener(ChatInterface.getEventEnum().CHAT_REFRESH_CHANNEL, self.OnGetRoomList)
    base.OnRemoveListener(self)
end

local function OnCreateCell(self, itemObj, index)
    itemObj.name = tostring(index)
    local data = self.dataList[index]
    local item = self.scroll_view:AddComponent(UIChatRoomPlayer, itemObj)
    item:SetData(data)
    self.itemList[index] = item
end

local function OnDeleteCell(self, itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIChatRoomPlayer)
    self.itemList[index] = nil
end

local function ShowScroll(self)
    local count = #self.dataList
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    else
        self.scroll_view:ClearCells()
        self.scroll_view:RemoveComponents(UIChatRoomPlayer)
        self.itemList = {}
    end
end

local function ReInit(self)
    self.roomId = self:GetUserData()
    self:Refresh()
end

local function Refresh(self)
    self.roomData = ChatInterface.getRoomData(self.roomId)
    self.oldName = self.roomData.name
    
    self.name_input:SetText(self.roomData.name)
    self.lastStr = self.roomData.name
    if self.roomData:isMyCreateRoom() then
        self.line2_go:SetActive(true)
        self.line3_go:SetActive(true)
        self.name_input:SetInteractable(true)
        self.name_btn:SetActive(true)
        self.quit_text:SetLocalText(390165)
        self._lineBg_rect:SetSizeDelta({x = 514,y = 285})
        self._lineBg1_rect:SetActive(true)
        self._lineBg2_rect:SetActive(true)
    else
        self.line2_go:SetActive(false)
        self.line3_go:SetActive(false)
        self.name_input:SetInteractable(false)
        self.name_btn:SetActive(false)
        self.quit_text:SetLocalText(110043)
        self._lineBg_rect:SetSizeDelta({x = 514,y = 120})
        self._lineBg1_rect:SetActive(false)
        self._lineBg2_rect:SetActive(false)
    end
    
    self.dataList = self:GetDataListInternal()
    self:ShowScroll()
    
    --local uids = DeepCopy(self.roomData:getMemberList())
    --ChatManager2:GetInstance().User:requestUserInfo(uids)
end

local function GetDataListInternal(self)
    local dataList = {}
    local selectUids = {}
    for _, uid in ipairs(self.roomData:getMemberList()) do
        local userInfo = ChatManager2:GetInstance().User:getChatUserInfo(uid)
        if userInfo then
            if userInfo.power == 0 then
                table.insert(selectUids,uid)
            end
            table.insert(dataList, userInfo)
        end
    end
    ChatManager2:GetInstance().User:requestUserInfo(selectUids,true,true)
    return dataList
end

local function Close(self)
    local name = self.name_input:GetText()
    if not string.IsNullOrEmpty(name) and name ~= self.oldName then
        local param = {}
        param.roomId = self.roomId
        param.roomName = name
        EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_ROOM_CHANGE_NAME_COMMAND, param)
    end
    self.ctrl:CloseSelf()
end

local function OnNameClick(self)
    self.name_input:Select()
end

local function OnAddClick(self)
    local param = {}
    param.isCreate = false
    param.roomId = self.roomId
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatInvite, { anim = true }, param)
end

local function OnRemoveClick(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatKick, { anim = true }, self.roomId)
end

local function OnQuitClick(self)
    if self.roomData:isMyCreateRoom() then
        UIUtil.ShowMessage(Localization:GetString("290068"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_ROOM_DISMISS, self.roomId)
        end)
    else
        UIUtil.ShowMessage(Localization:GetString("290023"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().QUIT_ROOM_COMMAND, self.roomId)
        end)
    end
end

local function OnUpdateUserInfo(self)
    self:Refresh()
end

local function OnChatRoomDismiss(self)
    self.ctrl:CloseSelf()
end

local function OnGetRoomList(self)
    self:Refresh()
end

local function IptOnValueChange(self,value)
    self.inputValue = value
    local state = self.ctrl:CheckName(self.inputValue)
    if state == CheckNameType.MaxNameChar then
        self.name_input:SetText(self.lastStr)
    else
        self.lastStr = value
    end
end

UIChatRoomSetting.OnCreate = OnCreate
UIChatRoomSetting.OnDestroy = OnDestroy
UIChatRoomSetting.OnEnable = OnEnable
UIChatRoomSetting.OnDisable = OnDisable
UIChatRoomSetting.ComponentDefine = ComponentDefine
UIChatRoomSetting.ComponentDestroy = ComponentDestroy
UIChatRoomSetting.DataDefine = DataDefine
UIChatRoomSetting.DataDestroy = DataDestroy
UIChatRoomSetting.OnAddListener = OnAddListener
UIChatRoomSetting.OnRemoveListener = OnRemoveListener

UIChatRoomSetting.OnCreateCell = OnCreateCell
UIChatRoomSetting.OnDeleteCell = OnDeleteCell
UIChatRoomSetting.ShowScroll = ShowScroll

UIChatRoomSetting.ReInit = ReInit
UIChatRoomSetting.Refresh = Refresh
UIChatRoomSetting.GetDataListInternal = GetDataListInternal
UIChatRoomSetting.Close = Close

UIChatRoomSetting.OnNameClick = OnNameClick
UIChatRoomSetting.OnAddClick = OnAddClick
UIChatRoomSetting.OnRemoveClick = OnRemoveClick
UIChatRoomSetting.OnQuitClick = OnQuitClick

UIChatRoomSetting.OnUpdateUserInfo = OnUpdateUserInfo
UIChatRoomSetting.OnChatRoomDismiss = OnChatRoomDismiss
UIChatRoomSetting.OnGetRoomList = OnGetRoomList

UIChatRoomSetting.IptOnValueChange = IptOnValueChange

return UIChatRoomSetting