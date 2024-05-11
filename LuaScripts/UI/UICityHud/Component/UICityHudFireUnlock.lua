---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 8/4/2024 下午9:26
---
local base = require "UI.UICityHud.Component.UICityHudBase"
local UICityHudFireUnlock = BaseClass("UICityHudFireUnlock", base)

local root_path = "Root"
local btn_path = "Root/Btn"
local icon_path = "Root/Btn/List/Icon"
local text_path = "Root/Btn/List/Text"

local function ComponentDefine(self)
    base.ComponentDefine(self)
    self.anim = self:AddComponent(UIAnimator, root_path)
    self.goTextMat = self.transform:Find("Root/Btn/List/Text/goTextMat"):GetComponent(typeof(CS.UnityEngine.MeshRenderer))
    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function()
        self:OnClick()
    end)
    self.icon_image = self:AddComponent(UIImage, icon_path)
    self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
end

local function DataDefine(self)
    base.DataDefine(self)
    self.clicked = false
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.ResourceUpdated, self.Refresh)
    self:AddUIListener(EventId.LandBlockOnClickFire, self.OnDoAnim)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.ResourceUpdated, self.Refresh)
    self:RemoveUIListener(EventId.LandBlockOnClickFire, self.OnDoAnim)
    base.OnRemoveListener(self)
end

local function SetParam(self, param)
    base.SetParam(self, param)
    self.root_go.transform.localPosition = param.offset or Vector3.zero
    self.anim:Play("Idle", 0, 0)
    self.clicked = false
    self:Refresh()
end

local function Refresh(self)
    local config = DataCenter.LandManager:GetConfigByOrder(LandObjectType.Block,self.param.uuid)
    self.resType = 0
    self.count= 0
    local data = DataCenter.LandManager:GetData()
    if data~=nil and config~=nil then
        if config.big_zone then
            if data.finishBlock == config.order-1 then
                local str = DataCenter.LandManager:GetBigZoneUnlockCost(config.big_zone)
                local resArr = string.split(str,";")
                if #resArr ==2 then
                    self.resType = toInt(resArr[1])
                    self.count= toInt(resArr[2])
                end
                local have = LuaEntry.Resource:GetCntByResType(self.resType)
                self.enough = have >= self.count
                self.btn:LoadSprite(string.format(LoadPath.UIMain, "survivor_bg_" .. (self.enough and "yes" or "no")))
                self.icon_image:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(self.resType))
                self.text:SetMaterial(self.enough and self.goTextMat.sharedMaterials[1] or self.goTextMat.sharedMaterials[0])
                self.text:SetText(string.format("<color=%s>%s</color>/%s", self.enough and "white" or "red", string.GetFormattedStr(have), string.GetFormattedStr(self.count)))
                TimerManager:GetInstance():DelayInvoke(function()
                    if self.active then
                        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.text.transform)
                        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.text.transform.parent)
                    end
                end, 0.1)
                return
            end
        end
    end
    self.icon_image:LoadSprite("Assets/Main/Sprites/UI/UIBuildBubble/bubble_icon_ashuoi_award.png")
    self.text:SetText("")
end

local function OnDoAnim(self,order)
    if order == self.param.uuid then
        self.anim:Play("Play", 0, 0)
        local pointId = self.param.uuid
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Ready_Queue)
        TimerManager:GetInstance():DelayInvoke(function()
            DataCenter.LandManager:OnClickFire(pointId)
        end, 1)
    end
end
local function OnClick(self)
    local obj = DataCenter.LandManager:GetObject(LandObjectType.Block, self.param.uuid)
    if obj ~= nil then
        obj:OnClick()
    end
end

UICityHudFireUnlock.ComponentDefine = ComponentDefine
UICityHudFireUnlock.DataDefine = DataDefine
UICityHudFireUnlock.OnAddListener = OnAddListener
UICityHudFireUnlock.OnRemoveListener = OnRemoveListener
UICityHudFireUnlock.SetParam = SetParam
UICityHudFireUnlock.Refresh = Refresh
UICityHudFireUnlock.OnClick = OnClick
UICityHudFireUnlock.OnDoAnim = OnDoAnim
return UICityHudFireUnlock