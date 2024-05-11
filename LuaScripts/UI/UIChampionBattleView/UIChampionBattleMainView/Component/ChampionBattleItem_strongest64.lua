
local ChampionBattleItem_strongest64 = BaseClass("ChampionBattleItem_strongest64", UIBaseContainer)
local M = ChampionBattleItem_strongest64
local base = UIBaseContainer
local GroupHonorListCellItem = require "UI.UIChampionBattleView.UIChampionBattleMainView.Component.GroupHonorListCellItem"
local TabButton = require "UI.UIChampionBattleView.UIChampionBattleMainView.Component.TabButton"
local ActChampionGroupInfo = require "DataCenter.ActChampionBattleManager.ActChampionGroupInfo"
local Localization = CS.GameEntry.Localization
local Group_strongest64_path = "Group_strongest64"

local Group_honorList_path = "Group_strongest64/Group_honorList"
local distanceCdGo_path = "Group_strongest64/Group_honorList/distanceCdGo/"
local distanceCdTxt_path = "Group_strongest64/Group_honorList/distanceCdGo/distanceCdTxt"
local Battle1_path = "Group_strongest64/Group_honorList/Group_Player/Battle1"
local Battle2_path = "Group_strongest64/Group_honorList/Group_Player/Battle2"
local Battle3_path = "Group_strongest64/Group_honorList/Group_Player/Battle3"
local Battle4_path = "Group_strongest64/Group_honorList/Group_Player/Battle4"
local Battle5_path = "Group_strongest64/Group_honorList/Group_Player/Battle5"
local Battle6_path = "Group_strongest64/Group_honorList/Group_Player/Battle6"
local Battle7_path = "Group_strongest64/Group_honorList/Group_Player/Battle7"

local Group_explain_path = "Group_explain"
local explainTxt1_path = "Group_explain/explainTxt1"
local explainTxt2_path = "Group_explain/explainTxt2"

local explainTxt3_path = "Group_explain/explainTxt3"

local tab_btn_prefix = "Group_strongest64/Btn_list/Toggle"
local tab_btn_num = 8

local winner_name_path = "Group_strongest64/Group_honorList/Group_Player/Winner/Winner_Name"

local winner_empty_text_path = "Group_strongest64/Group_honorList/Group_Player/Winner/Winner_Txt_empty"

local winner_btn_path = "Group_strongest64/Group_honorList/Group_Player/Winner/head/Winner_UIPlayerHead"
local winner_head_path = "Group_strongest64/Group_honorList/Group_Player/Winner/head/Winner_UIPlayerHead/HeadIcon"
local winner_Foreground_path = "Group_strongest64/Group_honorList/Group_Player/Winner/head/Winner_UIPlayerHead/Foreground"

function M:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function M:ComponentDefine()
    --Group_strongest64
    self.Group_strongest64 = self:AddComponent(UIBaseContainer, Group_strongest64_path)
    
    --Group_honorList
    self.Group_honorList = self:AddComponent(UIBaseContainer, Group_honorList_path)
    self.distanceCdGo = self:AddComponent(UIBaseContainer, distanceCdGo_path)
    self.distanceCdTxt = self:AddComponent(UIText, distanceCdTxt_path)
    self.Battle_1 = self:AddComponent(UIBaseContainer, Battle1_path)
    self.Battle_2 = self:AddComponent(UIBaseContainer, Battle2_path)
    self.Battle_3 = self:AddComponent(UIBaseContainer, Battle3_path)
    self.Battle_4 = self:AddComponent(UIBaseContainer, Battle4_path)
    self.Battle_5 = self:AddComponent(UIBaseContainer, Battle5_path)
    self.Battle_6 = self:AddComponent(UIBaseContainer, Battle6_path)
    self.Battle_7 = self:AddComponent(UIBaseContainer, Battle7_path)

    --Group_explain
    self.Group_explain = self:AddComponent(UIBaseContainer, Group_explain_path)
    self.explainTxt1 = self:AddComponent(UIText, explainTxt1_path)
    self.explainTxt2 = self:AddComponent(UIText, explainTxt2_path)
    self.explainTxt3 = self:AddComponent(UIText, explainTxt3_path)

    self.winner_name = self:AddComponent(UIText, winner_name_path)

    self.winner_empty_text = self:AddComponent(UIText, winner_empty_text_path)

    self.winner_head = self:AddComponent(UIPlayerHead, winner_head_path)
    self.winner_Foreground = self:AddComponent(UIImage, winner_Foreground_path)
    self.winner_btn = self:AddComponent(UIButton, winner_btn_path)
    self.winner_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnHeadClick()
    end)
end

function M:DataDefine()
    self.loadingResource = {}
    self.tabIndex = -1
end

function M:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function M:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.ChampionBattleGroupDataBack, self.OnServerDataBack)
end

-- 注销消息
function M:OnRemoveListener()
    self:RemoveUIListener(EventId.ChampionBattleGroupDataBack, self.OnServerDataBack)
    base.OnRemoveListener(self)
end

function M:ComponentDestroy()
    self.Battle_1:RemoveComponents(GroupHonorListCellItem)
    self.Battle_2:RemoveComponents(GroupHonorListCellItem)
    self.Battle_3:RemoveComponents(GroupHonorListCellItem)
    self.Battle_4:RemoveComponents(GroupHonorListCellItem)
    self.Battle_5:RemoveComponents(GroupHonorListCellItem)
    self.Battle_6:RemoveComponents(GroupHonorListCellItem)
    self.Battle_7:RemoveComponents(GroupHonorListCellItem)
    self:StopTimer()
end

function M:DataDestroy()
    self.tabIndex = -1
    self.loadingResource = nil
end

function M:SetData(info)
    self:StopTimer()
    self.championBattleInfo = info
    if self.championBattleInfo == nil then
        return
    end

    if self.championBattleInfo.groupData ~= nil then
        self.Group_strongest64:SetActive(true)
        self.Group_explain:SetActive(false)
        self:InitTabBtns()
        self:SetCurrentTab(self.tabIndex)
    else
        self:SetAuditionsOver()
        self.Group_strongest64:SetActive(false)
        self.Group_explain:SetActive(true)
    end
end

--巅峰赛尚未开始
function M:SetAuditionsOver()
    self:RefreshTime()
    self.explainTxt1:SetLocalText(302612)
end

-----------------end---海选赛状态下显示
function M:RefreshTime()
    self:StopTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.OnTimer, self, false,false,false)
    end

    self.timer:Start()
    self:OnTimer()
end

function M:StopTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function M:OnTimer()
    if self.Group_explain == nil or self.championBattleInfo == nil then
        return
    end

    local curTime = UITimeManager:GetInstance():GetServerTime()
    local endTime = self.championBattleInfo.groupST

    if endTime > curTime then
        self.distanceCdTxt:SetText("")
        self.explainTxt2:SetLocalText(302040)
        self.explainTxt3:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(endTime - curTime))
        self.explainTxt2:SetActive(true)
        self.explainTxt3:SetActive(true)
    else
        if self.groupData == nil then
            return
        end
        self.explainTxt2:SetActive(false)
        self.explainTxt3:SetActive(false)

        local nextRoundST = self.groupData.strongestNextRoundST
        local isEnd = false
        if self.groupData.topTwoGroup ~= nil and table.count(self.groupData.topTwoGroup) > 0 then
            local boNum = self:GetBoNum()
            isEnd = toInt(self.groupData.topTwoGroup[1].score1) == boNum or toInt(self.groupData.topTwoGroup[1].score2) == boNum
        end
        if nextRoundST ~= nil and nextRoundST > curTime and self.nextSTDialog ~= nil and not isEnd then
            self.distanceCdTxt:SetLocalText(self.nextSTDialog, UITimeManager:GetInstance():MilliSecondToFmtString(nextRoundST - curTime))
            self.distanceCdGo:SetActive(true)
        else
            self.distanceCdTxt:SetText("")
            self.distanceCdGo:SetActive(false)
        end
    end
end

--刷新最强荣誉榜页签数据
function M:Refresh8StrongestHonorList()
    ---下一局时间显示
    self.nextSTDialog = "302052"
    self:RefreshTime()
    ---
    local topCount = 0
    if self.groupData.topEightGroup ~= nil then
        topCount = #self.groupData.topEightGroup
    end

    local AddOneCell = function(index, data, type)
        local name = "Battle_"..index
        local container = self[name]
        if self.loadingResource[name] ~= nil then
            return
        end

        if container ~= nil then
            if container:GetComponent(tostring(index)) then
                container:GetComponent(tostring(index)):SetData(data, index, type, self.groupData)
            else
                self.loadingResource[name] = 1
                self:GameObjectInstantiateAsync(UIAssets.GroupHonorListCell, function(request)
                    if request.isError then
                        return
                    end
                    self.loadingResource[name] = nil
                    local go = request.gameObject
                    go:SetActive(true)
                    go.transform:SetParent(container.transform)
                    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)

                    local nameStr = tostring(index)
                    go.name = nameStr
                    local tmp = container:AddComponent(GroupHonorListCellItem, nameStr)
                    tmp:SetData(data, index, type, self.groupData)
                    go.transform.localPosition = ResetPosition
                    go.transform:SetAsLastSibling()
                end)
            end
        end
    end

    for i = 1, 4 do
        if i <= topCount then
            AddOneCell(i + 3, self.groupData.topEightGroup[i], ChampionBattlePosterType.Strongest_Eight)
        else
            AddOneCell(i + 3, nil, ChampionBattlePosterType.Strongest_Eight)
        end
    end

    local fourTopCount = 0
    if self.groupData.topFourGroup ~= nil then
        fourTopCount = #self.groupData.topFourGroup
    end
    for i = 1, 2 do
        if i <= fourTopCount then
            local needSweepUuid = false
            if i == 2 and self.groupData.topFourGroup[2] and self.groupData.topEightGroup[4] then
                if self.groupData.topFourGroup[2].uid1 ~= self.groupData.topEightGroup[4].uid1 and self.groupData.topFourGroup[2].uid1 ~= self.groupData.topEightGroup[4].uid2 then
                    needSweepUuid = true
                end
            end
            if i == 1 and self.groupData.topFourGroup[1] and self.groupData.topEightGroup[2]  then
                if self.groupData.topFourGroup[1].uid1 ~= self.groupData.topEightGroup[2].uid1 and self.groupData.topFourGroup[1].uid1 ~= self.groupData.topEightGroup[2].uid2 then
                    needSweepUuid = true
                end
            end
            if needSweepUuid then
                local uid1 = self.groupData.topFourGroup[i].uid1
                self.groupData.topFourGroup[i].uid1 = self.groupData.topFourGroup[i].uid2
                self.groupData.topFourGroup[i].uid2 = uid1

                local score1 = self.groupData.topFourGroup[i].score1
                self.groupData.topFourGroup[i].score1 = self.groupData.topFourGroup[i].score2
                self.groupData.topFourGroup[i].score2 = score1
            end
            AddOneCell(i + 1, self.groupData.topFourGroup[i], ChampionBattlePosterType.Strongest_Four)
        else
            AddOneCell(i + 1, nil, ChampionBattlePosterType.Strongest_Four)
        end
    end

    local twoTopCount = 0
    if self.groupData.topTwoGroup ~= nil then
        twoTopCount = #self.groupData.topTwoGroup
    end
    for i = 1, 1 do
        if i <= twoTopCount then
            AddOneCell(i, self.groupData.topTwoGroup[i], ChampionBattlePosterType.Strongest_Two)
        else
            AddOneCell(i, nil, ChampionBattlePosterType.Strongest_Two)
        end
    end
    self:ShowFinalWinner()
end

function M:ShowFinalWinner()
    local winner = nil
    if self.groupData ~= nil and self.groupData.topTwoGroup ~= nil and table.count(self.groupData.topTwoGroup) > 0 then
        local boNum = self:GetBoNum()
        if toInt(self.groupData.topTwoGroup[1].score1) >= boNum then
            winner = self.groupData:GetPlayerMsgByUid(self.groupData.topTwoGroup[1]["uid1"])
        elseif toInt(self.groupData.topTwoGroup[1].score2) >= boNum then
            winner = self.groupData:GetPlayerMsgByUid(self.groupData.topTwoGroup[1]["uid2"])
        end
    end
    if winner then
        local nameText = "#"..winner.serverId
        if not string.IsNullOrEmpty(winner.abbr) then
            nameText = nameText.."["..winner.abbr.."]"
        end
        nameText = nameText..winner.name
        self.winner_name:SetText(nameText)
        self.view.ctrl:SetHeadImg(self.winner_head, self.winner_Foreground, winner.uid, winner.pic, winner.picver, winner.headFrame, winner.headSkinId, winner.headSkinET)
    else
        self.winner_name:SetText("")
        self.winner_empty_text:SetText("")
        self.view.ctrl:SetHeadImg(self.winner_head, self.winner_Foreground, "", "", 0, 0)
    end
end

function M:OnHeadClick()
    local winner = nil
    if self.groupData ~= nil and self.groupData.topTwoGroup ~= nil and table.count(self.groupData.topTwoGroup) > 0 then
        local boNum = self:GetBoNum()
        if toInt(self.groupData.topTwoGroup[1].score1) >= boNum then
            winner = self.groupData:GetPlayerMsgByUid(self.groupData.topTwoGroup[1]["uid1"])
        elseif toInt(self.groupData.topTwoGroup[1].score2) >= boNum then
            winner = self.groupData:GetPlayerMsgByUid(self.groupData.topTwoGroup[1]["uid2"])
        end
    end
    if winner ~= nil and not string.IsNullOrEmpty(winner["uid"]) then
        self.view.ctrl:ShowPlayerInfo(winner["uid"])
    end
end

function M:InitTabBtns()
    if self.tabBtns ~= nil then
        return
    end
    self.tabBtns = {}
    local selfGroup = nil
    if self.championBattleInfo and self.championBattleInfo.groupData then
        selfGroup = self.championBattleInfo.groupData
    end
    local selectIndex = selfGroup and selfGroup.group or 1
    local btnName = {"A", "B", "C", "D", "E", "F", "G", "H"}
    for i = 1, tab_btn_num do
        local name = tab_btn_prefix..i
        local para = {}
        para.id = i
        para.name = Localization:GetString("302613", btnName[i])
        para.callBack = BindCallback(self, self.SetCurrentTab)
        if selfGroup == nil then
            para.isSelfGroup = false
        else
            para.isSelfGroup = selfGroup:GetPlayerMsgByUid(LuaEntry.Player.uid) ~= nil and selectIndex == i
        end
        local btn = self:AddComponent(TabButton, name)
        btn:ReInit(para)
        table.insert(self.tabBtns, btn)
    end
    self:SetCurrentTab(selectIndex)
end

function M:SetCurrentTab(tabIndex)
    if self.tabBtns == nil then
        return
    end
    self.tabIndex = tabIndex
    for _, v in ipairs(self.tabBtns) do
        v:SetCurSelect(self.tabIndex)
    end
    if self.championBattleInfo and self.championBattleInfo.groupData and self.championBattleInfo.groupData.group == self.tabIndex then
        self.groupData = self.championBattleInfo.groupData
        self:Refresh8StrongestHonorList()
    end
    self:GetDataFromServer()
end

function M:GetDataFromServer()
    if self.tabIndex > 0 and self.tabIndex <= tab_btn_num then
        SFSNetwork.SendMessage(MsgDefines.ACT_CHAMPIONBATTLE_GET_GROUP_DATA, self.tabIndex)
    end
end

function M:OnServerDataBack(message)
    self.groupData = ActChampionGroupInfo.New()
    self.groupData:ParseServerData(message)
    self:Refresh8StrongestHonorList()
end

function M:GetBoNum()
    local num = LuaEntry.DataConfig:TryGetNum("champ_battle", "k27")
    num = math.ceil(num / 2)
    return num
end
--------------------------------------------------

return M
