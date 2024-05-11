---
--- Created by shimin.
--- DateTime: 2024/2/21 11:44
---

local UIPersonalWarPlayerItem = BaseClass("UIPersonalWarPlayerItem",UIBaseContainer)
local base = UIBaseContainer
local UIHeroCell = require "UI.UIChatNew.Component.RadarAlarmCells.UIRadarHeroICell"
local AllianceWarPlayerSoliderItem = require "UI.UIAlliance.UIAllianceAlertDetail.Component.AllianceAlertSoliderItem"

local name_path = "mainContent/nameTxt"
local power_path = "mainContent/powerTxt"
local _content_rect = "mainContent/Content"
local leader_img_path = "mainContent/Img_leader"
local content_path = "armyContent"
local playerHead_btn_path = "mainContent/UIPlayerHead"
local playerHead_path = "mainContent/UIPlayerHead/HeadIcon"
local playerHeadBg_path = "mainContent/UIPlayerHead/Foreground"

function UIPersonalWarPlayerItem:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UIPersonalWarPlayerItem:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIPersonalWarPlayerItem:ComponentDefine()
    self.name = self:AddComponent(UITextMeshProUGUIEx,name_path)
    self.power = self:AddComponent(UITextMeshProUGUIEx,power_path)
    self._content_rect = self:AddComponent(UIBaseContainer,_content_rect)
    self.content = self:AddComponent(UIBaseContainer,content_path)
    self.playerHead_btn = self:AddComponent(UIButton,playerHead_btn_path)
    self.playerHead_btn:SetOnClick(function()
        self:OnClickPlayerHeadBtn()
    end)
    self.playerHead = self:AddComponent(UIPlayerHead, playerHead_path)
    self.playerHeadBg = self:AddComponent(UIImage, playerHeadBg_path)
    self._leader_img = self:AddComponent(UIImage,leader_img_path)
end

function UIPersonalWarPlayerItem:ComponentDestroy()
end

function UIPersonalWarPlayerItem:DataDefine()
    self.modelSoldier = {}
    self.modelHero = {}
    self.otherPlayerUid = nil
end

function UIPersonalWarPlayerItem:DataDestroy()
    self.modelSoldier = {}
    self.modelHero = {}
    self.otherPlayerUid = nil
end
function UIPersonalWarPlayerItem:OnEnable()
    base.OnEnable(self)
end

function UIPersonalWarPlayerItem:OnDisable()
    base.OnDisable(self)
end

function UIPersonalWarPlayerItem:SetAllCellDestroy()
    self.content:RemoveComponents(AllianceWarPlayerSoliderItem)
    if next(self.modelSoldier) then
        for k,v in pairs(self.modelSoldier) do
            self:GameObjectDestroy(v)
        end
        self.modelSoldier = {}
    end
end

function UIPersonalWarPlayerItem:SetAllCellDestroyHero()
    self._content_rect:RemoveComponents(UIHeroCell)
    if next(self.modelHero) then
        for k,v in pairs(self.modelHero) do
            self:GameObjectDestroy(v)
        end
        self.modelHero = {}
    end
end

--个人 加载被援助和攻击人的英雄和兵力
function UIPersonalWarPlayerItem:ShowHeroAndSolider(param, armyInfo)
    self:SetAllCellDestroy()
    self:SetAllCellDestroyHero()
    self.playerHeadBg:SetActive(false)
    if param == nil then
        self._leader_img:SetActive(false)
        self.power:SetActive(false)
        self.name:SetActive(false)
        self.playerHead_btn:SetActive(false)
    else
        if param.teamUuid == 0 then
            self._leader_img:SetActive(false)
        else
            self._leader_img:SetActive(true)
        end
        self.power:SetActive(true)
        self.power:SetText(string.GetFormattedSeperatorNum(param:GetSoliderNum()))
        self.name:SetActive(true)
        local allianceAbbr = param.allianceAbbr or ""
        if allianceAbbr == "" then
            self.name:SetText(param.ownerName)
        else
            self.name:SetText("[".. allianceAbbr .."]"..param.ownerName)
        end
        self.otherPlayerUid = param.ownerUid
        self.playerHead_btn:SetActive(true)
        self.playerHead:SetData(param.ownerUid,param.pic,param.picVer)
    end

    if armyInfo ~= nil then
        for k, v in ipairs(armyInfo.HeroInfos) do
            self.modelHero[v.heroId] = self:GameObjectInstantiateAsync(UIAssets.AllianceHeroCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go.gameObject:SetActive(true)
                go.transform:SetParent(self._content_rect.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.name = "item" .. tonumber(k)
                local cell = self._content_rect:AddComponent(UIHeroCell, go.name)
                local curMilitaryRankId = HeroUtils.GetRankIdByLvAndStage(v.heroId, v.rankLv, v.stage)
                cell:InitWithConfigId(v.heroId, v.heroQuality, v.heroLevel, curMilitaryRankId)
            end)
        end
        for k, v in ipairs(armyInfo.Soldiers) do
            self.modelSoldier[v.armsId] = self:GameObjectInstantiateAsync(UIAssets.AllianceWarPlayerSoliderItem, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.name = "item" .. tonumber(k)
                local cell = self.content:AddComponent(AllianceWarPlayerSoliderItem, go.name)
                cell:SetData(v.armsId, v.total)
            end)
        end
    end
end

function UIPersonalWarPlayerItem:OnClickPlayerHeadBtn()
    if self.otherPlayerUid ~= nil and self.otherPlayerUid ~= "" then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIOtherPlayerInfo, self.otherPlayerUid)
    end
end

return UIPersonalWarPlayerItem