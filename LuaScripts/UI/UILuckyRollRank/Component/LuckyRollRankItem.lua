---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 22/2/2024 上午10:26
---
local LuckyRollRankItem = BaseClass("LuckyRollRankItem",UIBaseContainer)
local base = UIBaseContainer

local bg_path = "Common_supple"
local first_name_path = "firstNameTxt"
local second_name_path = "secondNameTxt"
local power_path = "powerTxt" -- 右边那列
local num_path = "numTxt"
local first_flag_path = "firstImg"
local second_flag_path = "secondImg"
local third_flag_path = "thirdImg"
local player_flag_path = "playerFlag"
local player_icon_path="playerFlag/UIPlayerHead/HeadIcon"
local playerHeadFg_path = "playerFlag/UIPlayerHead/Foreground"
local btn_path = "Button"
local player_btn_path="playerFlag/UIPlayerHead"

local Localization = CS.GameEntry.Localization
local function OnCreate(self)
    base.OnCreate(self)
    self.bgN = self:AddComponent(UIImage, bg_path)
    self.first_txt= self:AddComponent(UITextMeshProUGUIEx,first_name_path)
    self.second_txt = self:AddComponent(UITextMeshProUGUIEx,second_name_path)
    self.power_txt = self:AddComponent(UITextMeshProUGUIEx,power_path)
    self.num_txt = self:AddComponent(UITextMeshProUGUIEx,num_path)

    self.first_flag = self:AddComponent(UIBaseContainer,first_flag_path)
    self.second_flag = self:AddComponent(UIBaseContainer,second_flag_path)
    self.third_flag = self:AddComponent(UIBaseContainer,third_flag_path)

    self.player_flag = self:AddComponent(UIBaseContainer,player_flag_path)

    self.player_img =self:AddComponent(UIPlayerHead,player_icon_path)
    self.playerHeadFg = self:AddComponent(UIImage, playerHeadFg_path)

    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClick()
    end)
    self.player_btn =self:AddComponent(UIButton,player_btn_path)
    self.player_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnPlayerBtnClick()
    end)
end

local function SetItemShow(self, data)
    self.data = data
    self.first_flag:SetActive(self.data.rank ==1)
    self.third_flag:SetActive(self.data.rank ==3)
    self.second_flag:SetActive(self.data.rank ==2)

    self.num_txt:SetText(self.data.rank)
    if self.data.rank>=999 then
        self.num_txt:SetText("999+")
    end
    if self.data.rank>3 then
        self.bgN:LoadSprite("Assets/Main/Sprites/UI/UIArena/arena_img_columns04")
        self.num_txt:SetActive(true)
        --self.num_txt:SetColor(Color.New(1,0.73,0.19,1))
    else
        self.num_txt:SetActive(false)
        self.bgN:LoadSprite("Assets/Main/Sprites/UI/UIArena/arena_img_columns0" .. self.data.rank)
        --self.num_txt:SetColor(WhiteColor)
    end
    self.first_txt:SetLocalText(372761,data.serverId,data.name)
    if data.abbr==nil or data.abbr == "" then
        self.second_txt:SetText("-")
    else
        self.second_txt:SetText("["..data.abbr.."]"..data.allianceName)
    end

    self.power_txt:SetText(string.GetFormattedSeperatorNum(toInt(data.score)))
    self.player_img:SetData(self.data.uid, self.data.pic, self.data.picVer)
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    if data.monthCardEndTime and data.monthCardEndTime then
        self.playerHeadFg:SetActive(data.monthCardEndTime > 0 and data.monthCardEndTime > curTime)
    elseif data.isMonthCardShow ==true then
        self.playerHeadFg:SetActive(true)
    else
        self.playerHeadFg:SetActive(false)
    end
end

local function OnClick(self)
    if self.data.uid ~= LuaEntry.Player.uid then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIOtherPlayerInfo,self.data.uid)
    else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerInfo,LuaEntry.Player.uid)
    end
end
local function OnDestroy(self)
    self.first_txt= nil
    self.second_txt = nil
    self.power_txt = nil
    self.power2_txt = nil
    self.num_txt = nil

    self.first_flag = nil
    self.second_flag = nil
    self.third_flag = nil

    self.player_flag = nil
    self.alliance_flag =nil

    self.player_img =nil

    self.btn = nil
    base.OnDestroy(self)
end

function LuckyRollRankItem:OnPlayerBtnClick()
    if self.data.uid ~= LuaEntry.Player.uid then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIOtherPlayerInfo,self.data.uid)
    else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerInfo,LuaEntry.Player.uid)
    end
end

LuckyRollRankItem.OnCreate = OnCreate
LuckyRollRankItem.SetItemShow = SetItemShow
LuckyRollRankItem.OnClick = OnClick
LuckyRollRankItem.OnDestroy =OnDestroy
return LuckyRollRankItem