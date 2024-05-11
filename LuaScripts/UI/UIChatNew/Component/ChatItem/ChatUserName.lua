---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 6/18/21 5:31 PM
---
--[[
    玩家名字
]]

local ChatUserName = BaseClass("ChatUserName", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ChatViewController = require "UI.UIChatNew.Controller.ChatViewUtils"
local ChatMessageHelper = require "Chat.Other.ChatMessageHelper"

local _cp_namelable = "Line/NameText";
local _cp_vipFrame = "Line/VipFrame"
local _cp_vipText = "Line/VipFrame/Text";
local _cp_nameTransform = "Line"
--local _cp_allianceOfficialPos = "Line/UIAlOfficialPos"
local _cp_sexImg = "Line/SexNode/SexImg"
local _cp_sexNode = "Line/SexNode"
local _cp_positionImg = "Line/PositionNode/PositionImg"
local _cp_positionNode = "Line/PositionNode"
local _cp_titleNode = "Line/TitleNode"
local _cp_titleImg = "Line/TitleNode/TitleImg"
local _cp_titleTxt = "Line/TitleNode/TitleTxt"
local _cp_campImg = "Line/CampNode/CampImg"
local _cp_campNode = "Line/CampNode"
local HEIGHT_SHORT = 24
--local HEIGHT_TALL = 66
local HEIGHT_TALL = 24
--local TOP_OFFSET = 25
local TOP_OFFSET = 0

function ChatUserName:ComponentDefine()
    self._nameLable = self:AddComponent(UITextMeshProUGUIEx, _cp_namelable)
    self._vipFrame = self:AddComponent(UIImage, _cp_vipFrame)
    self._vipText = self:AddComponent(UITextMeshProUGUIEx, _cp_vipText)
    self._nameTransform = self:AddComponent(UIBaseContainer, _cp_nameTransform)
    --self._alOfficialPos = self:AddComponent(UIAlOfficialPos, _cp_allianceOfficialPos)
    self._sexImg = self:AddComponent(UIImage, _cp_sexImg)
    self._sexNode = self:AddComponent(UIBaseContainer, _cp_sexNode)
    self._campImg = self:AddComponent(UIImage, _cp_campImg)
    self._campNode = self:AddComponent(UIBaseContainer, _cp_campNode)
    self._positionImg = self:AddComponent(UIImage, _cp_positionImg)
    self._positionNode = self:AddComponent(UIBaseContainer, _cp_positionNode)
    self._titleNode = self:AddComponent(UIBaseContainer, _cp_titleNode)
    self._titleImg = self:AddComponent(UIImage, _cp_titleImg)
    self._titleTxt = self:AddComponent(UITextMeshProUGUIEx, _cp_titleTxt)
end

function ChatUserName:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
end

function ChatUserName:UpdateName( userInfo, chatData )
    if (userInfo == nil) then
        self._nameLable:SetText("")
        self:UpdateVIP(userInfo)
        return
    end
    local senderName = chatData:getSenderNameWithAlliance()
    local serverId = userInfo:getServerId()
    self:ComposeName(senderName, serverId)
    self:UpdateVIP(userInfo)
    self:UpdateAlOfficialPos(userInfo, chatData)
    self:UpdateSex(userInfo.sex)
    self:UpdateCamp(userInfo.allianceId)
    self:UpdatePositionImg(userInfo.positionId)
    local showTitle = self:UpdateTitle(userInfo.titleSkinId, userInfo.titleSkinET)
end

function ChatUserName:ComposeName(senderName, serverId)
    local myServerId = ChatInterface.getSrcServerId()
    if serverId~=myServerId and serverId~=nil and serverId>0 then
        senderName = "#"..serverId..senderName
        self._nameLable:SetColor(Color32.red)
    else
        self._nameLable:SetColor(Color32.New(72/255, 46/255, 40/255, 1))
    end
	local roomId = ChatViewController:GetInstance():GetCurrentRoomId()
    local room = ChatInterface.getRoomData(roomId)
	
    --if (serverId ~= 0 and serverId ~= myServerId and room["group"] == "country") then
    --    self._nameLable:SetColor(Color32.red)
    --else
    --    self._nameLable:SetColor(Color32.New(101/255, 50/255, 20/255, 1))
    --end
    self._nameLable:SetText(senderName)
    local horizontalLayoutGroup = self._nameTransform.transform:GetComponent(typeof(CS.UnityEngine.UI.HorizontalLayoutGroup))
    local _width = self._nameLable:GetWidth() + horizontalLayoutGroup.spacing + horizontalLayoutGroup.padding.left + horizontalLayoutGroup.padding.right
    --self._nameTransform.rectTransform.sizeDelta = Vector2.New(_width, self._nameTransform.rectTransform.sizeDelta.y)
	
	local cx, cy = self.rectTransform:Get_sizeDelta()
	self.rectTransform:Set_sizeDelta(_width, cy)
end

function ChatUserName:UpdateVIP( userInfo )
    if (userInfo == nil) then
        self._vipFrame:SetActive(false)
        return
    end
    local svipLevel = tonumber(userInfo["svipLevel"])
    local vipframe = tonumber(userInfo["vipframe"])
    if (svipLevel > 0 and vipframe > 0) then
        self._vipFrame:SetActive(true)
        self._vipText:SetLocalText(103001, svipLevel) 
    else
        self._vipFrame:SetActive(false)
    end
end

function ChatUserName:UpdateAlOfficialPos(userInfo, chatData)
    if chatData ~= nil and chatData.roomId ~= nil and chatData.post ~= nil then
        --联盟邀请的时候，房间为nil
        local channelType = ChatMessageHelper.getChannelFromRoomId(chatData.roomId, chatData.post)
        if channelType ~= ChatShareChannel.TO_ALLIANCE then
            --self._alOfficialPos:SetActive(false)
            return
        end
    end
    
    if not userInfo then
        --self._alOfficialPos:SetActive(false)
        return
    end
    
    --self._alOfficialPos:SetData(userInfo)
    local w, h = self.rectTransform:Get_sizeDelta()
    self.rectTransform:Set_sizeDelta(w, self:GetHeight())
end

function ChatUserName:GetHeight()
    return HEIGHT_SHORT
end

function ChatUserName:GetTopOffset()
    return  0
end

function ChatUserName:UpdateSex(sex)
    local iconName = SexUtil.GetSexIconName(sex)
    if iconName ~= nil and iconName ~= "" then
        self._sexNode:SetActive(true)
        self._sexImg:LoadSprite(iconName)
    else
        self._sexNode:SetActive(false)
    end
end

function ChatUserName:UpdateCamp(allianceId)
    local show = false
    local pic = ""
    if LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
        if allianceId~=nil and allianceId~="" then
            local camp = DataCenter.GloryManager:GetCampByAllianceId(allianceId)
            if camp ~= 0 then
                show = true
                pic = "Assets/Main/Sprites/LodIcon/eden_camp_"..camp
            end
        end
    end
    
    if show ==true then
        self._campNode:SetActive(true)
        self._campImg:LoadSprite(pic)
    else
        self._campNode:SetActive(false)
    end
end

function ChatUserName:UpdatePositionImg(positionId)
    --策划要求不显示了
    self._positionNode:SetActive(false)
    return
    
    --if positionId ~= nil and positionId ~= 0 then
    --    local template = DataCenter.GovernmentTemplateManager:GetTemplate(positionId)
    --    if template ~= nil then
    --        self._positionNode:SetActive(true)
    --        self._positionImg:LoadSprite(template.icon)
    --    else
    --        self._positionNode:SetActive(false)
    --    end
    --else
    --    self._positionNode:SetActive(false)
    --end
end

function ChatUserName:UpdateTitle(titleSkinId, titleSkinET)
    if titleSkinId == nil then
        titleSkinId = 0
    end
    if titleSkinET == nil then
        titleSkinET = 0
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local skinId = -1
    if titleSkinET == 0 or titleSkinET > curTime then       --永久或未过期
        skinId = titleSkinId
    else                                                    --称号过期,视为默认称号，默认称号不显示
        --skinId = DataCenter.DecorationDataManager:GetDefaultSkinIdByType(DecorationType.DecorationType_TittleName)
        self._titleNode:SetActive(false)
        return false
    end
    if skinId <= 0 then
        --skinId = DataCenter.DecorationDataManager:GetDefaultSkinIdByType(DecorationType.DecorationType_TittleName)
        self._titleNode:SetActive(false)
        return false
    end
    self._titleNode:SetActive(true)
    local template = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
    local name = template.name
    local icon = template.img.."_chat"
    self._titleImg:LoadSprite(icon)
    self._titleTxt:SetLocalText(name)
    return true
end

return ChatUserName