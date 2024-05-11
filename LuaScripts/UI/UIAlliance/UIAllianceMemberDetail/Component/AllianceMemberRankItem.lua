---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/9/22 11:16
---
local AllianceMemberRankSimple = require "UI.UIAlliance.UIAllianceMemberDetail.Component.AllianceMemberRankSimple"
local AllianceMemberRankSpecial = require "UI.UIAlliance.UIAllianceMemberDetail.Component.AllianceMemberRankSpecial"
local AllianceMemberRankItem = BaseClass("AllianceMemberRankItem",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local icon_path = "mainContent/leader"
local name_path = "mainContent/nameTxt"
local num_path = "mainContent/people"
local show_btn_path ="mainContent/showButton"
local close_img_path = "mainContent/ImgArrowNormal"
local open_img_path = "mainContent/ImgArrowSelect"
local content_path = "armyContent"
local inactive_path = "mainContent/inactive"
local inactiveTip_path = "mainContent/inactive/inactiveTip"
local function OnCreate(self)
    
    base.OnCreate(self)
    self.icon = self:AddComponent(UIImage, icon_path)
    self.name = self:AddComponent(UITextMeshProUGUIEx,name_path)
    self.num = self:AddComponent(UITextMeshProUGUIEx,num_path)
    self.close_img = self:AddComponent(UIImage,close_img_path)
    self.open_img = self:AddComponent(UIImage,open_img_path)
    self.show_btn = self:AddComponent(UIButton, show_btn_path)
    self.show_btn:SetOnClick(function ()
        self:OnShowClick()
    end)
    self.content = self:AddComponent(UIBaseContainer,content_path)
    self.inactiveN = self:AddComponent(UIBaseContainer, inactive_path)
    self.inactiveAnimN = self:AddComponent(UIAnimator, inactive_path)
    self.inactiveTipN = self:AddComponent(UITextMeshProUGUIEx, inactiveTip_path)
    self.inactiveTipN:SetLocalText(141141)
    --self.showMember = true
    --需求默认不显示列表
    local needCollapse = self.view.ctrl:NeedShowInactive()
    self:ShowMember(not needCollapse)

    self.isRefreshMemberList = false
    self.toRefreshMemberList = false
    self.model = {}
    self.cellList = {}
end

local function OnDestroy(self)
    self.icon = nil
    self.name = nil
    self.num = nil
    self.close_img = nil
    self.open_img = nil
    self.show_btn = nil
    self.content = nil
    self.showMember =nil
    self.rank = nil
    self.isRefreshMemberList = nil
    self.toRefreshMemberList = nil
    base.OnDestroy(self)
end

local function RefreshData(self,rank)
    self.rank = rank
    self.data = self.view.ctrl:GetRankData(rank)
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/UIAlliance_icon_R" .. rank .. ".png")
    self.name:SetLocalText(390791,  rank) -- "R" .. rank
    self.num:SetText(self.data.rankNum)
    if not self.showMember then
        local selfRank = DataCenter.AllianceBaseDataManager:GetSelfRank()
        if selfRank == rank then
            local showSelfRank = self.view:CheckIfNeedShowSelfRank()
            self.showMember = showSelfRank
        else
            self.showMember = false
        end
    end
    if self.showMember then
        self:RefreshMemberList()
    else
        if self.data then
            local param = {}
            param.rank = self.data.rank
            param.isShow = self.showMember
            EventManager:GetInstance():Broadcast(EventId.ShowAllianceMemberRanks, param)
        end
    end
    local showInactiveTip = self.view.showInactiveTip
    local inactivePlayerCount = DataCenter.AllianceMemberDataManager:GetInactivePlayerCount(rank)
    if showInactiveTip and inactivePlayerCount > 0 then
        self.inactiveN:SetActive(true)
        self.inactiveAnimN:Play("InactivePlayer", 0, 0)
    else
        self.inactiveN:SetActive(false)
    end
    
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    
    base.OnDisable(self)
end


local function OnShowClick(self)
    if self.showMember then
        self:SetAllCellDestroy()
        self:ShowMember(false)

        if self.data then
            local param = {}
            param.rank = self.data.rank
            param.isShow = self.showMember
            EventManager:GetInstance():Broadcast(EventId.ShowAllianceMemberRanks, param)
        end
    else
        self:ShowMember(true)
        self:RefreshMemberList()
    end
end

local function ShowMember(self, isShow)
    self.showMember = isShow
    self.open_img:SetActive(isShow)
    self.close_img:SetActive(not isShow)
end

local function RefreshMemberList(self)
    --self:SetAllCellDestroy()
    if self.isRefreshMemberList then
        self.toRefreshMemberList = true
    end
    self.isRefreshMemberList = true
    local list = self.view.ctrl:GetMemberListByRank(self.data.rank)
    if list~=nil and #list>0 then
        for k,v in pairs(self.model) do
            v.gameObject:SetActive(false)
        end
        self.content:RemoveComponents(AllianceMemberRankSpecial)
        self.cellList = {}
        for i = 1, table.length(list) do
            if self.model[i] then
                local nameStr = tostring(NameCount)
                self.model[i].gameObject.name = nameStr
                NameCount = NameCount + 1
                local cell = self.content:AddComponent(AllianceMemberRankSpecial,nameStr)
                cell:RefreshData(list[i])
                cell:SetActive(true)
                self.cellList[i] = cell
                if #self.cellList == #list then
                    if self.data then
                        local param = {}
                        param.rank = self.data.rank
                        param.isShow = self.showMember
                        EventManager:GetInstance():Broadcast(EventId.ShowAllianceMemberRanks, param)
                    end
                end
                if i == #list then
                    self.isRefreshMemberList = false
                    if self.toRefreshMemberList then
                        self.toRefreshMemberList = false
                        self:RefreshMemberList()
                    end
                end
            else
                self.model[i] = self:GameObjectInstantiateAsync(UIAssets.AllianceMemberRankSpecial, function(request)
                    if request.isError then
                        return
                    end
                    local go = request.gameObject;
                    go.gameObject:SetActive(true)
                    go.transform:SetParent(self.content.transform)
                    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                    local nameStr = tostring(NameCount)
                    go.name = nameStr
                    NameCount = NameCount + 1
                    local cell = self.content:AddComponent(AllianceMemberRankSpecial,nameStr)
                    cell:RefreshData(list[i])
                    self.cellList[i] = cell
                    if #self.cellList == #list then
                        if self.data then
                            local param = {}
                            param.rank = self.data.rank
                            param.isShow = self.showMember
                            EventManager:GetInstance():Broadcast(EventId.ShowAllianceMemberRanks, param)
                        end
                    end
                    if i == #list then
                        self.isRefreshMemberList = false
                        if self.toRefreshMemberList then
                            self.toRefreshMemberList = false
                            self:RefreshMemberList()
                        end
                    end
                end)
            end
        end
    end
end

local function SetAllCellDestroy(self)
    self.content:RemoveComponents(AllianceMemberRankSpecial)
    self.content:RemoveComponents(AllianceMemberRankSimple)
    if self.model~=nil then
        for k,v in pairs(self.model) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.model ={}
    self.cellList = {}
    self.isRefreshMemberList = false
    self.toRefreshMemberList = false
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.OnKickAllianceMember, self.OnMemberKicked)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.OnKickAllianceMember,self.OnMemberKicked)
end

local function OnMemberKicked(self, playerId)
    self.data = self.view.ctrl:GetRankData(self.rank)
    self.num:SetText(self.data.rankNum)
end

AllianceMemberRankItem.OnCreate = OnCreate
AllianceMemberRankItem.OnDestroy = OnDestroy
AllianceMemberRankItem.OnEnable = OnEnable
AllianceMemberRankItem.OnDisable = OnDisable
AllianceMemberRankItem.RefreshData = RefreshData
AllianceMemberRankItem.OnShowClick =OnShowClick
AllianceMemberRankItem.RefreshMemberList =RefreshMemberList
AllianceMemberRankItem.SetAllCellDestroy =SetAllCellDestroy
AllianceMemberRankItem.ShowMember = ShowMember
AllianceMemberRankItem.OnAddListener = OnAddListener
AllianceMemberRankItem.OnRemoveListener = OnRemoveListener
AllianceMemberRankItem.OnMemberKicked = OnMemberKicked
return AllianceMemberRankItem