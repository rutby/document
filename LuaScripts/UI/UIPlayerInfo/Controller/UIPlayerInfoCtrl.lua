---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/8/27 21:14
---
local PlayerItemShow =
{
    pic ="",
    name = "",
    type = PLayerInfoButtonType.None,
    sex = SexType.None,
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
    sex = SexType.None,
    positionId = 0,
	exploitRank = 0
}
local OneData = DataClass("OneData", PlayerItemShow)
local InfoShow = DataClass("InfoShow", PlayerInfoShow)
local UIPlayerInfoCtrl = BaseClass("UIPlayerInfoCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerInfo)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitData(self,uid,isArrow)
    if uid ~=nil then
        self.uid = uid
    else
        self.uid = LuaEntry.Player.uid
    end
	local info =  DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(uid)
	if info==nil then
		SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo,self.uid)
	else
		EventManager:GetInstance():Broadcast(EventId.GetNewUserInfoSucc)
	end

    if isArrow and self.isArrow == nil then
        self.isArrow = isArrow
    else
        self.isArrow = nil
    end
end

local function GetUid(self)
    return self.uid
end

local function GetPlayerInfoShowByUid(self,uid)
    local info =  DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(uid)
    local oneData = InfoShow.New()
    if info~=nil then       
        local isSelf = (DataCenter.PlayerInfoDataManager:GetSelfUid() == info.uid)
        oneData.isSelf = isSelf
        oneData.uid = info.uid
        oneData.name = info.name
        oneData.moodStr = info.moodStr
        oneData.serverId = LuaEntry.Player.serverId
		oneData.exploitRank = info.exploitRank

        local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
        if data ~= nil and data.allianceName ~= "" then
            oneData.allianceName =  "["..data.abbr.."]"..data.allianceName
            oneData.alAbbr = data.abbr
        else
            oneData.allianceName = ""
            oneData.alAbbr = ""
        end
        if data ~= nil then
            oneData.icon = data.icon
        end
        oneData.pic = info.pic
        oneData.picVer = info.picVer
        oneData.headSkinId = info.headSkinId
        oneData.headSkinET = info.headSkinET
        oneData.serverId = info.serverId
        oneData.headBg = info:GetHeadBgImg()
        oneData.nation = nil-- isSelf and LuaEntry.Player.countryFlag or nil
        oneData.power = string.GetFormattedSeperatorNum(info.power)
        oneData.kill = string.GetFormattedSeperatorNum(info.armyKill)
        oneData.level = info.level
        oneData.mainLv = DataCenter.BuildManager.MainLv
        oneData.careerType = info.careerType
        oneData.careerLv = info.careerLv
        oneData.sex = info.sex
        oneData.positionId = info:GetPositionId()
    else
        if DataCenter.PlayerInfoDataManager:GetSelfUid() == uid then
            oneData.isSelf = true
            oneData.uid = uid
            oneData.name = LuaEntry.Player:GetName()
            oneData.moodStr = LuaEntry.Player:GetValue("moodStr")
            local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
            if data ~= nil and data.allianceName ~= "" then
                oneData.allianceName =  "["..data.abbr.."]"..data.allianceName
            else
                oneData.allianceName = ""
            end
            if data ~= nil then
                oneData.icon = data.icon
            end
            oneData.pic = LuaEntry.Player:GetPic()
            oneData.picVer = LuaEntry.Player:GetValue("picVer")
            oneData.headBg = LuaEntry.Player:GetHeadBgImg()
            oneData.power = string.GetFormattedSeperatorNum(LuaEntry.Player:GetValue("power"))
            oneData.kill = string.GetFormattedSeperatorNum(LuaEntry.Player:GetValue("armyKill"))
            oneData.level = 0
            oneData.mainLv = DataCenter.BuildManager.MainLv
            oneData.sex = LuaEntry.Player:GetSex()
            oneData.positionId = LuaEntry.Player:GetPositionId()
            oneData.exploitRank = LuaEntry.Player:GetExploitRank()
        end
    end
    return oneData
end                             
local function SavePlayerSign(self,content)
	SFSNetwork.SendMessage(MsgDefines.ChangeMoodStr,content)
end
local function GetPlayerButtonList(self,uid)
    local typeList = {}
    local showList = {}
    local selfUid = LuaEntry.Player.uid--DataCenter.PlayerInfoDataManager:GetSelfUid()
    if uid == selfUid then
        table.insert(typeList,PLayerInfoButtonType.MoreMessage)
        table.insert(typeList,PLayerInfoButtonType.Account)
        --table.insert(typeList,PLayerInfoButtonType.Alliance)
        --table.insert(typeList,PLayerInfoButtonType.Citybuff)
        table.insert(typeList,PLayerInfoButtonType.Setting)
        table.insert(typeList,PLayerInfoButtonType.RankList)
        -- table.insert(typeList,PLayerInfoButtonType.ActivityCenter)
      --  table.insert(typeList,PLayerInfoButtonType.Faq)
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
            if CS.SDKManager.IS_IPhonePlayer() and
                    not CS.GameEntry.Setting:GetBool(SettingKeys.ALLOW_TRACKING_CLICK, false) then
                data.red_dot = true
            end
            table.insert(showList,data)
        elseif v== PLayerInfoButtonType.ActivityCenter then
            local data = OneData.New()
            data.type = v
            data.name = Localization:GetString("360021")
            data.pic = "Assets/Main/Sprites/UI/UISet/New/UISet_btn_info.png"
            table.insert(showList,data)
        elseif v== PLayerInfoButtonType.Account then
            local data = OneData.New()
            data.type = v
            data.name = Localization:GetString("280039")
            data.pic = "Assets/Main/Sprites/UI/UISet/New/UISet_btn_message.png"
            table.insert(showList, data)
        elseif v== PLayerInfoButtonType.Faq then
            local data = OneData.New()
            data.type = v
            data.name = Localization:GetString("100619")
            data.pic = "Assets/Main/Sprites/UI/UISet/New/UISet_btn_faq.png"
            table.insert(showList, data)
        elseif v== PLayerInfoButtonType.Citybuff then
            local data = OneData.New()
            data.type = v
            data.name = Localization:GetString("129024")
            data.pic = "Assets/Main/Sprites/UI/UISet/New/UISet_btn_citybuff.png"
            table.insert(showList, data)
        elseif v== PLayerInfoButtonType.Alliance then
            local data = OneData.New()
            data.type = v
            data.name = Localization:GetString("390002")
            data.pic = "Assets/Main/Sprites/UI/UISet/New/UISet_btn_alliance.png"
            table.insert(showList, data)
        end
    end)
    return showList
end

local function OnGotoClick(self,type,uid)

    if type == PLayerInfoButtonType.MoreMessage then
       -- UIUtil.ShowTipsId(120018) 
       UIManager:GetInstance():OpenWindow(UIWindowNames.UIMoreInformation,{ anim = true,isBlur = true},self.uid)
    elseif type == PLayerInfoButtonType.Setting then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISetting,{ anim = true ,isBlur = true})
    elseif type == PLayerInfoButtonType.RankList then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIRankTable,{ anim = true, hideTop = true ,isBlur = true})
    elseif type == PLayerInfoButtonType.Faq then
		--UIManager:GetInstance():OpenWindow(UIWindowNames.UIBag,{ anim = true, back = { ui = UIWindowNames.UIPlayerInfo, anim = false }})
		--UIUtil.ShowTipsId(120018) 
        --GoToUtil.GotoOpenView(UIWindowNames.UISearch)
        --UIManager:GetInstance():OpenWindow(UIWindowNames.UIRankTable,{ anim = true, back = { ui = UIWindowNames.UIPlayerInfo, anim = false }})
    elseif type == PLayerInfoButtonType.Account then

        --local status = Setting:GetPrivateInt(SettingKeys.ACCOUNT_STATUS, 0)
        --if status == AccountBandState.UnCheck then
        --    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountVerify)
        --else
        local isArrow = nil
        if self.isArrow and self.isArrow == PLayerInfoArrowType.BandAccount then
            isArrow = true
        end
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingAccount,{ anim = true,isBlur = true },isArrow)
        --end
    elseif type == PLayerInfoButtonType.ActivityCenter then
        GoToUtil.GotoOpenView(UIWindowNames.UIActivityCenterTable, { anim = true, UIMainAnim = UIMainAnimType.AllHide })
    elseif type == PLayerInfoButtonType.Citybuff then
    elseif type == PLayerInfoButtonType.Alliance then
        local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
        if data ~= nil and not string.IsNullOrEmpty(data.allianceName) then
            local isPlayerInfo = true
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceMainTable,isPlayerInfo)
        else
            UIUtil.ShowTipsId(GameDialogDefine.NO_JOIN_ALLIANCE)
            GoToUtil.GotoOpenView(UIWindowNames.UIAllianceIntro,{ anim = true,isBlur = true})
        end
    end
	
end

local function OnPhotoClick(self)
    --CS.GameEntry.UI:OpenUIForm(CS.GameDefines.UIAssets.UIChangehead, CS.GameDefines.UILayer.Normal);
end
local function OnIconClick(self)
   -- CS.GameEntry.UI:OpenUIForm(CS.GameDefines.UIAssets.UIChangehead, CS.GameDefines.UILayer.Normal);
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerChangeHeadIcon,{anim = true})
end
local function OnChangeNameClick(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChangeName,{anim = true})
end
local function OnKillDesClick(self)

end

function UIPlayerInfoCtrl:OnChangeSexClick()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerGenderSelect,{anim = true})
end

UIPlayerInfoCtrl.CloseSelf = CloseSelf
UIPlayerInfoCtrl.Close = Close
UIPlayerInfoCtrl.InitData =InitData
UIPlayerInfoCtrl.GetPlayerInfoShowByUid =GetPlayerInfoShowByUid
UIPlayerInfoCtrl.GetPlayerButtonList =GetPlayerButtonList
UIPlayerInfoCtrl.GetUid = GetUid
UIPlayerInfoCtrl.OnGotoClick = OnGotoClick
UIPlayerInfoCtrl.OnPhotoClick = OnPhotoClick
UIPlayerInfoCtrl.OnIconClick = OnIconClick
UIPlayerInfoCtrl.OnChangeNameClick = OnChangeNameClick
UIPlayerInfoCtrl.OnKillDesClick = OnKillDesClick
UIPlayerInfoCtrl.SavePlayerSign=SavePlayerSign
return UIPlayerInfoCtrl