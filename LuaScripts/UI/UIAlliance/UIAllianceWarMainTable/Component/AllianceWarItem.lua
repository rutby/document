---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/8/10 18:03
local AllianceWarMemHead = require "UI.UIAlliance.UIAllianceWarMainTable.Component.AllianceWarMemHead"
local AllianceWarPlayerItem = require "UI.UIAlliance.UIAllianceWarDetail.Component.AllianceWarPlayerItem"
local AllianceWarItem = BaseClass("AllianceWarItem",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local itembg_img_path = "mainContent/Common_supple"
local left_name_path = "mainContent/left/leftNameTxt"
local left_playerHead_path = "mainContent/left/lefthead/UIPlayerHead/LeftHeadIcon"
local left_CityHead_path = "mainContent/left/lefthead/UIPlayerHead/LeftCityHead"
local left_playerHeadFg_path = "mainContent/left/lefthead/UIPlayerHead/lForeground"
local left_march_item_path = "mainContent/LeftMarchRect/head"
local march_num_path = "mainContent/TeamLimit/limitTxt"
local close_img_path = "mainContent/TeamLimit/hideImg"
local open_img_path = "mainContent/TeamLimit/showImg"
local detail_btn_path = "mainContent/TeamLimit"
local right_pos_btn_path ="mainContent/right"
local right_name_path = "mainContent/right/rightNameTxt"
local rightDistanceTxt_txt_path = "mainContent/right/rightDistanceTxt"
local rightStateTxt_txt_path = "mainContent/right/rightStateTxt"
local right_righthead_path = "mainContent/right/righthead"
local right_playerHead_path = "mainContent/right/righthead/RightUIPlayerHead/RightHeadIcon"
local right_playerHeadFg_path = "mainContent/right/righthead/RightUIPlayerHead/rForeground"
local right_BossHead_path = "mainContent/right/righthead/RightUIPlayerHead/RightBossHead"
local right_CityHead_path = "mainContent/right/righthead/RightUIPlayerHead/RightCityHead"
local right_otherHead_path = "mainContent/right/otherhead"
local time_txt_path = "mainContent/left/TimeTxt"
local layout_rect = "layout"
local cancel_btn_path ="mainContent/cancelButton"

--准备、等待/行军、攻击
local marchState ={[1] = "Common_pro_green",[2] = "Common_pro_yellow",[3] = "Common_pro_red" }
local function OnCreate(self)
    base.OnCreate(self)
    self.isUpdate =false
    self.isJoin = false
    self.isCreate = false
    self.isShow = false
    self.itemBg_img = self:AddComponent(UIImage,itembg_img_path)
    self.left_name = self:AddComponent(UITextMeshProUGUIEx,left_name_path)
    self.right_pos_btn = self:AddComponent(UIButton, right_pos_btn_path)
    self.right_pos_btn:SetOnClick(function ()
        self:OnRightPosClick()
    end)
    self.right_name = self:AddComponent(UITextMeshProUGUIEx,right_name_path)
    self.rightStateTxt = self:AddComponent(UITextMeshProUGUIEx,rightStateTxt_txt_path)
    self.rightStateTxt:SetLocalText(100150)
    self.rightDistance_txt = self:AddComponent(UITextMeshProUGUIEx,rightDistanceTxt_txt_path)
    self.right_righthead = self:AddComponent(UIBaseContainer,right_righthead_path)
    self.right_otherHead = self:AddComponent(UIImage,right_otherHead_path)

    self.time_txt = self:AddComponent(UITextMeshProUGUIEx,time_txt_path)

    self.layout_rect = self:AddComponent(UIBaseContainer,layout_rect)
    self.cancel_btn = self:AddComponent(UIButton, cancel_btn_path)
    self.cancel_btn:SetOnClick(function ()
        self:OnCancelClick()
    end)
    
    self.head_list = {}
    for i=1,4 do
        local path = left_march_item_path..i
        local item = self:AddComponent(AllianceWarMemHead,path)
        table.insert(self.head_list,item)
    end
    self.march_num = self:AddComponent(UITextMeshProUGUIEx,march_num_path)
    self.close_img = self:AddComponent(UIBaseContainer,close_img_path)
    self.open_img = self:AddComponent(UIBaseContainer,open_img_path)
    self.detail_btn = self:AddComponent(UIButton, detail_btn_path)
    self.detail_btn:SetOnClick(function ()
        self:OnDetailClick()
    end)
    self.left_playerHead = self:AddComponent(UIPlayerHead, left_playerHead_path)
    self.left_CityHead = self:AddComponent(UIBaseContainer,left_CityHead_path)
    self.left_playerHeadBg = self:AddComponent(UIImage, left_playerHeadFg_path)
    self.left_playerHeadBg.transform:SetAsLastSibling()
    self.right_playerHead = self:AddComponent(UIPlayerHead, right_playerHead_path)
    self.right_playerHeadBg = self:AddComponent(UIImage, right_playerHeadFg_path)
    self.right_playerHeadBg.transform:SetAsLastSibling()
    self.right_bossHead = self:AddComponent(UIBaseContainer,right_BossHead_path)
    self.right_bossHead_img = self:AddComponent(CircleImage,right_BossHead_path)
    self.right_CityHead = self:AddComponent(UIBaseContainer,right_CityHead_path)
    self.open_img:SetActive(false)
    self.close_img:SetActive(true)
    self._timer_alliance = nil
    self._timer_action = function(temp)
        self:UpdateSlider()
    end
end

local function OnDestroy(self)
    self:SetAllCellDestroy()
    if self._timer_alliance ~= nil then
        self._timer_alliance:Stop()
        self._timer_alliance = nil
    end
    base.OnDestroy(self)
end

local function RefreshData(self,isAlert)
    self.isAlert = isAlert
    self.isUpdate =false
    self.dataInfo = self.view.ctrl:GetWarItemData(self.uuid)
    if self.dataInfo.createTime == 0 then
        return
    end
    self.right_otherHead:SetActive(false)
    self.right_righthead:SetActive(true)
    self.rightDistance_txt:SetActive(true)
    self.right_bossHead:SetActive(self.dataInfo.type == AllianceTeamType.ATTACK_BOSS)
    self.right_playerHead:SetActive(false)
    --self.right_playerHead:SetActive(self.dataInfo.type ~= AllianceTeamType.ATTACK_BOSS)
    self.right_name:SetText(self.dataInfo.rightName)
    self.left_name:SetText(self.dataInfo.leftName)
    self.left_playerHead:SetData(self.dataInfo.attackUid,self.dataInfo.attackIcon,self.dataInfo.ownerIconVer)
    if self.dataInfo.targetHeadBg then
        self.left_playerHeadBg:SetActive(true)
    else
        self.left_playerHeadBg:SetActive(false)
    end
    self.right_CityHead:SetActive(self.dataInfo.type == AllianceTeamType.ATTACK_AL_CITY or self.dataInfo.type == AllianceTeamType.ATTACK_THRONE or self.dataInfo.type == AllianceTeamType.ASSISTANCE_THRONE )
    if self.dataInfo.type == AllianceTeamType.ATTACK_BOSS then
        self.right_playerHead:SetActive(false)
        local bossImg = string.IsNullOrEmpty(self.dataInfo.rightBossHead) and string.format(LoadPath.WarDetail,"alliance_building_assemble_2.png") or string.format(LoadPath.WarDetail,self.dataInfo.rightBossHead)
        self.right_bossHead_img:LoadSprite(bossImg, bossImg)
    else
        self.right_playerHead:SetActive(self.dataInfo.type ~= AllianceTeamType.ATTACK_AL_CITY and self.dataInfo.type ~= AllianceTeamType.ATTACK_THRONE and self.dataInfo.type~=AllianceTeamType.ASSISTANCE_THRONE)   --打城时关闭玩家头像
        self.right_playerHead:SetData(self.dataInfo.targetUid, self.dataInfo.targetIcon, self.dataInfo.targetIconVer)
        --if self.dataInfo.ownerHeadBg then
        --    self.right_playerHead:SetActive(true)
        --else
        --    self.right_playerHead:SetActive(false)
        --end
    end
    self.rightDistance_txt:SetActive(self.dataInfo.rightDistance>0)
    self.rightDistance_txt:SetText(self.dataInfo.rightDistance..Localization:GetString(GameDialogDefine.KILOMETRE))
    local iscancel = self.dataInfo.cancel
    self.cancel_btn:SetActive(iscancel)
    self:UpdateSlider()
    self:OnPlayerRefresh()
    --self.march_num:SetText(self.dataInfo.canJoinNum.."/"..self.dataInfo.assemblyMarchMax)
    self.march_num:SetText(Localization:GetString("450035", self.dataInfo.canJoinNum))
    self:AddAllianceTimer()
end

local function SetUuid(self,uuid)
    self.uuid = uuid
end

local function AddAllianceTimer(self)
    if self._timer_alliance == nil then
        self._timer_alliance = TimerManager:GetInstance():GetTimer(1, self._timer_action , self, false,false,false)
        self._timer_alliance:Start()
    end
end

local function UpdateSlider(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime =0
    local maxTime =0
    local dialog = "141032"
    local march = 1
    if self.dataInfo.waitTime > curTime then
        self.isUpdate =true
        deltaTime = self.dataInfo.waitTime - curTime
        maxTime = self.dataInfo.waitTime - self.dataInfo.createTime
        dialog = "141032"
        march = 1
        self.isJoin = true
    elseif self.dataInfo.marchTime > curTime then
        self.isUpdate =true
        deltaTime = self.dataInfo.marchTime - curTime
        maxTime = self.dataInfo.marchTime - self.dataInfo.createTime
        dialog = "390789"
        march = 2
        self.isJoin = false
    else
        self.isUpdate =false
        self.isJoin = false
    end

    if not self.isUpdate then
        --当部队出发后，队长的结束时间为达到目的地时间
        if self.dataInfo.marchendTime > curTime then
            dialog = "141033"
            deltaTime = self.dataInfo.marchendTime - curTime
            march = 2
        else
            dialog = 141029
            march = 3
        end
    end

    if self.isUpdate then
        self.time_txt:SetText(Localization:GetString(dialog)..UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    else
        if deltaTime > 0 then
            self.time_txt:SetText(Localization:GetString(dialog)..UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
        else
            self.time_txt:SetLocalText(dialog)
        end
        self:RefreshJoinBtn()
    end
    if self.dataInfo.type == AllianceTeamType.ASSISTANCE_THRONE and march ==3 then
        self.time_txt:SetLocalText(300516)
    end
end

local function OnRightPosClick(self)
    self.view.ctrl:OnClickPosBtn(self.dataInfo.rightPointId)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnCancelClick(self)
    UIUtil.ShowMessage(Localization:GetString("110151"),2,nil,nil,function ()self.view.ctrl:OnCancelClick(self.uuid) end,nil,nil)
end

----队长提前出发集结
--local function OnDepartClick(self)
--    SFSNetwork.SendMessage(MsgDefines.AllianceTeamDirectMove,self.dataInfo.teamUuid)
--end

local function GetSelfData(self)
    return self.dataInfo
end

local function OnDetailClick(self)
    if self.isShow ==false then
        self.isShow = true
        self.open_img:SetActive(true)
        self.close_img:SetActive(false)
        self.layout_rect:SetActive(true)
        self:RefreshList()
    else
        self.isShow = false
        self.open_img:SetActive(false)
        self.close_img:SetActive(true)
        self.layout_rect:SetActive(false)
    end
end

local function RefreshList(self,force)
    if self.isCreate ==false or force == true then
        self:SetAllCellDestroy()
        local list = self.view.ctrl:GetPlayerIdList(self.uuid)
        if list~=nil and #list>0 then
            for i = 1, #list do
                --复制基础prefab，每次循环创建一次
                self.model[list[i]] = self:GameObjectInstantiateAsync(UIAssets.AllianceWarPlayerItem, function(request)
                    if request.isError then
                        return
                    end
                    local go = request.gameObject;
                    go.gameObject:SetActive(true)
                    go.transform:SetParent(self.layout_rect.transform)
                    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                    local nameStr = tostring(NameCount)
                    go.name = nameStr
                    NameCount = NameCount + 1
                    local cell = self.layout_rect:AddComponent(AllianceWarPlayerItem,nameStr)
                    cell:SetUuid(list[i])
                    cell:RefreshData(self.uuid,false)
                end)
            end
        end
    end
end

local function SetAllCellDestroy(self)
    self.layout_rect:RemoveComponents(AllianceWarPlayerItem)
    if self.model~=nil and next(self.model) then
        for k,v in pairs(self.model) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.model ={}
end

local function OnPlayerRefresh(self)
    local list = self.view.ctrl:GetPlayerIdList(self.uuid)
    local showList ={}
    for a =1,#list do
        if list[a]~=nil and list[a]~= self.dataInfo.leaderMarchUuid then
            table.insert(showList,list[a])
        end
    end
    for i=1,4 do
        local item = self.head_list[i]
        if showList[i]~=nil then
            item:SetItemShow(self.uuid,showList[i])
        else
            item:ShowHide((self.isUpdate and self.dataInfo.join and self.isJoin), self.uuid)
        end
    end
end

function AllianceWarItem:RefreshJoinBtn()
    local show = self.isUpdate and self.dataInfo.join and self.isJoin
    for k, v in ipairs(self.head_list) do
        v:RefreshJoinShow(show)
    end
end

AllianceWarItem.OnCreate = OnCreate
AllianceWarItem.OnDestroy = OnDestroy
AllianceWarItem.OnEnable = OnEnable
AllianceWarItem.OnDisable = OnDisable
AllianceWarItem.RefreshData = RefreshData
AllianceWarItem.OnRightPosClick =OnRightPosClick
AllianceWarItem.SetUuid =SetUuid
AllianceWarItem.UpdateSlider =UpdateSlider
AllianceWarItem.AddAllianceTimer = AddAllianceTimer
AllianceWarItem.OnCancelClick =OnCancelClick
AllianceWarItem.GetSelfData =GetSelfData
AllianceWarItem.RefreshList = RefreshList
AllianceWarItem.SetAllCellDestroy =SetAllCellDestroy
AllianceWarItem.OnDetailClick = OnDetailClick
AllianceWarItem.OnPlayerRefresh = OnPlayerRefresh
return AllianceWarItem