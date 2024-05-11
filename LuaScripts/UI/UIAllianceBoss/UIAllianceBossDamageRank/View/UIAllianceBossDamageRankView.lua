local UIAllianceBossDamageRank = BaseClass("UIAllianceBossDamageRank", UIBaseView)
local base = UIBaseView
local UIAllianceBossDamageRankItem = require "UI.UIAllianceBoss.UIAllianceBossDamageRank.Component.UIAllianceBossDamageRankItem"
local UICommonItem = require "UI.UICommonItem.UICommonItem"
-- path define start
local txt_title_path ="UICommonPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local scroll_view_path = "ImgBg/ScrollView"

local name_txt_path = "ImgBg/TItleNode/nameTxt"
local score_txt_path = "ImgBg/TItleNode/scoreTxt"
local army_txt_path = "ImgBg/TItleNode/armyTxt"
local txt_empty_path = "ImgBg/TxtEmpty"



--path define end

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
    DataCenter.AllianceBossManager:OnSendGetAllianceBossDamageRank()
end

local function OnDisable(self)
    base.OnDisable(self)

end

local function ComponentDefine(self)
    self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
    self.txt_title:SetLocalText(302822)
    
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:CellMoveIn(itemObj, index)
    end)

    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:CellMoveOut(itemObj, index)
    end)

    self.name_txt = self:AddComponent(UITextMeshProUGUIEx, name_txt_path)
    self.name_txt:SetLocalText(100184)
    self.score_txt = self:AddComponent(UITextMeshProUGUIEx, score_txt_path)
    self.score_txt:SetLocalText(150222)
    self.army_txt = self:AddComponent(UITextMeshProUGUIEx, army_txt_path)
    self.army_txt:SetLocalText(130065)
    self.txt_empty = self:AddComponent(UITextMeshProUGUIEx, txt_empty_path)
    self.txt_empty:SetLocalText(371004)

    
    self._selfRank_txt = self:AddComponent(UITextMeshProUGUIEx,"ImgBg/selfObj/Txt_SelfRank")
    self._selfName_txt = self:AddComponent(UITextMeshProUGUIEx,"ImgBg/selfObj/Txt_SelfName")
    self._selfAllianceName_txt = self:AddComponent(UITextMeshProUGUIEx,"ImgBg/selfObj/Txt_SelfAllianceName")
    self._selfScore_txt = self:AddComponent(UITextMeshProUGUIEx,"ImgBg/selfObj/Txt_SelfScore")
    self.content = self:AddComponent(UIBaseContainer,"ImgBg/selfObj/Content")
    self.player_flag = self:AddComponent(UIBaseContainer,"ImgBg/selfObj/UIPlayerHead")
    self.player_img = self:AddComponent(UIPlayerHead, "ImgBg/selfObj/UIPlayerHead/HeadIcon")
    self.playerHeadFg = self:AddComponent(UIImage, "ImgBg/selfObj/UIPlayerHead/Foreground")
    self.flag = self:AddComponent(UIImage,"ImgBg/selfObj/RankIcon")
end

local function ComponentDestroy(self)
    self.name_txt = nil
    self.score_txt = nil
    self.army_txt = nil
    self.scroll_view = nil
    self.return_btn = nil
    self.close_btn = nil
    self.txt_empty = nil

end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.GetAllianceBossDamageRank, self.OnDamageRankDataReturn)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.GetAllianceBossDamageRank, self.OnDamageRankDataReturn)
    base.OnRemoveListener(self)
end

local function OnDamageRankDataReturn(self)
    self.damageList = DataCenter.AllianceBossManager:GetDamageRankListData()
    self.rewardList = DataCenter.AllianceBossManager:GetDamageRewardListData()
    local selfRank,selfScore = DataCenter.AllianceBossManager:GetSelfDamageRank()
    if selfRank > 0 then
        if selfRank==1 then
            self.flag:SetActive(true)
            self._selfRank_txt:SetActive(false)
            self.flag:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/rank/UIalliance_rankingbg01.png")
        elseif selfRank ==2 then
            self.flag:SetActive(true)
            self._selfRank_txt:SetActive(false)
            self.flag:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/rank/UIalliance_rankingbg02.png")
        elseif selfRank ==3 then
            self.flag:SetActive(true)
            self._selfRank_txt:SetActive(false)
            self.flag:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/rank/UIalliance_rankingbg03.png")
        else
            self.flag:SetActive(false)
            self._selfRank_txt:SetActive(true)
        end
        self._selfRank_txt:SetText(selfRank)
        --找到自己的奖励
        local selfReward = nil
        if self.rewardList then
            for i = 1 ,table.count(self.rewardList) do
                if self.rewardList[i].start == self.rewardList[i]["end"] then
                    if selfRank == self.rewardList[i].start then
                        selfReward = self.rewardList[i].reward
                        break
                    end
                elseif self.rewardList[i].start <= selfRank and selfRank <= self.rewardList[i]["end"]  then
                    selfReward = self.rewardList[i].reward
                    break
                end
            end
            if selfReward then
                if self.cells then
                    for _,v in ipairs(self.cells) do
                        self:GameObjectDestroy(v)
                    end
                end
                self.cells = {}
                for k,v in ipairs(selfReward) do
                    self.cells[k] = self:GameObjectInstantiateAsync(UIAssets.UICommonItemSize, function(request)
                        if request.isError then
                            return
                        end
                        local go = request.gameObject
                        go.gameObject:SetActive(true)
                        go.transform:SetParent(self.content.transform)
                        -- go.transform:Set_localScale(0.5, 0.5, 0.5)
                        local nameStr = tostring(NameCount)
                        go.name = nameStr
                        NameCount = NameCount + 1
                        local cell = self.content:AddComponent(UICommonItem, nameStr)
                        local para = {}
                        para.rewardType = v.type
                        if type(v.value) == 'number' then
                            para.count = v.value
                        else
                            para.itemId = v.value.id
                            para.count = v.value.num
                        end
                        cell:ReInit(para)
                    end)
                end
            end
        end
    else
        self._selfRank_txt:SetText("-")
    end
    self._selfScore_txt:SetText(selfScore)
    self.player_img:SetData(LuaEntry.Player:GetUid(),LuaEntry.Player:GetPic(),LuaEntry.Player.picVer)
    local fgImg = LuaEntry.Player:GetHeadBgImg()
    if not string.IsNullOrEmpty(fgImg) then
        self.playerHeadFg:SetActive(true)
        self.playerHeadFg:LoadSprite(fgImg)
    else
        self.playerHeadFg:SetActive(false)
    end
    self._selfName_txt:SetText(LuaEntry.Player:GetName())
    local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allianceData~=nil and LuaEntry.Player:IsInAlliance()  then
        self._selfAllianceName_txt:SetText("["..allianceData.abbr.."]"..allianceData.allianceName)
    else
        self._selfAllianceName_txt:SetText("-")
    end
    self:ShowCells()
end

-- scrollview 相关

local function CellMoveIn(self, itemObj, index)
    local cellName = tostring(index)
    itemObj.name = cellName
    local cell = self.scroll_view:AddComponent(UIAllianceBossDamageRankItem, itemObj)
    local cellData = self.dataList[index]
    cell:SetData(cellData)
end

local function CellMoveOut(self, itemObj, index)
    local cellName = tostring(index)
    self.scroll_view:RemoveComponent(cellName, UIAllianceBossDamageRankItem)
end

local function ClearScroll(self)
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UIAllianceBossDamageRankItem)
end

local function ShowCells(self)
    self:ClearScroll()
    self.dataList = DataCenter.AllianceBossManager:GetDamageRankListData()
    if self.dataList == nil then
        self.txt_empty:SetActive(true)
        return
    end

    local cellCount = #self.dataList
    self.scroll_view:SetTotalCount(cellCount)
    if cellCount > 0 then
        self.scroll_view:RefillCells()
        self.txt_empty:SetActive(false)
    else
        self.txt_empty:SetActive(true)
    end
end

-- scrollview 结束

UIAllianceBossDamageRank.OnCreate = OnCreate
UIAllianceBossDamageRank.OnDestroy = OnDestroy
UIAllianceBossDamageRank.OnEnable = OnEnable
UIAllianceBossDamageRank.OnDisable = OnDisable
UIAllianceBossDamageRank.ComponentDefine = ComponentDefine
UIAllianceBossDamageRank.ComponentDestroy = ComponentDestroy
UIAllianceBossDamageRank.OnAddListener = OnAddListener
UIAllianceBossDamageRank.OnRemoveListener = OnRemoveListener
UIAllianceBossDamageRank.OnDamageRankDataReturn = OnDamageRankDataReturn

UIAllianceBossDamageRank.CellMoveIn = CellMoveIn
UIAllianceBossDamageRank.CellMoveOut = CellMoveOut
UIAllianceBossDamageRank.ClearScroll = ClearScroll
UIAllianceBossDamageRank.ShowCells = ShowCells

return UIAllianceBossDamageRank