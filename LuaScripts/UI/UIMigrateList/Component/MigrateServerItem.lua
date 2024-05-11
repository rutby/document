---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/4/18 12:31
---
local MigrateServerItem = BaseClass("MigrateServerItem",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local AllianceFlagItem = require "UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem"

local name_path = "nameTxt"
local state_path = "stateTxt"
local accept_path = "acceptTxt"
local select_obj_path = "select"
--local applied_path = "applied"
local btn_path = "Button"
local img_path = "img"

local function OnCreate(self)
    base.OnCreate(self)
    self.name = self:AddComponent(UIText,name_path)
    self.state = self:AddComponent(UIText,state_path)
    self.accept = self:AddComponent(UIText,accept_path)
    self.accept:SetLocalText(250359)
    self.accept:SetActive(false)
    self.select_obj = self:AddComponent(UIBaseContainer,select_obj_path)
    self.countryFlagN = self:AddComponent(UIImage, img_path)
    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClick()
    end)
end

local function SetItemShow(self,data)
    self.data = data
    self.name:SetText(Localization:GetString("208236",self.data.serverId))
    self.state:SetText(Localization:GetString("250302",(self.data.season+1)))
    self.accept:SetActive(false)
    local x,y = math.modf(self.data.serverId/5)
    local num = self.data.serverId-x*5+1
    self.countryFlagN:LoadSprite("Assets/Main/Sprites/UI/UIInterstellarMigration/planet0"..toInt(num))
    local currentServerId = self.view.ctrl:GetCurrentSelectServerId()
    self.select_obj:SetActive(currentServerId == self.data.serverId)
    local applyData = DataCenter.MigrateDataManager:OnGetMigrateApplyDataByServerId(self.data.serverId)
    if applyData ~= nil then
        local applyState = applyData.state
        if applyState == MigrateApplyType.AGREE then
            local curTime = UITimeManager:GetInstance():GetServerTime()
            local deltaTime = LuaEntry.DataConfig:TryGetNum("aps_migrate_server", "k5")
            local endTime = applyData.approveTime+(deltaTime*1000*60)
            if endTime> curTime then
                self.state:SetText("")
                self.accept:SetActive(true)
            end
        end
    end
end

local function OnClick(self)
    local currentServerId = self.view.ctrl:GetCurrentSelectServerId()
    if self.data.serverId~= currentServerId then
        self.view.ctrl:SelectOneMigrateServerItem(self.data.serverId)
        self.select_obj:SetActive(true)
    end
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.CLICK_MIGRATE_SERVER_ITEM, self.RefreshItemState)

end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.CLICK_MIGRATE_SERVER_ITEM, self.RefreshItemState)
end

local function RefreshItemState(self,data)
    if self.data.serverId == data then
        local currentServerId = self.view.ctrl:GetCurrentSelectServerId()
        self.select_obj:SetActive(currentServerId == self.data.serverId)
    end
end
MigrateServerItem.OnCreate = OnCreate
MigrateServerItem.SetItemShow = SetItemShow
MigrateServerItem.OnClick = OnClick
MigrateServerItem.OnAddListener = OnAddListener
MigrateServerItem.OnRemoveListener = OnRemoveListener
MigrateServerItem.RefreshItemState = RefreshItemState

return MigrateServerItem