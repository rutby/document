---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 6/15/21 4:47 PM
---
---
local ChatRoomCell = BaseClass("ChatRoomCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ChatViewController = require("UI.UIChatNew.Controller.ChatViewUtils")
local ChatHead = require("UI.UIChatNew.Component.ChatHead")

local _cp_selectedImage = "SelectedImage";

-- local _cp_imgWorldSelect = "ImageTemplate/imgWorldSelect"
-- local _cp_imgWorldUnSelect = "ImageTemplate/imgWorldUnSelect"
-- local _cp_imgAllianceSelect = "ImageTemplate/imgAllianceSelect"
-- local _cp_imgAllianceUnSelect = "ImageTemplate/imgAllianceUnSelect"
-- local _cp_imgTaskSelect = "ImageTemplate/imgTaskSelect"
-- local _cp_imgTaskUnSelect = "ImageTemplate/imgTaskUnSelect"
-- local _cp_imgRadarSelect = "ImageTemplate/imgRadarSelect"
-- local _cp_imgRadarUnSelect = "ImageTemplate/imgRadarUnSelect"
-- local _cp_imgAlAutoInviteSelect = "ImageTemplate/imgAlAutoInviteSelect"
-- local _cp_imgAlAutoInviteUnSelect = "ImageTemplate/imgAlAutoInviteUnSelect"
-- local _cp_imgCrossServer = "ImageTemplate/imgCrossServer"
-- local _cp_imgDragonServer = "ImageTemplate/imgDragonServer"
-- local _cp_imgLangUnSelect = "ImageTemplate/imgLangUnSelect"
-- local _cp_imgLangSelect = "ImageTemplate/imgLangSelect"

--local _cp_objPlayerHead = "SlidingNode/UIPlayerHead"
local _cp_imgPlayerHead = "SlidingNode/UIPlayerHead/HeadIcon"
--local _cp_objGroup = "SlidingNode/Group"

--local _cp_IconImage = "SlidingNode/Image/IconImage"
local _cp_newMsgImage = "SlidingNode/RedPointNum"
local _cp_txtNewMsg = "SlidingNode/RedPointNum/Text"
local _cp_offText = "SlidingNode/OffName"
local _cp_onText = "SlidingNode/OnName"
--local _cp_SlidingNode = "SlidingNode"
local _cp_addBtn = "AddButton"
local _cp_txtAddBtn = "AddButton/txtAddButton"
local _cp_bgBtn = "SlidingNode/Button"


function ChatRoomCell:ComponentDefine()
    self._selectedImage = self:AddComponent(UIImage, _cp_selectedImage)
    
    -- self._imgWorldSelect = self:AddComponent(UIImage, _cp_imgWorldSelect):GetImage()
    -- self._imgWorldUnSelect = self:AddComponent(UIImage, _cp_imgWorldUnSelect):GetImage()
    -- self._imgAllianceSelect = self:AddComponent(UIImage, _cp_imgAllianceSelect):GetImage()
    -- self._imgAllianceUnSelect = self:AddComponent(UIImage, _cp_imgAllianceUnSelect):GetImage()
    -- self._imgTaskSelect = self:AddComponent(UIImage, _cp_imgTaskSelect):GetImage()
    -- self._imgTaskUnSelect = self:AddComponent(UIImage, _cp_imgTaskUnSelect):GetImage()
    -- self._imgRadarSelect = self:AddComponent(UIImage, _cp_imgRadarSelect):GetImage()
    -- self._imgRadarUnSelect = self:AddComponent(UIImage, _cp_imgRadarUnSelect):GetImage()
    -- self._imgAlAutoInviteSelect = self:AddComponent(UIImage, _cp_imgAlAutoInviteSelect):GetImage()
    -- self._imgAlAutoInviteUnSelect = self:AddComponent(UIImage, _cp_imgAlAutoInviteUnSelect):GetImage()
    -- self._imgCrossServer = self:AddComponent(UIImage, _cp_imgCrossServer):GetImage()
    -- self._imgDragonServer = self:AddComponent(UIImage, _cp_imgDragonServer):GetImage()
    -- self._imgLangUnSelect = self:AddComponent(UIImage,_cp_imgLangUnSelect):GetImage()
    -- self._imgLangSelect = self:AddComponent(UIImage,_cp_imgLangSelect):GetImage()
    local path = "ImageTemplate/imgCamp1"
    local selfCamp = DataCenter.RobotWarsManager:GetSelfCamp()
    if selfCamp and selfCamp ~= -1 then
        path = "ImageTemplate/imgCamp"..selfCamp
    end
    local CampComponent = self:AddComponent(UIImage,path)
    self._imgEdenCamp = CampComponent:GetImage()
   --self._objPlayerHead = self:AddComponent(ChatHead, _cp_objPlayerHead)
    -- self._objGroup = self:AddComponent(UIBaseContainer, _cp_objGroup)
    -- self._objGroupHoris = {}
    -- self._objGroupHoris[1] = self:AddComponent(UIBaseContainer, "SlidingNode/Group/Vert/Hori1")
    -- self._objGroupHoris[2] = self:AddComponent(UIBaseContainer, "SlidingNode/Group/Vert/Hori2")
    -- self._objGroupHeads = {}
    -- self._objGroupHeads[1] = self:AddComponent(UIPlayerHead, "SlidingNode/Group/Vert/Hori1/GroupIcon1")
    -- self._objGroupHeads[2] = self:AddComponent(UIPlayerHead, "SlidingNode/Group/Vert/Hori1/GroupIcon2")
    -- self._objGroupHeads[3] = self:AddComponent(UIPlayerHead, "SlidingNode/Group/Vert/Hori2/GroupIcon3")
    -- self._objGroupHeads[4] = self:AddComponent(UIPlayerHead, "SlidingNode/Group/Vert/Hori2/GroupIcon4")
    
    self._txtAddBtn = self:AddComponent(UIText, _cp_txtAddBtn)
    --self._iconImage = self:AddComponent(UIImage, _cp_IconImage)
    self._newMsgImage = self:AddComponent(UIImage, _cp_newMsgImage)
    self._newMsgCountText = self:AddComponent(UITextMeshProUGUIEx, _cp_txtNewMsg)
    self._offText = self:AddComponent(UITextMeshProUGUIEx, _cp_offText)
    self._onText = self:AddComponent(UITextMeshProUGUIEx, _cp_onText)
    
    --self._slidingNode = self.transform:Find(_cp_SlidingNode)
    self._addBtn = self:AddComponent(UIButton, _cp_addBtn)	
	self._bgBtn = self:AddComponent(UIButton_LongPress, _cp_bgBtn)
    self._bgBtn:SetClickAction(function ()
        self:Selected()
    end)
    self._bgBtn:SetLongPressAction(function ()
        if not self:IsPrivateChat() then
            return
        end
        local param = {}
        --param["roomdata"] = self._roomData
        param["targetPos"] = self._bgBtn.transform
        param["cellItem"] = self
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatRoomCellOperatorView,{ anim = false }, param)
    end)
	
	self._addBtn:SetOnClick(BindCallback(self, self.CreateNewRoom))

    self._chatViewController = ChatViewController:GetInstance()  -- 设置chatController,用来做辅助功能
end

function ChatRoomCell:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self._txtAddBtn:SetLocalText(290043) 
end

-- 打开
function ChatRoomCell:OnEnable()
    base.OnEnable(self)
end

-- 关闭
function ChatRoomCell:OnDisable()
    base.OnDisable(self)
end

function ChatRoomCell:OnAddListener()
	local ChatEventEnum = ChatInterface.getEventEnum()
    self:AddUIListener(EventId.UPDATE_MSG_USERINFO, self.UpdateUserInfoWithNew);
    self:AddUIListener(ChatInterface.getEventEnum().CHAT_RECIEVE_ROOM_MSG, self.UpdateNewMsgHint);
    self:AddUIListener(EventId.GetRedPacketUpdate, self.UpdateNewMsgHint)
    self:AddUIListener(EventId.OnGetNewAllianceAutoInvite, self.UpdateNewMsgHint)
    --self:AddUIListener(EventId.MainTaskSuccess, self.UpdateNewMsgHint)
    self:AddUIListener(EventId.UpdateChatQuestRed, self.UpdateChatQuestRed)
end

function ChatRoomCell:OnRemoveListener()
	local ChatEventEnum = ChatInterface.getEventEnum()
    self:RemoveUIListener(EventId.UPDATE_MSG_USERINFO, self.UpdateUserInfoWithNew);
    self:RemoveUIListener(ChatInterface.getEventEnum().CHAT_RECIEVE_ROOM_MSG, self.UpdateNewMsgHint);
    self:RemoveUIListener(EventId.GetRedPacketUpdate, self.UpdateNewMsgHint)
    self:RemoveUIListener(EventId.OnGetNewAllianceAutoInvite, self.UpdateNewMsgHint)
    --self:RemoveUIListener(EventId.MainTaskSuccess, self.UpdateNewMsgHint)
    self:RemoveUIListener(EventId.UpdateChatQuestRed, self.UpdateChatQuestRed)
end

function ChatRoomCell:UpdateUserInfoWithNew( userInfo )
    if (userInfo == nil) then
        return
    end
    
    if (string.contains(self._roomData["roomId"], userInfo["uid"])) then
        self:UpdateRoomName()
        self:UpdateLastChat()
    end
end

function ChatRoomCell:UpdateRoomName()
    local ss = self._roomData:getRoomName()
    self._offText:SetText(self._roomData:getRoomName())
    self._onText:SetText(self._roomData:getRoomName())
end

function ChatRoomCell:IsQuestCell()
    if (not table.IsNullOrEmpty(self._roomData) and self._roomData["group"] == ChatGroupType.GROUP_QUEST) then
        return true
    end
    return false
end

function ChatRoomCell:setData( roomData )
    self._roomData = roomData
    if (self._roomData ~= nil) then
        self._addBtn:SetActive(false)
        self:InitState();
        self:InitRoomIconAndName();
    else
        --self._objPlayerHead:SetActive(false)
        --self._objGroup:SetActive(false)
        self._addBtn:SetActive(true)
    end
end

function ChatRoomCell:InitState()
    if (self._roomData == nil) then
        return
    end
    local currentRoomId = self._chatViewController:GetCurrentRoomId()
    local roomId = self._roomData["roomId"]
    
    if (currentRoomId == roomId) then
        self._selectedImage:LoadSprite(string.format(LoadPath.ChatFolder, "sj_yeqian_yiji"))
        self._offText:SetActive(false)
        self._onText:SetActive(true)
        self:SetIconSelect()
        EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().LF_UPDATE_UIMAIN_CHAT_MSG)
    else
        self._selectedImage:LoadSprite(string.format(LoadPath.ChatFolder, "sj_yeqian_yiji2"))
        self._offText:SetActive(true)
        self._onText:SetActive(false)
        self:SetIconUnSelect()
    end
    self:UpdateLastChat()
end

function ChatRoomCell:InitRoomIconAndName()
    if (self._roomData == nil) then
        return
    end
    --self:SetIconUnSelect()
    self:UpdateRoomName()
    self:CheckHeadState()
end

function ChatRoomCell:IsPrivateChat()
    if self._roomData:isWorldRoom() then
        return false
    elseif self._roomData:isAllianceRoom() then
        return false
    elseif self._roomData:IsCross() then
        return false
    elseif self._roomData:IsDragonServer() then
        return false
    elseif self._roomData:IsGmRoom() then
        return false
    elseif self._roomData["group"] == ChatGroupType.GROUP_CUSTOM and string.find(self._roomData["roomId"], "lang") then
        return false
    else
        return self._roomData:isPrivateChat()
    end
end

function ChatRoomCell:CheckHeadState()
    -- if (self._roomData["group"] == "country") then
    --     self._objPlayerHead:SetActive(false)
    --     self._objGroup:SetActive(false)
    --     self._iconImage:SetActive(true)
    -- elseif self._roomData["group"] == "alliance" then
    --     self._objPlayerHead:SetActive(false)
    --     self._objGroup:SetActive(false)
    --     self._iconImage:SetActive(true)
    -- elseif self._roomData["group"] == QuestRoomGroup then
    --     self._objPlayerHead:SetActive(false)
    --     self._objGroup:SetActive(false)
    --     self._iconImage:SetActive(true)
    -- elseif self._roomData["group"] == RadarRoomGroup then
    --     self._objPlayerHead:SetActive(false)
    --     self._objGroup:SetActive(false)
    --     self._iconImage:SetActive(true)
    -- elseif self._roomData["group"] == RadarRoomGroup then
    --     self._objPlayerHead:SetActive(false)
    --     self._objGroup:SetActive(false)
    --     self._iconImage:SetActive(true)
    -- elseif self._roomData["group"] == ChatGroupType.GROUP_AL_AUTO_INVITE then
    --     self._objPlayerHead:SetActive(false)
    --     self._objGroup:SetActive(false)
    --     self._iconImage:SetActive(true)
    -- elseif self._roomData["group"] == ChatGroupType.GROUP_CROSS_SERVER then
    --     self._objPlayerHead:SetActive(false)
    --     self._objGroup:SetActive(false)
    --     self._iconImage:SetActive(true)
    -- elseif self._roomData["group"] == ChatGroupType.GROUP_DRAGON_SERVER then
    --     self._objPlayerHead:SetActive(false)
    --     self._objGroup:SetActive(false)
    --     self._iconImage:SetActive(true)
    -- elseif self._roomData["group"] == ChatGroupType.GROUP_EDEN_CAMP then
    --     self._objPlayerHead:SetActive(false)
    --     self._objGroup:SetActive(false)
    --     self._iconImage:SetActive(true)
    -- elseif self._roomData:IsGmRoom() then
    --     self._objPlayerHead:SetActive(true)
    --     self._objGroup:SetActive(false)
    --     self:ShowGmIcon()
    --     self._iconImage:SetActive(false)
    -- elseif self._roomData["group"] == ChatGroupType.GROUP_CUSTOM and string.find(self._roomData["roomId"], "lang") then
    --     self._objPlayerHead:SetActive(false)
    --     self._objGroup:SetActive(false)
    --     self._iconImage:SetActive(true)
    -- elseif self._roomData["group"] == ChatGroupType.GROUP_CUSTOM and #self._roomData:getMemberList() == 2 then
    --     self._objPlayerHead:SetActive(true)
    --     self._objGroup:SetActive(false)
    --     self:ShowUserHead()
    --     self._iconImage:SetActive(false)
    -- elseif self._roomData["group"] == ChatGroupType.GROUP_CUSTOM and #self._roomData:getMemberList() ~= 2 then
    --     self._objPlayerHead:SetActive(false)
    --     self._objGroup:SetActive(true)
    --     self:ShowGroup()
    --     self._iconImage:SetActive(false)
    -- else
    --     self._objPlayerHead:SetActive(true)
    --     self._objGroup:SetActive(false)
    --     self:ShowUserHead()
    --     self._iconImage:SetActive(false)
    -- end
end

function ChatRoomCell:ShowGroup()
    local memberList = self._roomData:getMemberList() or {}
    -- for i = 1, 4 do
    --     local uid = memberList[i]
    --     if uid then
    --         local userData = ChatInterface.getUserData(uid)
    --         self._objGroupHeads[i]:SetActive(true)
    --         self._objGroupHeads[i]:SetData(uid, userData.headPic, userData.headPicVer)
    --     else
    --         self._objGroupHeads[i]:SetActive(false)
    --     end
    -- end
    -- self._objGroupHoris[2]:SetActive(#memberList >= 3)
end

function ChatRoomCell:ShowGmIcon()
    local userInfo = ChatInterface.getUserMgr():CreateUserInfo()
    userInfo.uid = ChatGMUserId
    -- if (self._objPlayerHead ~= nil) then
    --     self._objPlayerHead:UpdateHead(userInfo)
    -- end
end

function ChatRoomCell:ShowUserHead()
    local senderUid = ""
    local memberList = self._roomData["memberList"] or {}
    for _, memUid in pairs(memberList) do
        if (memUid ~= LuaEntry.Player.uid) then
            senderUid = memUid
            break
        end
    end
    if (string.IsNullOrEmpty(senderUid)) then
        return
    end
    self._userInfo = ChatInterface.getUserData(senderUid)
    -- if (self._objPlayerHead ~= nil) then
    --     self._objPlayerHead:UpdateHead(self._userInfo, self._chatData)
    -- end
end

function ChatRoomCell:SetIconUnSelect()
    -- if (self._roomData["group"] == "country") then
    --     self._iconImage:SetImage(self._imgWorldUnSelect)
    -- elseif self._roomData["group"] == "alliance" then
    --     self._iconImage:SetImage(self._imgAllianceUnSelect)
    -- elseif self._roomData["group"] == QuestRoomGroup then
    --     self._iconImage:SetImage(self._imgTaskUnSelect)
    -- elseif self._roomData["group"] == RadarRoomGroup then
    --     self._iconImage:SetImage(self._imgRadarUnSelect)
    -- elseif self._roomData["group"] == ChatGroupType.GROUP_AL_AUTO_INVITE then
    --     self._iconImage:SetImage(self._imgAlAutoInviteUnSelect)
    -- elseif self._roomData["group"] == ChatGroupType.GROUP_CROSS_SERVER then
    --     self._iconImage:SetImage(self._imgCrossServer)
    -- elseif self._roomData["group"] == ChatGroupType.GROUP_DRAGON_SERVER then
    --     self._iconImage:SetImage(self._imgDragonServer)
    -- elseif self._roomData["group"] == ChatGroupType.GROUP_EDEN_CAMP then
    --     self._iconImage:SetImage(self._imgEdenCamp)
    -- elseif self._roomData["group"] == ChatGroupType.GROUP_CUSTOM and string.find(self._roomData["roomId"], "lang") then
    --     self._iconImage:SetImage(self._imgLangUnSelect)
    -- end
end

function ChatRoomCell:SetIconSelect()
    -- if (self._roomData["group"] == "country") then
    --     self._iconImage:SetImage(self._imgWorldSelect)
    -- elseif self._roomData["group"] == "alliance" then
    --     self._iconImage:SetImage(self._imgAllianceSelect)
    -- elseif self._roomData["group"] == QuestRoomGroup then
    --     self._iconImage:SetImage(self._imgTaskSelect)
    -- elseif self._roomData["group"] == RadarRoomGroup then
    --     self._iconImage:SetImage(self._imgRadarSelect)
    -- elseif self._roomData["group"] == ChatGroupType.GROUP_AL_AUTO_INVITE then
    --     self._iconImage:SetImage(self._imgAlAutoInviteSelect)
    -- elseif self._roomData["group"] == ChatGroupType.GROUP_CROSS_SERVER then
    --     self._iconImage:SetImage(self._imgCrossServer)
    -- elseif self._roomData["group"] == ChatGroupType.GROUP_DRAGON_SERVER then
    --     self._iconImage:SetImage(self._imgDragonServer)
    -- elseif self._roomData["group"] == ChatGroupType.GROUP_EDEN_CAMP then
    --     self._iconImage:SetImage(self._imgEdenCamp)
    -- elseif self._roomData["group"] == ChatGroupType.GROUP_CUSTOM and string.find(self._roomData["roomId"], "lang")  then
    --     self._iconImage:SetImage(self._imgLangSelect)
    -- end
end

function ChatRoomCell:UpdatePrivateRoomIcon()
end

function ChatRoomCell:UpdateChatQuestRed(num)
    self:UpdateNewMsgHint(num)
end

function ChatRoomCell:UpdateLastChat( tmpRoomId )
    tmpRoomId = tmpRoomId or ""
    if (self._roomData == nil) then
        return
    end
    local roomId = self._roomData["roomId"]
    if (tmpRoomId ~= "" and tmpRoomId ~= roomId) then
        return
    end
    self:UpdateNewMsgHint()
end

function ChatRoomCell:UpdateNewMsgHint(num)
    if (self._roomData == nil) then
        return
    end
    local roomId = self._roomData["roomId"]
	local roomMgr = ChatInterface.getRoomMgr()
	local roomData = roomMgr:GetRoomData(roomId)
	local count = 0
	if roomData then 
    	count = roomData:getNewMsgNum()
	end
	
    local currentRoomId = self._chatViewController:GetCurrentRoomId()

    local otherNum = 0
    if self._roomData["group"] == "alliance" then
        otherNum =  DataCenter.AllianceRedPacketManager:GetValidRedPacketNum()
        count = count + otherNum
    elseif self._roomData["group"] == "quest" then
        --主线任务是否开启
        local chapterList = DataCenter.ChapterTaskManager:GetAllChapterTask()
        if not next(chapterList) then
            local list = DataCenter.TaskManager:GetAllMainTask()
            for i = 1, #list do
                if list[i].state == TaskState.CanReceive then
                    otherNum = otherNum + 1
                end
            end 
            if num and currentRoomId == roomId then
                otherNum = otherNum - num
            end
            count = count + otherNum
        end
    elseif self._roomData["group"] == ChatGroupType.GROUP_AL_AUTO_INVITE then
        local unreadCount = DataCenter.AllianceAutoInviteManager:GetUnreadCount()
        count = unreadCount
    end
    
    if (count > 0) then
        if (currentRoomId == roomId) then
            if otherNum > 0 then
                self._newMsgImage:SetActive(true)
                if otherNum > 99 then
                    self._newMsgCountText:SetText("99")
                else
                    self._newMsgCountText:SetText(otherNum)
                end
            else
                self._newMsgImage:SetActive(false)
            end
			EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_ROOM_SEL, roomId)
        else
            self._newMsgImage:SetActive(true)
            if (count > 99) then
                self._newMsgCountText:SetText("99")
            else
                self._newMsgCountText:SetText(tostring(count))
            end
        end
    else
        self._newMsgImage:SetActive(false)
    end
end

-- 手动点选频道
function ChatRoomCell:Selected()
    if (self._roomData == nil) then
        return
    end
    
	if (self._roomData["roomId"] == self._chatViewController:GetCurrentRoomId()) then
        return
    end
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_common_switch)
	local roomId = self._roomData["roomId"]
    EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().LF_ChatCellSelect, roomId)
    EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_CHECK_UI_MAIN_RED_POINT)
end

function ChatRoomCell:RestoreStateAndSidingNode()
    self:InitState();
end


function ChatRoomCell:CreateNewRoom()
    -- 创建聊天室界面
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatSearchPerson)
end

--function ChatRoomCell:PinClick()
--	local roomId = self._roomData["roomId"]
--	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_ROOM_PIN, roomId)
--
--    EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_REFRESH_CHANNEL)
--end

 --删除房间
function ChatRoomCell:DelClick()
	local roomId = self._roomData["roomId"]
	local room = ChatInterface.getRoomData(roomId)
    local Event = EventManager:GetInstance()
    if room == nil and self._roomData.group == ChatGroupType.GROUP_TMPRoom then
        --临时房间，没进行过聊天
        self.view:DelRoom(roomId)
        Event:Broadcast(ChatInterface.getEventEnum().CHAT_REFRESH_CHANNEL)
    end
    if  room == nil or (not room:isCustomRoom()) then
        return
    end
    if self._roomData:isMyCreateRoom() then
		Event:Broadcast(ChatInterface.getEventEnum().CHAT_ROOM_DISMISS, roomId)
    else
		Event:Broadcast(ChatInterface.getEventEnum().QUIT_ROOM_COMMAND, roomId)
    end
end

function ChatRoomCell:GetRoomId()
    return self._roomData["roomId"] or ""
end

function ChatRoomCell:UpdateItem( _chatdata )
    local a = 1;
end

function ChatRoomCell:IsReceiver( vec2Pos )
    if (self:IsQuestCell()) then
        return false;
    end
    -- 转换成UGUI坐标
    local localPoint = CS.PointUtils.ScreenPointToLocalPointInRectangle(self.rectTransform, vec2Pos, nil)
    local width = self.rectTransform.rect.width
    local height = self.rectTransform.rect.height
    local pivot = self.rectTransform.pivot
    local innerX = localPoint.x + width * pivot.x
    local innerY = localPoint.y + height * pivot.y
    if (innerX > 0 and innerX < width and innerY > 0 and innerY < height) then
        return true
    end
    return false
end

-- 滑动的处理
function ChatRoomCell:OnBeginDrag( eventData )

end

function ChatRoomCell:OnDrag(eventData)

end


function ChatRoomCell:OnEndDrag(eventData)
    
end

--[[ 回归到左侧初始状态 ]]
function ChatRoomCell:ResetLeftAlign()
    
end

return ChatRoomCell