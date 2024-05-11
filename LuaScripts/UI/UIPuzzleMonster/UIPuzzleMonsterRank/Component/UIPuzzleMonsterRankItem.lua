---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/4/24 12:02
---
local MailPlayerHeroItem = require "UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.BattleTypeNew.MailPlayerHeroItem"
local UIPuzzleMonsterRankItem = BaseClass("UIPuzzleMonsterRankItem",UIBaseContainer)
local base = UIBaseContainer

local player_name_path = "mainContent/nameTxt"
local abbr_path = "mainContent/abbrTxt"
local power_path = "mainContent/powerTxt"
local flag_path = "mainContent/rankImg"
local rank_path = "mainContent/rankNumTxt"
local player_icon_path="mainContent/leftIcon/playerIcon/UIPlayerHead/HeadIcon"
local playerHeadFg_path = "mainContent/leftIcon/playerIcon/UIPlayerHead/Foreground"
local btn_path = "mainContent/showButton"
local content_path ="mainContent/Content"
local Localization = CS.GameEntry.Localization
local function OnCreate(self)
    base.OnCreate(self)
    self.player_name = self:AddComponent(UIText,player_name_path)
    self.abbr = self:AddComponent(UIText,abbr_path)
    self.power_txt = self:AddComponent(UIText,power_path)
    self.rank = self:AddComponent(UIText,rank_path)
    self.flag = self:AddComponent(UIImage,flag_path)
    self.player_img =self:AddComponent(UIPlayerHead,player_icon_path)
    self.playerHeadFg = self:AddComponent(UIImage, playerHeadFg_path)

    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClick()
    end)
    self.content = self:AddComponent(UIBaseContainer,content_path)
    self.model = {}
end

local function SetItemShow(self, data)
    self.data = data
    if data.rank>0 then
        self.rank:SetText(math.floor(data.rank))
        if data.rank==1 then
            self.flag:SetActive(true)
            self.flag:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/rank/UIalliance_rankingbg01.png")
        elseif data.rank ==2 then
            self.flag:SetActive(true)
            self.flag:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/rank/UIalliance_rankingbg02.png")
        elseif data.rank ==3 then
            self.flag:SetActive(true)
            self.flag:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/rank/UIalliance_rankingbg03.png")
        else
            self.flag:SetActive(false)
        end
    else
        self.flag:SetActive(false)
        self.rank:SetText(Localization:GetString("361054"))
    end
    self.power_txt:SetText(string.GetFormattedSeperatorNum(math.floor(data.score)))
    if data.unit~=nil then
        self.player_name:SetText(data.unit.name)
        self.player_img:SetData(data.uid, data.unit.pic, data.unit.picVer)
        local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(data.unit.headSkinId, data.unit.headSkinET, data.unit.headFrame~=nil and data.unit.headFrame ==1) 
        if headBgImg ~= nil  then
            self.playerHeadFg:SetActive(true)
            self.playerHeadFg:LoadSprite(headBgImg)
        else
            self.playerHeadFg:SetActive(false)
        end
        local abbrStr = ""
        if data.unit.alAbbr~=nil then
            abbrStr = data.unit.alAbbr
        end
        if abbrStr~="" then
            self.abbr:SetText("["..abbrStr.."]")
        else
            self.abbr:SetText("")
        end
        self:ShowHeroList(data.unit)
    end
    
end

local function SetSelfRankData(self,data)
    self.data = data
    if data.rank>0 then
        self.rank:SetText(math.floor(data.rank))
        if data.rank==1 then
            self.flag:SetActive(true)
            self.flag:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/rank/UIalliance_rankingbg01.png")
        elseif data.rank ==2 then
            self.flag:SetActive(true)
            self.flag:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/rank/UIalliance_rankingbg02.png")
        elseif data.rank ==3 then
            self.flag:SetActive(true)
            self.flag:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/rank/UIalliance_rankingbg03.png")
        else
            self.flag:SetActive(false)
        end
    else
        self.flag:SetActive(false)
        self.rank:SetText(Localization:GetString("361054"))
    end
    self.power_txt:SetText(string.GetFormattedSeperatorNum(math.floor(data.score)))

    self.player_name:SetText(LuaEntry.Player.name)
    self.player_img:SetData(LuaEntry.Player.uid, LuaEntry.Player.pic, LuaEntry.Player.picVer)
    local headBgImg = DataCenter.DecorationDataManager:GetSelfHeadFrame() 
    if headBgImg ~= nil then
        self.playerHeadFg:SetActive(true)
        self.playerHeadFg:LoadSprite(headBgImg)
    else
        self.playerHeadFg:SetActive(false)
    end
    local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    local abbrStr = ""
    if allianceData~=nil then
        abbrStr =  allianceData.abbr
    end
    if abbrStr~="" then
        self.abbr:SetText("["..abbrStr.."]")
    else
        self.abbr:SetText("")
    end
    self:ShowHeroList(data.unit)
end

local function OnClick(self)
    if self.data.uid and self.data.uid ~= LuaEntry.Player.uid then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIOtherPlayerInfo,{ anim = true, hideTop = true},self.data.uid)
    else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerInfo,LuaEntry.Player.uid)
    end
 
end

local function OnDestroy(self)
    base.OnDestroy(self)
end

local function ClearHero(self)
    self.content:RemoveComponents(MailPlayerHeroItem)
    if self.model~=nil then
        for k,v in pairs(self.model) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.model ={}
end

local function ShowHeroList(self,unit)
    self:ClearHero()
    if unit==nil then
        return
    end
    local heroes = unit.heroes
    local heroList = table.values(heroes)
    if #heroList>0 then
        table.sort(heroList, function(heroA, heroB)
            return heroA["index"] < heroB["index"]
        end)
        for _, heroInfo in pairs(heroList) do
            if self.model[_] == nil then
                self.model[_] = self:GameObjectInstantiateAsync(UIAssets.MailPlayerHeroItem, function(request)
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
                    local cell = self.content:AddComponent(MailPlayerHeroItem,nameStr)
                    cell:SetData(heroInfo,nil,false)
                end)
            end
        end
    end
end

UIPuzzleMonsterRankItem.OnCreate = OnCreate
UIPuzzleMonsterRankItem.SetItemShow = SetItemShow
UIPuzzleMonsterRankItem.OnClick = OnClick
UIPuzzleMonsterRankItem.OnDestroy =OnDestroy
UIPuzzleMonsterRankItem.ShowHeroList =ShowHeroList
UIPuzzleMonsterRankItem.ClearHero =ClearHero
UIPuzzleMonsterRankItem.SetSelfRankData =SetSelfRankData
return UIPuzzleMonsterRankItem