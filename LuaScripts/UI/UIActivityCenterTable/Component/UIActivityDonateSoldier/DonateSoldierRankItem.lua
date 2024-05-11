local DonateSoldierRankItem = BaseClass("DonateSoldierRankItem", UIBaseContainer)
local base = UIBaseContainer;

local rank_label_path = "ScoreNode/SelfRankLabel"
local head_pic_img_path = "ScoreNode/UIPlayerHead/HeadIcon"
local player_name_label_path = "ScoreNode/SelfNameLabel"
local player_score_label_path = "ScoreNode/SelfPowerLabel"
local player_info_btn_path = "ScoreNode/PlayerInfoBtn"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.rank_label = self:AddComponent(UIText, rank_label_path)
    self.head_pic_img = self:AddComponent(UIPlayerHead,head_pic_img_path)
    self.player_name_label = self:AddComponent(UIText, player_name_label_path)
    self.player_score_label = self:AddComponent(UIText, player_score_label_path)
    self.player_info_btn = self:AddComponent(UIButton, player_info_btn_path)
    self.player_info_btn:SetOnClick(function()
        self:OnPlayerCellClick()
    end)
end

local function ComponentDestroy(self)
    self.rank_label = nil
    self.head_pic_img = nil
    self.player_name_label = nil
    self.player_score_label = nil
    self.player_info_btn = nil

end

local function SetData(self, dataInfo, idx)
    if dataInfo.uid == "" or dataInfo.uid == nil then
        self.rank_label:SetText(tostring(idx))
        self.dataInfo = dataInfo
        local uid = dataInfo.uid
        local pic = dataInfo.pic
        local picVer = dataInfo.picVer
        self.head_pic_img:SetData(uid, pic, picVer)
        self.player_name_label:SetLocalText(391071)
        self.player_score_label:SetText(0)
    else
        self.rank_label:SetText(tostring(idx))
        self.dataInfo = dataInfo
        local uid = dataInfo.uid
        local pic = dataInfo.pic
        local picVer = dataInfo.picVer
        self.head_pic_img:SetData(uid, pic, picVer)
        local abbrName = ""
        if dataInfo.abbr ~= nil then
            abbrName = "["..dataInfo.abbr.."]"
        end
        self.player_name_label:SetText(abbrName .. dataInfo.name)
        self.player_score_label:SetText(string.GetFormattedSeperatorNum(dataInfo.score))
    end
end

local function OnPlayerCellClick(self)
    if self.dataInfo.uid ~= nil and self.dataInfo.uid ~= "" then
        if self.dataInfo.uid ~= LuaEntry.Player.uid then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIOtherPlayerInfo,self.dataInfo.uid)
        else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerInfo,LuaEntry.Player.uid)
        end
    end
end

DonateSoldierRankItem.OnCreate = OnCreate
DonateSoldierRankItem.OnDestroy = OnDestroy
DonateSoldierRankItem.OnEnable = OnEnable
DonateSoldierRankItem.OnDisable = OnDisable
DonateSoldierRankItem.ComponentDefine = ComponentDefine
DonateSoldierRankItem.ComponentDestroy = ComponentDestroy
DonateSoldierRankItem.SetData = SetData
DonateSoldierRankItem.OnPlayerCellClick = OnPlayerCellClick

return DonateSoldierRankItem