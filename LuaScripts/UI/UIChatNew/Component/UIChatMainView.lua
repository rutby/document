---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 6/10/21 3:47 PM
---
local Localization = CS.GameEntry.Localization
local UIChatMainView = BaseClass("UIChatMainView", UIBaseContainer)
local base = UIBaseContainer
local ChatViewController = require "UI.UIChatNew.Controller.ChatViewUtils"
local ChatHint = require "UI.UIChatNew.Component.ChatItem.ChatHint"
local ChatItem = require "UI.UIChatNew.Component.ChatItem.ChatItem"
local ChatItemAllianceShare = require "UI.UIChatNew.Component.ChatItem.ChatItemAllianceShare"
local ChampionBattleReportShare = require "UI.UIChatNew.Component.ChatItem.ChampionBattleReportShare"
local ChatItemLeft_Normal = require "UI.UIChatNew.Component.ChatItem.ChatItemLeft_Normal"
local ChatItemRight_Normal = require "UI.UIChatNew.Component.ChatItem.ChatItemRight_Normal"
local ChatTime = require "UI.UIChatNew.Component.ChatItem.ChatTime"
local ChatItemNeutralAttack = require "UI.UIChatNew.Component.ChatItem.ChatItemNeutralAttack"
local ChatItemMailReportShare = require "UI.UIChatNew.Component.ChatItem.ChatItemMailReportShare"
local ChatItemMissileAttack = require "UI.UIChatNew.Component.ChatItem.ChatItemMissileAttack"
local ChatItemMailReportContentShare = require "UI.UIChatNew.Component.ChatItem.ChatItemMailReportContentShare"
local ChatItemMailScoutResultContentShare = require "UI.UIChatNew.Component.ChatItem.ChatItemMailScoutResultContentShare"
local ChatItemMailScoutAlertContentShare = require "UI.UIChatNew.Component.ChatItem.ChatItemMailScoutAlertContentShare"
local ChatItemMailScountResultShare = require "UI.UIChatNew.Component.ChatItem.ChatItemMailScountResultShare"
local ChatItemAllianceTaskShare = require "UI.UIChatNew.Component.ChatItem.ChatItemAllianceTaskShare"
local ChatItemAllianceRecruitShare = require "UI.UIChatNew.Component.ChatItem.ChatItemAllianceRecruitShare"
local ChatItemFormationShare = require "UI.UIChatNew.Component.ChatItem.ChatItemFormationShare"
local ChatItemRedPacketShare = require "UI.UIChatNew.Component.ChatItem.ChatItemRedPacketShare"
local ChatItemGM = require "UI.UIChatNew.Component.ChatItem.ChatItemGM"
local _cp_scrollView = "Scroll_View/Viewport/Content/Root/MainView/RightLayout/Scroll_View_mainView";
local _cp_scrollViewContent = "Scroll_View/Viewport/Content/Root/MainView/RightLayout/Scroll_View_mainView/MainViewport/MainContent";
local _cp_infoText = "Scroll_View/Viewport/Content/Root/MainView/RightLayout/Scroll_View_mainView/InfoLabel";
local _cp_sendBtn = "Scroll_View/Viewport/Content/Root/MainView/RightLayout/BottomInputView/SendBtn";
--local _cp_topLayout = "Scroll_View/Viewport/Content/Root/MainView/RightLayout/TopLayout";
--local _cp_keyboardLayout = "Scroll_View/Viewport/Content/Root/MainView/RightLayout/KeyboardLayout";
local _cp_vScrollBar = "Scroll_View/Viewport/Content/Root/MainView/RightLayout/Scroll_View_mainView/MainViewport/Scrollbar";
local _cp_objLoading = "Scroll_View/Viewport/Content/Root/MainView/RightLayout/Scroll_View_mainView/objLoading"
local _cp_img_loading = "Scroll_View/Viewport/Content/Root/MainView/RightLayout/Scroll_View_mainView/objLoading/Image/img_loading"
local _cp_txt_loading = "Scroll_View/Viewport/Content/Root/MainView/RightLayout/Scroll_View_mainView/objLoading/Image/txtLoading"

function UIChatMainView:setSlideNode( node )
    self._eventTriggerNode = node
end

function UIChatMainView:getSlideNode()
    return self._eventTriggerNode
end

--控件的定义
function UIChatMainView:ComponentDefine()
    self._objLoading = self:AddComponent(UIBaseContainer, _cp_objLoading)
    --self._animator_loading = self:AddComponent(UIAnimator, _cp_img_loading)
    self._txt_loading = self:AddComponent(UIText, _cp_txt_loading)
    
    self._scrollView = self:AddComponent(UILoopListView2, _cp_scrollView)
    self._scrollView_ScrollRect = self:AddComponent(UIScrollRect, _cp_scrollView)
    self._scrollView_ScrollRect:AddValueChangeListener(function (vec)
        self:OnScollValueChange()
    end)
    
    self._scrollViewContent = self:AddComponent(UIBaseContainer, _cp_scrollViewContent)
    self._infoText = self:AddComponent(UIText, _cp_infoText)
    self._sendBtn = self:AddComponent(UIButton, _cp_sendBtn)

    --self._topLayout = self.transform:Find(_cp_topLayout):GetComponent(typeof(CS.UnityEngine.RectTransform))
    --self._keyboardLayout = self.transform:Find(_cp_keyboardLayout):GetComponent(typeof(CS.UnityEngine.RectTransform))
    
    self._vScrollBar = self.transform:Find(_cp_vScrollBar):GetComponent(typeof(CS.UnityEngine.RectTransform))
    
    self._sendBtn:SetOnClick(function ()
        self:OnSendClick()
    end)
    
    self._scrollView.unity_looplistview2.mOnListClickAction = function()
    end

    self._scrollView.unity_looplistview2.mOnBeginDragAction = function()
        self:ClearWaitDelay()
        self:UpdateScrollbarVisible()
    end

    self._scrollView.unity_looplistview2.mOnEndDragAction = function()
        self:OnEndDrag();
    end
    
    --self.select_btn:SetOnClick(function()
    --    self:OnBtnClick()
    --end)
end

--控件的销毁
function UIChatMainView:ComponentDestroy()
    self._scrollView.unity_looplistview2.mOnListClickAction = nil
    self._scrollView.unity_looplistview2.mOnBeginDragAction = nil
    self._scrollView.unity_looplistview2.mOnEndDragAction = nil
    self._scrollView:ClearAllItems()
end

--变量的定义
function UIChatMainView:DataDefine()
    self._databaseOffset = -10
    self._chatDatas = {}
    self._chatDatasCnt = 0
    self._timeFlags = {}
    self._isFetchingMore = false
    self._chatViewController = ChatViewController:GetInstance()
    self.delayTimerTask = nil
    self._scrollViewPortSize = nil
    self._chatItemObjList = {}
end

function UIChatMainView:OnAddListener()
    base.OnAddListener(self)
	
	self:AddUIListener(ChatInterface.getEventEnum().CHAT_UPDATE_ROOM_CLICK_TIME, self.OnUpdateRoomClickTime);
    self:AddUIListener(ChatInterface.getEventEnum().CHAT_RECIEVE_ROOM_MSG, self.OnRecieveChat);
    --self:AddUIListener(EventId.CHAT_LEAVE_ROOM_MSG, self.OnLeaveRoom);
    self:AddUIListener(ChatInterface.getEventEnum().GOTO_WORLD_POSITION, self.OnCloseChat);
    self:AddUIListener(ChatInterface.getEventEnum().CLOSE_CHAT_UI, self.OnCloseChat);
    self:AddUIListener(ChatInterface.getEventEnum().CHAT_UPDATE_ROOM_HISTORY_MSG,self.OnUpdateHistoryMsg);
    self:AddUIListener(ChatInterface.getEventEnum().CHAT_REQUEST_HISTORY_MSG_RESULT, self.OnRequestHistoryResult);
    --self:AddUIListener(EventId.CHAT_SEND_ROOM_MSG_FAILURE, self.OnSendMsgFailure);

    self:AddUIListener(ChatInterface.getEventEnum().CHAT_REMOVE_ROOM_MSG_COMMAND, self.OnRemoveChat);
    self:AddUIListener(ChatInterface.getEventEnum().CHAT_LOGIN_SUCCESS, self.OnChatLoginSuccess);
    self:AddUIListener(ChatInterface.getEventEnum().CHAT_MOVETOBOTTOM, self.OnMoveToBottom);
    --EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_ERROR_OR_DISCONNECT)
    self:AddUIListener(ChatInterface.getEventEnum().CHAT_ERROR_OR_DISCONNECT, self.OnChatNetErrorOrDisconnect);
    self:AddUIListener(ChatInterface.getEventEnum().UPDATE_USER_MSG, self.UpdateMsgList);
end

function UIChatMainView:OnRemoveListener()

    self:RemoveUIListener(ChatInterface.getEventEnum().CHAT_ERROR_OR_DISCONNECT, self.OnChatNetErrorOrDisconnect);
	self:RemoveUIListener(ChatInterface.getEventEnum().CHAT_UPDATE_ROOM_CLICK_TIME, self.OnUpdateRoomClickTime);
    self:RemoveUIListener(ChatInterface.getEventEnum().CHAT_RECIEVE_ROOM_MSG, self.OnRecieveChat);
    --self:RemoveUIListener(EventId.CHAT_LEAVE_ROOM_MSG, self.OnLeaveRoom);
    self:RemoveUIListener(ChatInterface.getEventEnum().GOTO_WORLD_POSITION, self.OnCloseChat);
    self:RemoveUIListener(ChatInterface.getEventEnum().CLOSE_CHAT_UI, self.OnCloseChat);
    self:RemoveUIListener(ChatInterface.getEventEnum().CHAT_UPDATE_ROOM_HISTORY_MSG,self.OnUpdateHistoryMsg);
    self:RemoveUIListener(ChatInterface.getEventEnum().CHAT_REQUEST_HISTORY_MSG_RESULT, self.OnRequestHistoryResult);
    --self:RemoveUIListener(EventId.CHAT_SEND_ROOM_MSG_FAILURE, self.OnSendMsgFailure);

    self:RemoveUIListener(ChatInterface.getEventEnum().CHAT_REMOVE_ROOM_MSG_COMMAND, self.OnRemoveChat);
    self:RemoveUIListener(ChatInterface.getEventEnum().CHAT_LOGIN_SUCCESS, self.OnChatLoginSuccess);
    self:RemoveUIListener(ChatInterface.getEventEnum().CHAT_MOVETOBOTTOM, self.OnMoveToBottom);
    self:RemoveUIListener(ChatInterface.getEventEnum().UPDATE_USER_MSG, self.UpdateMsgList);
    base.OnRemoveListener(self)
end


function UIChatMainView:DelayInvoke(callback, delayTime)
    local param = {}
    param.timer = TimerManager:GetInstance():GetTimer(delayTime, function()
        if param.timer ~= nil then
            param.timer:Stop()
            param.timer = nil
        end
        param = nil
        callback()
    end , self, true,false,false)
    param.timer:Start()
end

function UIChatMainView:OnChatNetErrorOrDisconnect()
    self:ShowLoading()
end

function UIChatMainView:ScrollToTail()
    if (table.length(self._chatDatas) > 1) then
        self._scrollView:MovePanelToItemIndex(table.length(self._chatDatas)-1, 0)
    end
end

function UIChatMainView:CheckShowReturnBtn()
    local isBottom = false
    local lastMaxCount = self:GetItemCount()
    if self._scrollView~=nil then
        local lastChatItem = self._scrollView:GetShownItemByItemIndex(lastMaxCount-1)
        if (lastChatItem ~= nil) then
            local pos = self._scrollView:GetItemCornerPosInViewPort(lastChatItem)
            isBottom = (Mathf.Abs(pos.y)-self._scrollView.unity_looplistview2.ViewPortSize) < lastChatItem.ItemSize
        end
        self._sendBtn:SetActive(isBottom==false)
    end
end

function UIChatMainView:OnGetItemByIndex( listView, index )
    if (index < 0 or index > table.length(self._chatDatas)) then
        return nil
    end
    local prefabName = self:GetChatItemPrefabName(index)
    
    local item = listView:NewListViewItem(prefabName)
    if (item == nil) then
        return nil
    end
    --[[
          如果在列表中已经存在了,表示已经做过了一次绑定,则只需要进行内容刷新即可
     ]]
    if (self._chatItemObjList[item] ~= nil) then
        self._chatItemObjList[item]:SetActive(true)
        self._chatItemObjList[item]:SetContentViewScript(self)
        self._chatItemObjList[item]:UpdateItem(self._chatDatas[index+1], index+1)
    else
        local chatItemScript = self:GetChatItemScriptName(index)
        if (chatItemScript == nil) then
            printError(">>>> chatitemscript prefab - " .. tostring(prefabName))
            return;
        end
        -- 这个地方需要使用addCompent的形式和 IChatItem绑定
        NameCount = NameCount + 1
        local objectName = prefabName .. tostring(NameCount)
        item.gameObject.name = prefabName .. tostring(objectName)
        --[[
            利用looplistitem中的变量做控制,如果已经对布局做好了处理,就不需要再次处理了
        ]]
        if (not item.IsInitHandlerCalled) then
            item.IsInitHandlerCalled = true
        end
        item.CachedRectTransform:SetInsetAndSizeFromParentEdge(CS.UnityEngine.RectTransform.Edge.Left, 10, self._scrollView:GetViewPortWidth()-20)
        local temp = self._scrollViewContent:AddComponent(chatItemScript, item.gameObject.name)
        temp:SetActive(true)
        temp:SetContentViewScript(self)
        temp:UpdateItem(self._chatDatas[index+1], index+1)
        self._chatItemObjList[item] = temp
    end
    return item
end

function UIChatMainView:RefreshScrollView()
    self._scrollView:RefreshAllShownItem()
end

function UIChatMainView:ReloadAfterTranslateRecv( index )
    self:RefreshScrollView();
    if (index == table.count(self._chatDatas)) then
        self:OnMoveToBottom()
    end
end

function UIChatMainView:GetGMRoomMsg(roomData)
    local msgs = {}
    table.insertto(msgs, roomData["msgs"])
    local firstVirtualData = self:CreateVirtualGmMessage()
    self._chatViewController:SetGmRoomTipMessage(firstVirtualData)
    if (firstVirtualData ~= nil) then
        msgs[#msgs+1] = firstVirtualData
    end
    table.sort(msgs,function(a,b)
        return a.sendLocalTime < b.sendLocalTime
    end)
    return msgs
end

function UIChatMainView:GetRoomMsgs()
	local roomId = self._chatViewController:GetCurrentRoomId()
    local roomData = ChatInterface.getRoomData(roomId)
    if (roomData ~= nil) then
        if (roomData:IsGmRoom()) then
            return self:GetGMRoomMsg(roomData)
        end
        return roomData["msgs"]
    else
        -- 如果是GM房间,当没有消息的时候需要虚拟出来一个
        if (roomId == ChatGMRoomId) then
            local param = {}
            local virtualdata = self:CreateVirtualFirstMessage()
            param[#param+1] = virtualdata
            local virtualGmData =  self:CreateVirtualGmMessage()
            self._chatViewController:SetGmRoomTipMessage(virtualGmData)
            param[#param+1] = virtualGmData
            return param
        end
        return nil
    end
end

-- 如果是GM房间的话,当没有消息的时候,需要虚拟出一条help消息
function UIChatMainView:CreateVirtualGmMessage()
    local startTime = self._chatViewController:GetStartGmChatTime()
    if startTime<=0 then
        startTime = UITimeManager:GetInstance():GetServerSeconds()
    end
    local RoomMgr = ChatManager2:GetInstance().Room
    local message = RoomMgr:CreateChatMessage() --ChatMessage.New()
    message["group"] = "custom"
    message["senderUid"] = ChatGMUserId
    message["msg"] = Localization:GetString("121542")
    message["msgMask"] = Localization:GetString("121542")
    message["sendLocalTime"] = startTime
    message["senderName"] = Localization:GetString("100619")
    message["serverTime"] = startTime*1000
    message["post"] = PostType.Text_MsgGm
    return message
end

function UIChatMainView:CreateVirtualFirstMessage()
    local RoomMgr = ChatManager2:GetInstance().Room
    local message = RoomMgr:CreateChatMessage() --ChatMessage.New()
    message["group"] = "custom"
    message["senderUid"] = ChatGMUserId
    message["msg"] = Localization:GetString("121543")
    message["msgMask"] = Localization:GetString("121543")
    message["sendLocalTime"] = UITimeManager:GetInstance():GetServerSeconds()
    message["senderName"] = Localization:GetString("100619")
    message["serverTime"] = UITimeManager:GetInstance():GetServerTime()
    return message
end

function UIChatMainView:ClearChatDatas()
    self._chatDatas = {}
    self._timeFlags = {}
end


function UIChatMainView:GetItemCount()
    return table.length(self._chatDatas)
end


-- 创建
function UIChatMainView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self._scrollView:InitListView(0, function(listview, index) 
        return self:OnGetItemByIndex(listview, index)
    end)
end


-- 显示
function UIChatMainView:OnEnable()
    base.OnEnable(self)
    self._chatViewController:SetChatMainView(self)
    --local width = self._chatViewController:GetChatViewWidth_Normal() - 340
	
	--local _, _topLayoutSize_y = self._topLayout:Get_sizeDelta()
	--self._topLayout:Set_sizeDelta(width, _topLayoutSize_y)

	--local _, keyboardLayoutSize_y = self._keyboardLayout:Get_sizeDelta()
	--self._keyboardLayout:Set_sizeDelta(width, keyboardLayoutSize_y)
	
    self._scrollBarImg = self._vScrollBar.transform:Find("SlidingArea/Handle"):GetComponent(typeof(CS.UnityEngine.UI.Image))
end

-- 检测是否是虚拟出来的房间 -- 世界/联盟
function UIChatMainView:CheckAbstractRoom()
    local roomId = self._chatViewController:GetCurrentRoomId()
    if (roomId == E_CHAT_COUNTRY_ROOMID or roomId == E_CHAT_ALLIANCE_ROOMID) then
        self:ShowLoading()
    else
        self:HideLoading()
    end
end

function UIChatMainView:ShowLoading()
    self._objLoading:SetActive(true)
    self._txt_loading:SetLocalText(290047)
end

function UIChatMainView:HideLoading()
    self._objLoading:SetActive(false)
end

-- 销毁
function UIChatMainView:OnDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

-- 隐藏
function UIChatMainView:OnDisable()
    self:ClearWaitDelay()
    self._scrollView_ScrollRect:RemoveAllListeners()
    self._chatViewController:SetChatMainView(nil)
    self._isFetchingMore = false
    base.OnDisable(self)
end


function UIChatMainView:OnChatLoginSuccess()
    self._isFetchingMore = false
    self:HideLoading()
end

-- 主要用来更新自己发送的消息，自己的消息首次是客户端模拟的；然后等到服务器返回的时候是更新
function UIChatMainView:OnUpdateRoomClickTime(roomId)
	local currentRoomId = self._chatViewController:GetCurrentRoomId()
	if (currentRoomId ~= roomId) then
		return
	end

	local room = ChatInterface.getRoomData(currentRoomId)
	if room then
		room:SetLastClickTime()
	end
end

function UIChatMainView:OnRecieveChat( chatRoomData )
    if (chatRoomData == nil) then
        return
    end
    local currentRoomId = self._chatViewController:GetCurrentRoomId()
    local luaRoomId = chatRoomData["roomId"]
    if (currentRoomId ~= luaRoomId) then
        return
    end
    self._infoText:SetActive(false)
	
	if true then
        local room = ChatInterface.getRoomData(currentRoomId)
		room:SetLastClickTime()
		
        local total = room:getToTalNum()
        local roomMsgs = room["msgs"]
        local preSendTime = 0
        local lastMaxCount = self:GetItemCount()
        if (total > 1) then
            local prevChatData = roomMsgs[#roomMsgs-1]
            preSendTime = prevChatData:getCreateTime()
        end
        local sendTime = chatRoomData:getCreateTime()
        if (sendTime - preSendTime > 60) then
            self._chatDatas[#self._chatDatas+1] = chatRoomData
            self._timeFlags[#self._chatDatas] = true
        end
        self._chatDatas[#self._chatDatas+1] = chatRoomData
        local isBottom = false
        local lastChatItem = self._scrollView:GetShownItemByItemIndex(lastMaxCount-1)
        if (lastChatItem ~= nil) then
            local pos = self._scrollView:GetItemCornerPosInViewPort(lastChatItem)
            isBottom = (Mathf.Abs(pos.y)-self._scrollView.unity_looplistview2.ViewPortSize) < lastChatItem.ItemSize
        end
        self._scrollView:SetListItemCount(self:GetItemCount(), false, false)
        self._scrollView:RefreshAllShownItem()
        if (isBottom and not self._scrollView.unity_looplistview2.IsDraging) then
            self:ScrollToTail()
        end
        self:CheckShowReturnBtn()
    end
end

function UIChatMainView:OnRemoveChat( chatRoomData )
    if (chatRoomData == nil) then
        return
    end
    local currentRoomId = self._chatViewController:GetCurrentRoomId()
    if (currentRoomId == chatRoomData["roomId"]) then
        self:ReloadData()
    end
end


function UIChatMainView:OnCloseChat()
    UIManager:GetInstance():CloseUIView()
end

function UIChatMainView:OnMoveToBottom()
    self._isFetchingMore = false
    local chatCount = self:GetItemCount()
    self:ReloadData()
    self._scrollView.unity_looplistview2:ForceUpdate()
    self._scrollView:MovePanelToItemIndex(chatCount, 0)
end

function UIChatMainView:OnUpdateHistoryMsg()
    self._isFetchingMore = false;
    self:ReloadData()
    self._scrollView.unity_looplistview2:ForceUpdate()
end

function UIChatMainView:OnRequestHistoryResult( ret )
    self._isFetchingMore = false;
    local oldChatCount = self:GetItemCount();
    self:ReloadData()
    local newChatCount = self:GetItemCount();
    self._scrollView.unity_looplistview2:ForceUpdate()
    self._scrollView:MovePanelToItemIndex(newChatCount-oldChatCount, 0)
end

--[[
    根据不同类型,返回不同的prefab名字
]]
function UIChatMainView:GetChatItemPrefabName( index )
    index = index + 1
    if (index > table.length(self._chatDatas)) then
        return "ChatItemLeft_Normal";
    end
    -- 返回时间节点
    if (self._timeFlags[index] ~= nil) then
        return "ChatTime"
    end
    local chatData = self._chatDatas[index]
	if chatData == nil then
		return "ChatItemLeft_Normal"
	end
	
    local isMyChat = chatData:isMyChat()
    if (chatData["post"] == PostType["Text_ChatRoomSystemMsg"] or
            chatData["post"] == PostType["Text_AllianceRankChange"]
            or chatData["post"] == PostType.Text_MemberJoin
            or chatData["post"] == PostType.Text_MemberQuit) then
        return "ChatHint"
    elseif chatData["post"] == PostType.Text_MsgGm then
        return "ChatItemLeft_MailGm"
    elseif chatData["post"] == PostType.Text_FBAlliance_missile_share then
        return "ChatItemNeutralAttack"
    elseif chatData["post"] == PostType.Text_Formation_Fight_Share then
        return isMyChat and "ChatItemRight_MailReportShare" or "ChatItemLeft_MailReportShare";
    elseif chatData["post"] == PostType.Text_BattleReportContentShare then
        return isMyChat and "ChatItemRight_MailReportContentShare" or "ChatItemLeft_MailReportContentShare";
    elseif chatData.post == PostType.Text_MailScoutResultShare then
        --return isMyChat and "ChatItemRight_MailReportShare" or "ChatItemLeft_MailReportShare";
        return isMyChat and "ChatItemRight_MailScoutResultShare" or "ChatItemLeft_MailScoutResultShare";
    elseif chatData.post == PostType.Text_ScoutReportContentShare then
        return isMyChat and "ChatItemRight_MailScoutResultContentShare" or "ChatItemLeft_MailScoutResultContentShare";
    elseif chatData.post == PostType.Text_ScoutAlertContentShare then
        return isMyChat and "ChatItemRight_MailScoutAlertContentShare" or "ChatItemLeft_MailScoutAlertContentShare";
    elseif chatData.post == PostType.Text_AllianceTaskShare then
        --return isMyChat and "ChatItemRight_MailReportShare" or "ChatItemLeft_MailReportShare";
        return isMyChat and "ChatItemRight_AllianceTaskShare" or "ChatItemLeft_AllianceTaskShare";
    elseif chatData.post == PostType.Text_AllianceRecruitShare then
        return isMyChat and "ChatItemRight_AllianceRecruitShare" or "ChatItemLeft_AllianceRecruitShare";
    elseif chatData["post"] == PostType.Text_Formation_Share then
        return isMyChat and "ChatItemRight_FormationShare" or "ChatItemLeft_FormationShare";
    elseif chatData["post"] == PostType.RedPackge then
        return isMyChat and "ChatItemRight_RedenvelopeSend" or "ChatItemLeft_RedenvelopeSend";
    elseif chatData.post == PostType.Text_ChampionBattleReportShare then
        return isMyChat and "ChatItemRight_ChampionBattleReportShare" or "ChatItemLeft_ChampionBattleReportShare";
    elseif chatData.post == PostType.Text_ActMonsterTowerHelp then
        return isMyChat and "ChatItemRight_Normal" or "ChatItemLeft_Normal";
    elseif chatData.post == PostType.Text_Missile_Attack then
        return isMyChat and "ChatItemRight_Missile_Attack" or "ChatItemLeft_Missile_Attack";

        --elseif chatData["post"] == PostType["Text_AllianceInvite"] then
    --    return isMyChat and "ChatItemRight_AllianceShare" or "ChatItemLeft_AllianceShare"
    --elseif chatData["post"] == PostType["Text_StartWar"] or chatData["post"] == PostType["Text_EndWar"] or chatData["post"] == PostType["Text_AllianceProduceMine"] then
    --    return "ChatItemLeft_AllianceFight"
    --elseif chatData["post"] == PostType["Text_AllianceWelcome"] then
    --    return "ChatItemLeft_AllianceInfo"
    --elseif chatData["post"] == PostType["Text_AllianceRedPack"] or
    --        chatData["post"] == PostType["Text_AllianceTransfer"] or
    --        chatData["post"] == PostType["Text_AllianceRankChange"] or
    --        chatData["post"] == PostType["Text_AllianceOfficialChange"] or
    --        chatData["post"] == PostType["Text_AllianceOfficialSet"] or
    --        chatData["post"] == PostType["Text_AllianceOfficialCancel"] or
    --        chatData["post"] == PostType["Text_AllianceGather"] or
    --        chatData["post"] == PostType["Text_ShareHeroTenGet"] then
    --    return isMyChat and "ChatItemRight_AllianceInfo" or "ChatItemLeft_AllianceInfo";
    --elseif chatData["post"] == PostType["Text_AllianceMark"] then
    --    return isMyChat and "ChatItemRight_AllianceMark" or "ChatItemLeft_AllianceMark";
    --elseif chatData["post"] == PostType["Text_NewServerActivity"] then
    --    return isMyChat and "ChatItemRight_NewServerActivity" or "ChatItemLeft_NewServerActivity";
    --elseif chatData["post"] == PostType["Text_NewServerActivity_New"] then
    --    return isMyChat and "ChatItemRight_NewServerActivity" or "ChatItemLeft_NewServerActivity";
    --elseif chatData["post"] == PostType["Text_AllianceMemberInOut"] then
    --    return "ChatSysInfo";
    else
        return isMyChat and "ChatItemRight_Normal" or "ChatItemLeft_Normal";
    end
end


--[[
    根据不同类型,返回不同的prefab名字
]]
function UIChatMainView:GetChatItemScriptName( index )
    index = index + 1 -- lua索引从1开始
    if (index > table.length(self._chatDatas)) then
        return ChatItem
    end
    -- 返回时间节点
    if (self._timeFlags[index] ~= nil) then
        return ChatTime
    end
    local chatData = self._chatDatas[index]
    local isMyChat = chatData:isMyChat()
    if (chatData["post"] == PostType["Text_ChatRoomSystemMsg"] or
            chatData["post"] == PostType["Text_AllianceRankChange"]
            or chatData["post"] == PostType.Text_MemberJoin
            or chatData["post"] == PostType.Text_MemberQuit) then
        return ChatHint
    elseif chatData["post"] == PostType.Text_MsgGm then
        return ChatItemGM
    elseif chatData["post"] == PostType.Text_FBAlliance_missile_share then
        return ChatItemNeutralAttack
    elseif chatData["post"] == PostType.Text_Formation_Fight_Share then
        return ChatItemMailReportShare
    elseif chatData["post"] == PostType.Text_Missile_Attack then
        return ChatItemMissileAttack
    elseif chatData["post"] == PostType.Text_BattleReportContentShare then
        return ChatItemMailReportContentShare
    elseif chatData["post"] == PostType.Text_ScoutReportContentShare then
        return ChatItemMailScoutResultContentShare
    elseif chatData["post"] == PostType.Text_ScoutAlertContentShare then
        return ChatItemMailScoutAlertContentShare
    elseif chatData["post"] == PostType.Text_ChampionBattleReportShare then
        return ChampionBattleReportShare
    elseif chatData.post == PostType.Text_MailScoutResultShare then
        return ChatItemMailScountResultShare
    elseif chatData.post == PostType.Text_AllianceTaskShare then
        return ChatItemAllianceTaskShare
    elseif chatData.post == PostType.Text_AllianceRecruitShare then
        return ChatItemAllianceRecruitShare
    elseif chatData["post"] == PostType.Text_Formation_Share then
        return ChatItemFormationShare
    elseif chatData["post"] == PostType.RedPackge then
        return ChatItemRedPacketShare
    elseif chatData["post"] == PostType.Text_ActMonsterTowerHelp then
        return isMyChat and ChatItemRight_Normal or ChatItemLeft_Normal
        --elseif chatData["post"] == PostType["Text_AllianceInvite"] then
    --    return ChatItemAllianceShare
    --elseif chatData["post"] == PostType["Text_StartWar"] or chatData["post"] == PostType["Text_EndWar"] or chatData["post"] == PostType["Text_AllianceProduceMine"] then
    --    return nil
    --elseif chatData["post"] == PostType["Text_AllianceWelcome"] then
    --    return nil
    --elseif chatData["post"] == PostType["Text_AllianceRedPack"] or
    --        chatData["post"] == PostType["Text_AllianceTransfer"] or
    --        chatData["post"] == PostType["Text_AllianceRankChange"] or
    --        chatData["post"] == PostType["Text_AllianceOfficialChange"] or
    --        chatData["post"] == PostType["Text_AllianceOfficialSet"] or
    --        chatData["post"] == PostType["Text_AllianceOfficialCancel"] or
    --        chatData["post"] == PostType["Text_AllianceGather"] or
    --        chatData["post"] == PostType["Text_ShareHeroTenGet"] then
    --    return nil
    --elseif chatData["post"] == PostType["Text_AllianceMark"] then
    --    return nil
    --elseif chatData["post"] == PostType["Text_NewServerActivity"] then
    --    return nil
    --elseif chatData["post"] == PostType["Text_NewServerActivity_New"] then
    --    return nil
    --elseif chatData["post"] == PostType["Text_AllianceMemberInOut"] then
    --    return nil
    else
        return isMyChat and ChatItemRight_Normal or ChatItemLeft_Normal
    end
end


function UIChatMainView:ReLoadChat()
    self:InitChatMsg()
    self._isFetchingMore = false
    self:CheckAbstractRoom()
    -- 检测是否断网
    self:CheckNetIsFine()
    self:CheckShowReturnBtn()
end

function UIChatMainView:CheckNetIsFine()
    if (not ChatManager2:GetInstance().Net:IsRunning()) then
        self:ShowLoading()
    end
end

function UIChatMainView:InitChatMsg()
    self:ClearWaitDelay()
    --self._vScrollBar.anchoredPosition = Vector2.New(100, 0)
	
	self._vScrollBar:Set_anchoredPosition(100, 0)
    self._infoText:SetActive(false)
    self:ReloadData()
    self._scrollView:MovePanelToItemIndex(table.length(self._chatDatas) - 1,0)
end

function UIChatMainView:UpdateScrollbarVisible()
    if(self:IsNeedShowScrollBar()) then
        self._scrollBarImg.color = Color32.New(183, 163, 163, 255)
        self._scrollBarImg:DOPause()
        self._vScrollBar.anchoredPosition = Vector2.New(-4, 0)
    else
        self._vScrollBar.anchoredPosition = Vector2.New(100, 0)
    end
end

function UIChatMainView:IsNeedShowScrollBar()
    return self._scrollView.unity_looplistview2.ContainerTrans.sizeDelta.y > self._scrollView.unity_looplistview2.ViewPortHeight
end

function UIChatMainView:ClearWaitDelay()
    if (self._timerTask ~= nil) then
        self._timerTask:Stop()
    end
    self._timerTask = nil;
end

function UIChatMainView:OnScollValueChange()
    if (not self._scrollView.unity_looplistview2.IsDraging and
        Mathf.Abs(self._scrollView.unity_looplistview2.ScrollRect.velocity.y) < 40 and
        self.delayTimerTask == nil and
        self._scrollBarImg.color.a > 200 and
        self:IsNeedShowScrollBar()) then
       self.delayTimerTask = TimerManager:GetInstance():GetTimer(0.3, function()
           if (self._scrollBarImg ~= nil) then
               self._scrollBarImg:DOFade(0, 0.2);
           end
           if (self.delayTimerTask ~= nil) then
               self.delayTimerTask:Stop()
               self.delayTimerTask = nil
           end
       end , self, true,false,false) 
        self.delayTimerTask:Start()
    end
    self:CheckShowReturnBtn()
end

--[[
    在这个地方做一个特殊处理,因为目前连接聊天服务器比较慢,所以经常导致进入游戏了,点开聊天界面,此时没有频道,这个时候我们虚拟了两个空白频道
    世界/联盟(按照是否有联盟来判定),当聊天连接上之后,我们需要做刷新,这个时候我们按照之前如果 self._chatDatas 之前 == {}，这个时候有了数据来做判定依据
    这种情况下我们直接将聊天窗置于框底部
]]
function UIChatMainView:ReloadData()
    self:ClearChatDatas()
    local roomMsgs = self:GetRoomMsgs()
    if (roomMsgs ~= nil) then
        local lastChatDate = 0
        for k, chatData in ipairs(roomMsgs) do
            local sendTime = chatData:getCreateTime()
            if (Mathf.Abs(sendTime-lastChatDate) > 60) then
                lastChatDate = sendTime
                self._chatDatas[#self._chatDatas+1] = chatData
                self._timeFlags[table.count(self._chatDatas)] = true
            end
            self._chatDatas[#self._chatDatas+1] = chatData
        end
    end
    self._scrollView:SetListItemCount(self:GetItemCount(), false, false)
    self._scrollView:RefreshAllShownItem()
    if (self._chatDatasCnt == 0 and table.count(self._chatDatas) ~= 0) then
        self._chatDatasCnt = table.count(self._chatDatas)
        self:ScrollToTail()
    end
    
end
function UIChatMainView:UpdateMsgList()
    self:ClearChatDatas()
    local roomMsgs = self:GetRoomMsgs()
    if (roomMsgs ~= nil) then
        local lastChatDate = 0
        for k, chatData in ipairs(roomMsgs) do
            local sendTime = chatData:getCreateTime()
            if (Mathf.Abs(sendTime-lastChatDate) > 60) then
                lastChatDate = sendTime
                self._chatDatas[#self._chatDatas+1] = chatData
                self._timeFlags[table.count(self._chatDatas)] = true
            end
            self._chatDatas[#self._chatDatas+1] = chatData
        end
    end
end
function UIChatMainView:OnSendClick()
    self:ScrollToTail()
    --self:CheckShowReturnBtn()
    --EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().LF_OnSendClick)
end

function UIChatMainView:OnEndDrag()
    if (not self._isFetchingMore) then
        if (self._scrollView.unity_looplistview2.ContainerTrans.localPosition.y <= 0) then
            self:GetHistoricalChat()
        else
            if Mathf.Abs(self._scrollView.unity_looplistview2.ScrollRect.velocity.y) < 40 then
                if self:IsNeedShowScrollBar() then
                    self._scrollBarImg:DOFade(0, 0.2)
                end
            end
        end
    end
    --self:CheckShowReturnBtn()
end

function UIChatMainView:GetHistoricalChat()
    self._isFetchingMore = true
	local roomId = self._chatViewController:GetCurrentRoomId()
    local room = ChatInterface.getRoomData(roomId)
    if (room == nil) then
        return
    end
    -- 查找历史消息
    EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_REQUEST_HISTORY_MSG_COMMAND,room.roomId)
end

function UIChatMainView:HideKeyboard()
    --self._keyboardLayout.transform:GetComponent(typeof(CS.UnityEngine.UI.LayoutElement)).minHeight = 10
    --self._topLayout.transform:GetComponent(typeof(CS.UnityEngine.UI.LayoutElement)).minHeight = 55
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate( self._scrollView.transform.parent:GetComponent(typeof(CS.UnityEngine.RectTransform)))
    self._scrollView:RefreshAllShownItem()
end

function UIChatMainView:ShowKeyboard( height )
    --self._keyboardLayout.transform:GetComponent(typeof(CS.UnityEngine.UI.LayoutElement)).minHeight = height
    --self._topLayout.transform:GetComponent(typeof(CS.UnityEngine.UI.LayoutElement)).minHeight = 55
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate( self._scrollView.transform.parent:GetComponent(typeof(CS.UnityEngine.RectTransform)))
    self:ScrollToTail()
end


return UIChatMainView