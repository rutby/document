---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/12/13 16:27
---
local UIMainTroops = BaseClass("UIMainTroops", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local troop_num_txt_path = "troopNum"
local troop_num_bg_path = "troopNumBg"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

--控件的定义
local function ComponentDefine(self)
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickView()
    end)
    self.troop_num_txt = self:AddComponent(UITextMeshProUGUIEx, troop_num_txt_path)
    self.troop_num_bg = self:AddComponent(UIImage, troop_num_bg_path)
    self.showTroopList = false
end


--控件的销毁
local function ComponentDestroy(self)
    self.timer_action = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)

end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.MarchItemUpdateSelf, self.AddCurMarchList)
    self:AddUIListener(EventId.ArmyFormatUpdate, self.AddCurMarchList)
    self:AddUIListener(EventId.MonthCardInfoUpdated,self.AddCurMarchList)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.MarchItemUpdateSelf,self.AddCurMarchList)
    self:RemoveUIListener(EventId.ArmyFormatUpdate,self.AddCurMarchList)
    self:RemoveUIListener(EventId.MonthCardInfoUpdated,self.AddCurMarchList)
end


local function AddCurMarchList(self)
    local troopNum = DataCenter.ArmyFormationDataManager:GetAlreadySetCountInArmyFormation()
    self.curFormationType = 1
    local formationNum = 0
    local list = DataCenter.ArmyFormationDataManager:GetArmyFormationIdList()
    if list~=nil and #list>0 then
        for i =1,#list do
            local showUnLock = true
            local formationInfo = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(list[i])
            local index = i
            if formationInfo~=nil then
                index = formationInfo.index
                if index == 4 then
                    local hasMonthCard = DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
                    if hasMonthCard == false then
                        if formationInfo then
                            local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, formationInfo.uuid, LuaEntry.Player.allianceId)
                            if march ==nil then
                                showUnLock = false
                            end
                        else
                            showUnLock = false
                        end
                    end
                end
            else
                showUnLock = false
            end
            
            if showUnLock == true then
                formationNum = formationNum+1
            end
        end
    end
    
    self.troop_num_txt:SetText(troopNum .. "/" .. formationNum)
end



local function OnClickView(self)
    self.showTroopList = not self.showTroopList
    self.view:SetTroopListShow(self.showTroopList)
end


local function OnEnable(self)
    base.OnEnable(self)
    self:AddCurMarchList()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self)
    self:AddCurMarchList()
end

UIMainTroops.OnDestroy = OnDestroy
UIMainTroops.OnCreate = OnCreate
UIMainTroops.ComponentDefine = ComponentDefine
UIMainTroops.DataDestroy = DataDestroy
UIMainTroops.ComponentDestroy = ComponentDestroy
UIMainTroops.DataDefine = DataDefine
UIMainTroops.AddCurMarchList = AddCurMarchList
UIMainTroops.OnEnable = OnEnable
UIMainTroops.OnDisable = OnDisable
UIMainTroops.OnClickView = OnClickView
UIMainTroops.ReInit = ReInit
UIMainTroops.OnAddListener = OnAddListener
UIMainTroops.OnRemoveListener = OnRemoveListener
return UIMainTroops