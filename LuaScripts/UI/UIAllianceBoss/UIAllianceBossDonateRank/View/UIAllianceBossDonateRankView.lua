local UIAllianceBossDonateRankView = BaseClass("UIAllianceBossDonateRankView", UIBaseView)
local base = UIBaseView
local UIAllianceBossDonateRankPanelCell = require "UI.UIAllianceBoss.UIAllianceBossDonateRank.Component.UIAllianceBossDonateRankPanelCell"

-- path define start

--local common_img_title_path = "UICommonPopUpTitle/Common_img_title"
local panel_path = "UICommonPopUpTitle/panel"
local title_text_path = "UICommonPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local name_des_path = "ImgBg/TItleNode/nameDes"
local power_des_path = "ImgBg/TItleNode/powerDes"
local rank_des_path = "ImgBg/TItleNode/rankDes"
local scroll_view_path = "ImgBg/ScrollView"
local player_name_label_path = "ImgBg/SelfCell/Name"
local rank_label_path = "ImgBg/SelfCell/Rank"
local rank_icon_path = "ImgBg/SelfCell/RankIcon"
-- local second_icon_path = "ImgBg/SelfCell/SecondIcon"
-- local third_icon_path = "ImgBg/SelfCell/ThirdIcon"
local score_txt_path = "ImgBg/SelfCell/Score"
local head_icon_path = "ImgBg/SelfCell/UIPlayerHead/HeadIcon"
-- local score_des_txt_path = "ImgBg/SelfCell/ScoreDesTxt"
local Txt_NoRankTips = "ImgBg/Txt_NoRankTips"

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
    DataCenter.AllianceBossManager:OnSendGetAllianceBossDonateRankMessage()
end

local function OnDisable(self)
    base.OnDisable(self)

end

local function ComponentDefine(self)
   -- self.common_img_title = self:AddComponent(UIImage, common_img_title_path)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.title_text:SetLocalText(390267)
    
    self.rank_des = self:AddComponent(UITextMeshProUGUIEx,rank_des_path)
    self.rank_des:SetLocalText(302043)

    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function() 
        --点击关闭按钮关闭面板
        self.ctrl:CloseSelf()
    end)
    self.panel = self:AddComponent(UIButton, panel_path)
    self.panel:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self.name_des = self:AddComponent(UITextMeshProUGUIEx, name_des_path)
    self.name_des:SetLocalText(100184) -- 名字
    self.power_des = self:AddComponent(UITextMeshProUGUIEx, power_des_path)
    self.power_des:SetLocalText(390448) -- 分数
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnRankItemMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnRankItemMoveOut(itemObj, index)
    end)
    self.player_name_label = self:AddComponent(UITextMeshProUGUIEx, player_name_label_path)
    self.rank_label = self:AddComponent(UITextMeshProUGUIEx, rank_label_path)
    self.rank_icon_image = self:AddComponent(UIImage, rank_icon_path)
    -- self.second_icon = self:AddComponent(UIImage, second_icon_path)
    -- self.third_icon = self:AddComponent(UIImage, third_icon_path)
    self.score_txt = self:AddComponent(UITextMeshProUGUIEx, score_txt_path)
    self.head_icon = self:AddComponent(UIPlayerHead, head_icon_path)
    -- self.score_des_txt = self:AddComponent(UITextMeshProUGUIEx, score_des_txt_path)
    -- self.score_des_txt:SetLocalText(390448) -- 分数
    
    self._noRankTips_txt = self:AddComponent(UITextMeshProUGUIEx,Txt_NoRankTips)
end

local function ComponentDestroy(self)
    self.common_img_title = nil
    self.close_btn = nil
    self.panel = nil
    self.name_des = nil
    self.power_des = nil
    self.scroll_view = nil
    self.player_name_label = nil
    self.rank_label = nil
    self.rank_icon_image = nil
    -- self.second_icon = nil
    -- self.third_icon = nil
    self.score_txt = nil
    self.head_icon = nil
    -- self.score_des_txt = nil
    self.title_text = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.GetAllianceBossDonateRank, self.OnDonateRankDataReturn)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.GetAllianceBossDonateRank, self.OnDonateRankDataReturn)
    base.OnRemoveListener(self)
end

--scrollview 相关
local function ClearScroll(self)
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UIAllianceBossDonateRankPanelCell)
end

local function OnDonateRankDataReturn(self)
    self:ShowCells()
end

local function ShowCells(self)
    self:ClearScroll()
    self.dataList = DataCenter.AllianceBossManager:GetDonateRewardCellsData()
    if self.dataList == nil then
        return
    end

    self.scroll_view:SetTotalCount(#self.dataList)
    if #self.dataList > 0 then
        self._noRankTips_txt:SetActive(false)
        self.scroll_view:SetActive(true)
        self.scroll_view:RefillCells()
    else
        self.scroll_view:SetActive(false)
        self._noRankTips_txt:SetActive(true)
        self._noRankTips_txt:SetLocalText(373050)
    end

    -- 刷新自己
    self.selfData = nil
    for _, v in ipairs(self.dataList) do
        if LuaEntry.Player.uid == v.uid then
            self.selfData = v
        end
    end

    self:RefreshSelfScore()
end

local function OnRankItemMoveIn(self, itemObj, index)
    itemObj.name = tostring(index)
    local cellComp = self.scroll_view:AddComponent(UIAllianceBossDonateRankPanelCell, itemObj)
    cellComp:SetData(self.dataList[index])
end

local function OnRankItemMoveOut(self, itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIAllianceBossDonateRankPanelCell)
end
--scrollview 结束

local function RefreshSelfScore(self)

    self.rank_label:SetActive(false)
    self.rank_icon_image:SetActive(false)
    -- self.second_icon:SetActive(false)
    -- self.third_icon:SetActive(false)

    if self.selfData == nil then
        --未上榜
        self.rank_label:SetText("-")
        self.rank_label:SetActive(true)
        self.score_txt:SetText("0")
    else

        -- self.rank_label:SetText(tostring(self.selfData.rank))
        self.score_txt:SetText(string.GetFormattedSeperatorNum(self.selfData.score))

        if self.selfData.rank <= 3 then
            self.rank_label:SetActive(false)
            self.rank_icon_image:SetActive(true)
            self.rank_icon_image:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/rank/UIalliance_rankingbg0" .. self.selfData.rank)
        else
            self.rank_icon_image:SetActive(false)
            self.rank_label:SetActive(true)
            self.rank_label:SetText(tostring(self.selfData.rank))
        end
    end


    -- local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    -- local selfAbbrName = ""
    -- if allianceData~=nil and LuaEntry.Player:IsInAlliance()  then
    --     selfAbbrName = "["..allianceData.abbr.."]"
    -- end

    self.player_name_label:SetText(LuaEntry.Player.name)
    self.head_icon:SetData(LuaEntry.Player.uid, LuaEntry.Player.pic, LuaEntry.Player.picVer)
end

UIAllianceBossDonateRankView.OnCreate = OnCreate
UIAllianceBossDonateRankView.OnDestroy = OnDestroy
UIAllianceBossDonateRankView.OnEnable = OnEnable
UIAllianceBossDonateRankView.OnDisable = OnDisable
UIAllianceBossDonateRankView.ComponentDefine = ComponentDefine
UIAllianceBossDonateRankView.ComponentDestroy = ComponentDestroy
UIAllianceBossDonateRankView.OnAddListener = OnAddListener
UIAllianceBossDonateRankView.OnRemoveListener = OnRemoveListener
UIAllianceBossDonateRankView.OnRankItemMoveIn = OnRankItemMoveIn
UIAllianceBossDonateRankView.OnRankItemMoveOut = OnRankItemMoveOut
UIAllianceBossDonateRankView.OnDonateRankDataReturn = OnDonateRankDataReturn
UIAllianceBossDonateRankView.ShowCells = ShowCells
UIAllianceBossDonateRankView.ClearScroll = ClearScroll
UIAllianceBossDonateRankView.RefreshSelfScore = RefreshSelfScore

return UIAllianceBossDonateRankView