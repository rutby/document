---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/6/15 11:50
---
local ChatViewController = require "UI.UIChatNew.Controller.ChatViewUtils"
local PlayerItemShow =
{
    pic ="",
    name = "",
    type = PLayerInfoButtonType.None,
    positionId = 0
}
local PlayerInfoShow =
{
    uid = "",
    name = "",
    allianceName ="",
    power ="",
    kill = "",
    isSelf =false,
    positionId = 0
}
local OneData = DataClass("OneData", PlayerItemShow)
local InfoShow = DataClass("InfoShow", PlayerInfoShow)
local UIOtherPlayerInfoCtrl = BaseClass("UIOtherPlayerInfoCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIOtherPlayerInfo)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitData(self,uid)
    if uid ~=nil then
        self.uid = uid
    else
        self.uid = LuaEntry.Player.uid
    end
    
	local info =  DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(self.uid)
	if info==nil then
        SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, self.uid)
	else
		EventManager:GetInstance():Broadcast(EventId.GetNewUserInfoSucc)
	end
end
local function GetUid(self)
    return self.uid
end
local function GetPlayerInfoShowByUid(self,uid)
    local info =  DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(uid)
    local oneData = InfoShow.New()
    if info~=nil then
        oneData.isSelf = false --(DataCenter.PlayerInfoDataManager:GetSelfUid() == info.uid)
        oneData.uid = info.uid
        oneData.serverId = info.serverId
        oneData.name = info.name
        if info.alAbbr~="" then
            oneData.allianceName = "["..info.alAbbr.."]"..info.allianceName
            oneData.alAbbr = info.alAbbr
        else
            oneData.allianceName = ""
            oneData.alAbbr = ""
        end
        oneData.pic = info.pic
        oneData.picVer = info.picVer
        oneData.nation = info and info.countryFlag or DefaultNation
        oneData.headSkinId = info.headSkinId
        oneData.headSkinET = info.headSkinET
        oneData.serverId = info.serverId
        oneData.headBg = info:GetHeadBgImg()
        oneData.power = string.GetFormattedSeperatorNum(info.power)
        oneData.kill = string.GetFormattedSeperatorNum(info.armyKill)
        oneData.level = info.level
        oneData.moodStr = info.moodStr
        oneData.careerType = info.careerType
        oneData.careerLv = info.careerLv
        oneData.icon = info.alIcon
        oneData.sex = info.sex
        oneData.positionId = info:GetPositionId()
		oneData.exploitRank = info.exploitRank
    end
    return oneData
end
local function GetPlayerButtonList(self,uid, serverId)
    local typeList = {}
    local showList = {}
    if uid == DataCenter.PlayerInfoDataManager:GetSelfUid() then
		table.insert(typeList,PLayerInfoButtonType.MoreMessage)
        table.insert(typeList,PLayerInfoButtonType.RankList)
        table.insert(typeList,PLayerInfoButtonType.Setting)
        --table.insert(typeList,PLayerInfoButtonType.Bag)
        table.insert(typeList,PLayerInfoButtonType.ActivityCenter)
       -- table.insert(typeList,PLayerInfoButtonType.Search)
    else --不是自己的
		table.insert(typeList,PLayerInfoButtonType.MoreMessage)
        table.insert(typeList,PLayerInfoButtonType.Talk)
        if not serverId or serverId == LuaEntry.Player.serverId then
            table.insert(typeList,PLayerInfoButtonType.Alliance)
        end
	end
    table.walk(typeList,function (k,v)
        if v== PLayerInfoButtonType.MoreMessage then
            local data = OneData.New()
            data.type = v
            data.name = Localization:GetString("390001")
            data.pic = "Assets/Main/Sprites/UI/UISet/New/UISet_btn_info.png"
            table.insert(showList,data)
        elseif v== PLayerInfoButtonType.RankList then
            local data = OneData.New()
            data.type = v
            data.name = Localization:GetString("390040")
            data.pic = "Assets/Main/Sprites/UI/UISet/New/UISet_btn_rank.png"
            table.insert(showList,data)
        elseif v== PLayerInfoButtonType.Setting then
            local data = OneData.New()
            data.type = v
            data.name = Localization:GetString("280012")
            data.pic = "Assets/Main/Sprites/UI/UISet/New/UISet_btn_setting.png"
            table.insert(showList,data)
        elseif v== PLayerInfoButtonType.ActivityCenter then
            local data = OneData.New()
            data.type = v
            data.name = Localization:GetString("360021")
            data.pic = "Assets/Main/Sprites/UI/UISet/New/UISet_btn_info.png"
            table.insert(showList,data)
        elseif v== PLayerInfoButtonType.Alliance then
            local data = OneData.New()
            data.type = v
            data.name = Localization:GetString(GameDialogDefine.ALLIANCE)
            data.pic = "Assets/Main/Sprites/UI/UISet/New/UISet_btn_alliance.png"
            table.insert(showList, data)
        elseif v== PLayerInfoButtonType.Talk then
            local data = OneData.New()
            data.type = v
            data.name = Localization:GetString("110053")
            data.pic = "Assets/Main/Sprites/UI/UISet/New/UISet_btn_say.png"
            table.insert(showList, data)
        end
    end)
    return showList
end
local function RefreshTalkInfo(self,_userInfo)
   self._userInfo=_userInfo
end

local function OnGotoClick(self,type)
    if type == PLayerInfoButtonType.MoreMessage then
      --  UIUtil.ShowTipsId(120018) 
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIMoreInformation,{ anim = true },self:GetUid())
    elseif type == PLayerInfoButtonType.Setting then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISetting,{ anim = true ,isBlur = true})
    elseif type == PLayerInfoButtonType.RankList then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIRankTable,{ anim = true, hideTop = true, isBlur = true })
    elseif type == PLayerInfoButtonType.Account then
       -- GoToUtil.GotoOpenView(UIWindowNames.UISearch)
        --UIManager:GetInstance():OpenWindow(UIWindowNames.UIRankTable,{ anim = true, back = { ui = UIWindowNames.UIPlayerInfo, anim = false }})
    elseif type == PLayerInfoButtonType.Faq then
       -- GoToUtil.GotoOpenView(UIWindowNames.UIBag)
    elseif type == PLayerInfoButtonType.ActivityCenter then
        GoToUtil.GotoOpenView(UIWindowNames.UIActivityCenterTable, { anim = true, UIMainAnim = UIMainAnimType.AllHide })
	elseif type == PLayerInfoButtonType.Talk then
        -- 这个地方需要判定一下是在聊天界面还是其他界面
        if (UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIChatNew)) then
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIChatRoomSetting) then
                UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatRoomSetting)
                EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_TALK_TO_PRIVATE, self._userInfo)
            else
                local toUid = self._userInfo.uid
                if toUid == nil then
                    toUid = self._userInfo
                end
                local roomId = ""
                local roomData = ChatInterface.getRoomMgr():getPrivateRoomData(toUid)
                roomId = roomData and roomData.roomId or ""
                ChatViewController:GetInstance():SetCurrentRoomId(roomId)
                ChatViewController:GetInstance():SetPrivateUserInfo(self._userInfo)
                EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().LF_ChatCellSelect)
            end
        else
            local userId = self._userInfo.uid
			if userId==nil then
				userId = self._userInfo
			end
            local username = ""
            local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(userId)
            if (info ~= nil and not string.IsNullOrEmpty(info.name)) then
                username = info.name
            end
            if (info ~= nil and not string.IsNullOrEmpty(info.alAbbr)) then
                username = "[" .. info.alAbbr .. "]" .. username
            end
            local roomId = ""
            roomId = ChatManager2:GetInstance().Room:GetPrivateRoomByUserId(userId)
            local param = {}
            param["roomId"] = roomId
            param["userId"] = userId
            param["username"] = username
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatNew,{anim = false},param)
        end
		
		self:CloseSelf()
		--和某个人私聊
		
	elseif type == PLayerInfoButtonType.Alliance then
        if not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUND_BUILD_ALLIANCE_CENTER) then
            return UIUtil.ShowTipsId(121373)
        end
		local uid = self:GetUid()
		local info =  DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(uid)
		if info==nil then
			UIUtil.ShowTipsId(390794) 
		else
			local allianceName = info.allianceName
			if allianceName=="" then
				UIUtil.ShowTipsId(390794) 
			else
                if LuaEntry.Player:GetAllianceUid() == info.allianceId then
					UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail,{ anim = true, isBlur = true},allianceName,info.allianceId)
                    self:CloseSelf()
                else
				    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail,{ anim = true, isBlur = true},allianceName,info.allianceId)
                    self:CloseSelf()
                end
			end

		end

	end
end

local function OnPhotoClick(self)

end
local function OnIconClick(self)

end
local function OnChangeNameClick(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChangeName,{anim = true})
end
local function OnKillDesClick(self)

end

UIOtherPlayerInfoCtrl.CloseSelf = CloseSelf
UIOtherPlayerInfoCtrl.Close = Close
UIOtherPlayerInfoCtrl.InitData =InitData
UIOtherPlayerInfoCtrl.GetPlayerInfoShowByUid =GetPlayerInfoShowByUid
UIOtherPlayerInfoCtrl.GetPlayerButtonList =GetPlayerButtonList
UIOtherPlayerInfoCtrl.GetUid = GetUid
UIOtherPlayerInfoCtrl.OnGotoClick = OnGotoClick
UIOtherPlayerInfoCtrl.OnPhotoClick = OnPhotoClick
UIOtherPlayerInfoCtrl.OnIconClick = OnIconClick
UIOtherPlayerInfoCtrl.OnChangeNameClick = OnChangeNameClick
UIOtherPlayerInfoCtrl.OnKillDesClick = OnKillDesClick
UIOtherPlayerInfoCtrl.RefreshTalkInfo=RefreshTalkInfo
return UIOtherPlayerInfoCtrl