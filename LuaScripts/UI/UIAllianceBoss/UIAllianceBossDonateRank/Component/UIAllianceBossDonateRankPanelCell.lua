local UIAllianceBossDonateRankPanelCell = BaseClass("UIAllianceBossDonateRankPanelCell", UIBaseContainer)
local base = UIBaseContainer

-- path define start

local player_name_label_path = "Name"
local power_label_path = "Score"
local rank_icon_path = "RankIcon"
-- local second_icon_path = "SecondIcon"
-- local third_icon_path = "ThirdIcon"
local rank_label_path = "Rank"
local u_i_player_head_path = "UIPlayerHead"
local head_icon_path = "UIPlayerHead/HeadIcon"
local button_path = "Button"

-- path define end

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    base.OnDestroy(self)
    self:ComponentDestroy()
end

local function OnEnable(self)
    base.OnEnable(self)

end

local function OnDisable(self)
    base.OnDisable(self)

end

local function ComponentDefine(self)
    
    self.player_name_label = self:AddComponent(UITextMeshProUGUIEx, player_name_label_path)
    self.power_label = self:AddComponent(UITextMeshProUGUIEx, power_label_path)
    self.rank_icon_image = self:AddComponent(UIImage, rank_icon_path)
    -- self.second_icon = self:AddComponent(UIImage, second_icon_path)
    -- self.third_icon = self:AddComponent(UIImage, third_icon_path)
    self.rank_label = self:AddComponent(UITextMeshProUGUIEx, rank_label_path)
    self.u_i_player_head = self:AddComponent(UIButton, u_i_player_head_path)
    self.head_icon = self:AddComponent(UIPlayerHead, head_icon_path)
    self.button = self:AddComponent(UIButton, button_path)
    self.button:SetOnClick(function()
        self:OnPlayerCellClick()
    end)
end

local function ComponentDestroy(self)
    self.player_name_label = nil
    self.power_label = nil
    self.rank_icon_image = nil
    -- self.second_icon = nil
    -- self.third_icon = nil
    self.rank_label = nil
    self.u_i_player_head = nil
    self.button = nil
    self.head_icon = nil

end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function SetData(self, data)
    --[[
        name:
        "jlsjaj"
        pic:
        "player_head_3"
        picVer:
        1
        rank:
        1
        score:
        130
        serverId:
        52
        uid:
        "1034817914000152"
    ]]
    self.rank_icon_image:SetActive(false)
    -- self.second_icon:SetActive(false)
    -- self.third_icon:SetActive(false)
    self.rank_label:SetActive(false)

    if data.rank <= 0 then
        self.rank_label:SetActive(true)
        self.rank_label:SetText("-")
        self.rank_icon_image:SetActive(false)
    elseif data.rank <= 3 then
        self.rank_label:SetActive(false)
        self.rank_icon_image:SetActive(true)
        self.rank_icon_image:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/rank/UIalliance_rankingbg0" .. data.rank)
    else
        if data.rank>1000 then
            self.rank_label:SetText("+999")
        else
            self.rank_label:SetText(data.rank)
        end
        self.rank_label:SetActive(true)
        
        self.rank_icon_image:SetActive(false)
    end



    -- if data.rank == 1 then
    --     self.first_icon:SetActive(true)
    -- elseif data.rank == 2 then
    --     self.second_icon:SetActive(true)
    -- elseif data.rank == 3 then
    --     self.third_icon:SetActive(true)
    -- else
    --     self.rank_label:SetText(tostring(data.rank))
    -- end
    self.power_label:SetText(tostring(data.score))

    self.playerUid = data.uid
    self.head_icon:SetData(data.uid, data.pic, data.picVer)
    self.player_name_label:SetText(data.name)
    -- local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.detail.headSkinId, self.detail.headSkinET)
    -- if headBgImg then
    --     self.playerHeadFgN:SetActive(true)
    --     self.playerHeadFgN:LoadSprite(headBgImg)
    -- else
    --     self.playerHeadFgN:SetActive(false)
    -- end
end

local function OnPlayerCellClick(self)
    if self.playerUid ~= nil and self.playerUid ~= "" then
        if self.playerUid ~= LuaEntry.Player.uid then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIOtherPlayerInfo, { anim = true}, self.playerUid)
        else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerInfo, LuaEntry.Player.uid)
        end
    end
end

UIAllianceBossDonateRankPanelCell.OnCreate = OnCreate
UIAllianceBossDonateRankPanelCell.OnDestroy = OnDestroy
UIAllianceBossDonateRankPanelCell.OnEnable = OnEnable
UIAllianceBossDonateRankPanelCell.OnDisable = OnDisable
UIAllianceBossDonateRankPanelCell.ComponentDefine = ComponentDefine
UIAllianceBossDonateRankPanelCell.ComponentDestroy = ComponentDestroy
UIAllianceBossDonateRankPanelCell.OnAddListener = OnAddListener
UIAllianceBossDonateRankPanelCell.OnRemoveListener = OnRemoveListener
UIAllianceBossDonateRankPanelCell.SetData = SetData
UIAllianceBossDonateRankPanelCell.OnPlayerCellClick = OnPlayerCellClick

return UIAllianceBossDonateRankPanelCell