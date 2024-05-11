---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 7/9/21 6:47 PM
---
local MailSystem = BaseClass("MailSystem",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local base64 = require "Framework.Common.base64"
local HeroRewardItem = require "UI.UICapacityBoxSelect.Component.UICapacityBoxHeroItem"
local MailRewardItem = require "UI.UIMailNew.UIMailMainPanel.Component.MailRewardItem"
local MailUserItem = require "UI.UIMailNew.UIMailMainPanel.Component.MailUserItem"
local rapidjson = require "rapidjson"

local _cp_this = ""
local _cp_txtMainTitle = "UIMailItemTitle/txtMainTitle"
local _cp_txtSubTitle = "UIMailItemTitle/txtSubTitle"
local _cp_txtTime = "UIMailItemTitle/txtTime"
local _cp_txtDesc = "txtDesc"
local _cp_subDesc = "Image/subDesc"
local _cp_objUser = "objUserNode"
local _cp_objReward = "objRewardNode"
local _cp_objGetReward = "objGetReward"
local _cp_btnGetReward = "objGetReward/btnGetReward"
local _cp_txtGetReward = "objGetReward/btnGetReward/txtGetReward"
local _cp_btnGiveBack = "objGetReward/btnGiveBack"
local _cp_txtGiveBack = "objGetReward/btnGiveBack/txtGiveBack"


function MailSystem:OnCreate()
    base.OnCreate(self)
    self.go = self:AddComponent(UIBaseContainer, _cp_this)
    self._txtMainTitle = self:AddComponent(UITextMeshProUGUIEx, _cp_txtMainTitle)
    self._txtSubTitle = self:AddComponent(UITextMeshProUGUIEx, _cp_txtSubTitle)
    self._txtTime = self:AddComponent(UITextMeshProUGUIEx, _cp_txtTime)
    self._subDesc = self:AddComponent(UITextMeshProUGUIEx, _cp_subDesc)
    self._subDesc:SetLocalText(450062)
    self._txtDesc = self:AddComponent(UITextMeshProUGUIEx, _cp_txtDesc)
    self._txtDesc:OnPointerClick(function (eventData)
        self:OnPointerClick(eventData.position)
    end)
    
    
    self._objReward = self:AddComponent(UIBaseContainer, _cp_objReward)
    self._objUser = self:AddComponent(UIBaseContainer, _cp_objUser)

    self._objGetReward = self:AddComponent(UIBaseContainer, _cp_objGetReward)
    self._btnGetReward = self:AddComponent(UIButton, _cp_btnGetReward)
    self._btnGetReward:SetOnClick(BindCallback(self, self.OnClickBtnGetReward))
    self._txtGetReward = self:AddComponent(UITextMeshProUGUIEx, _cp_txtGetReward)
    
    self._btnGiveBack = self:AddComponent(UIButton, _cp_btnGiveBack)
    self._btnGiveBack:SetOnClick(function()
        self:OnClickBtnGiveBack()
    end)
    self._btnGiveBack:SetActive(false)
    self._txtGiveBack = self:AddComponent(UITextMeshProUGUIEx, _cp_txtGiveBack)
    
    self.cell_prefab = self.transform:Find("MailRewardItem").gameObject
    self.cell_prefab:GameObjectCreatePool()
    
    self.hero_prefab = self.transform:Find("HeroRewardItem").gameObject
    self.hero_prefab:GameObjectCreatePool()

    self.userPrefab = self.transform:Find("MailUserItem").gameObject
    self.userPrefab:GameObjectCreatePool()

end

function MailSystem:OnPointerClick( clickPos )
    if (self._txtDesc == nil) then
        return
    end
    local pos = clickPos
    local x = pos.x
    local y = pos.y
    local vec3 = Vector3.New(x, y, 0)
    local linkIndex = CS.TMPro.TMP_TextUtilities.FindIntersectingLink(self._txtDesc.unity_tmpro, vec3, nil);
    if (linkIndex == -1) then
        return
    end
    local linkInfo = self._txtDesc:GetLinkInfo()
    if (linkInfo == nil) then
        return
    end
    local linkItem = linkInfo[linkIndex]
    local linkId = linkItem:GetLinkID()
    if (string.IsNullOrEmpty(linkId)) then
        return
    end
    local linkMsg = base64.decode(linkId)
    linkMsg = rapidjson.decode(linkMsg)
    self:OnHandleLink(linkMsg)
end

function MailSystem:OnHandleLink(linkMsg)
    if (linkMsg["action"] == "Jump") then
        self:OnMoveToPos(linkMsg)
    elseif linkMsg["action"] == "Url" then
        CS.UnityEngine.Application.OpenURL(linkMsg["url"]);
    end
end

function MailSystem:OnMoveToPos(linkMsg)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMailNew)
    local x = tonumber(linkMsg["x"]) or 1
    local y = tonumber(linkMsg["y"]) or 1
    local v2 = {}
    v2.x = x
    v2.y = y
    local pointId = SceneUtils.TileToWorld(v2, ForceChangeScene.World)
    local serverId = linkMsg["server"] or LuaEntry.Player:GetCurServerId()
    local worldId = linkMsg["worldId"] or 0
    TimerManager:GetInstance():DelayInvoke(function()
        GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), CS.SceneManager.World.InitZoom,nil,nil,serverId)
    end, 0.1)
end

function MailSystem:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.NoticeItemReward, self.CheckRewardState)
    --self:AddUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
    self:AddUIListener(EventId.ChangeShowTranslatedNotice, self.OnTranslateSucc)
end

function MailSystem:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.NoticeItemReward,self.CheckRewardState)
    --self:RemoveUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
    self:RemoveUIListener(EventId.ChangeShowTranslatedNotice, self.OnTranslateSucc)
end

function MailSystem:CheckRewardState()
    self._mailData = DataCenter.WorldNoticeManager:GetNoticeInfoById(self._mailData.uuid)
    self:ShowRewardBtn(self._mailData)
end

function MailSystem:OnDisable()
    self._objReward:RemoveComponents(MailRewardItem)
    self._objReward:RemoveComponents(HeroRewardItem)
    self.cell_prefab.gameObject:GameObjectRecycleAll()
    self._objUser:RemoveComponents(MailUserItem)
    self.userPrefab.gameObject:GameObjectRecycleAll()
    base.OnDisable(self)
end

function MailSystem:OnClickBtnGetReward()
    if self.isGoUpdate then
        CS.UnityEngine.Application.OpenURL(CS.GameEntry.GlobalData.downloadurl)
    else
        local reward = self._mailData:GetMailReward()
        if reward and reward.rewardLevel then
            if DataCenter.BuildManager.MainLv >= reward.rewardLevel then
                DataCenter.WorldNoticeManager:SendReceiveReward(self._mailData.uuid)
            else
                UIUtil.ShowTips(Localization:GetString("462002",reward.rewardLevel))
            end 
        else
            DataCenter.WorldNoticeManager:SendReceiveReward(self._mailData.uuid)
        end
        
    end
end

function MailSystem:OnClickBtnGiveBack()
    if DataCenter.MonthCardNewManager:CheckIfMonthCardActive() then
        GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_GROCERY_STORE, WorldTileBtnType.GolloesCamp)
    else
        GoToUtil.GoToMonthCard()
    end
end

function MailSystem:setData( maildata )
    self._mailData = maildata
    -- 设置数据
    self._txtMainTitle:SetText(self._mailData.title)
    self._txtSubTitle:SetText(self._mailData.subTitle)
    local _strTime = MailShowHelper.GetAbstractCreateTime(maildata)
    self._txtTime:SetText(_strTime)
    local _strContents = maildata:GetMailMessage()
    local value = string.gsub(_strContents, "\\n", "\n")
    self._txtDesc:SetText(value)
    -- 创建奖励
    --local rewardList = self:GetRewardList(maildata)
    --local isShowReward = table.count(rewardList) > 0
    self._objReward:SetActive(true)
    self.cell_prefab.gameObject:GameObjectRecycleAll()
    self.hero_prefab.gameObject:GameObjectRecycleAll()

    self._objUser:SetActive(true)
    self.userPrefab.gameObject:GameObjectRecycleAll()

    self:ShowReward(maildata)
    self:ShowUser(maildata)
    
    self:ShowRewardBtn(maildata)
    
end

--[[
    创建单个道具Icon
]]
function MailSystem:ShowRewardItem(rewardData)
    NameCount = NameCount + 1
    if rewardData.rewardType == RewardType.HERO then
        local objName = rewardData["rewardType"] .. NameCount
        --复制基础prefab，每次循环创建一次
        local item = self.hero_prefab:GameObjectSpawn(self._objReward.transform)
        item.name = objName
        local obj = self._objReward:AddComponent(HeroRewardItem,item.name)
        local param = {}
        param.heroId = rewardData.itemId--.id
        param.count = rewardData.count--.num
        local heroName = GetTableData(HeroUtils.GetHeroXmlName(), rewardData.itemId, "name")
        local heroQuality = GetTableData(HeroUtils.GetHeroXmlName(), rewardData.itemId, "init_quality_level")
        param.name = string.format("<color='%s'>%s</color>",HeroUtils.GetQualityColorStr(heroQuality),Localization:GetString(heroName))
        obj:RefreshData(param)
    else
        local objName = rewardData["rewardType"] .. NameCount
        --复制基础prefab，每次循环创建一次
        local item = self.cell_prefab:GameObjectSpawn(self._objReward.transform)
        item.name = objName
        local obj = self._objReward:AddComponent(MailRewardItem,item.name)
        obj:RefreshData(rewardData)
    end
end

--[[
    展示奖励
]]
function MailSystem:ShowReward(maildata)
    local pay = maildata:GetMailPay()
    local reward = maildata:GetMailReward()
    local totalCnt = 0
    -- 检测钻石
    if pay ~= nil then
        local goldCnt = pay["gold"] or 0
        if goldCnt > 0 then
            totalCnt = totalCnt + 1
            self:ShowRewardItem({["rewardType"] = RewardType.GOLD, ["itemId"] = "gold", ["count"] = goldCnt})
        end
    end
    -- 检测道具
    if reward ~= nil and table.count(reward["rewardInfo"]) > 0 then
        local tabReward = reward["rewardInfo"]
        for _, iteminfo in pairs(tabReward) do
            if (iteminfo["type"] == RewardType.GOODS) then
                local itemId = iteminfo["id"]
                local itemCnt = iteminfo["num"]
                local param = {["rewardType"] = RewardType.GOODS, ["itemId"] = itemId, ["count"] = itemCnt}
                totalCnt = totalCnt + 1
                self:ShowRewardItem(param)
            else
                local itemId = iteminfo["id"]
                local itemCnt = iteminfo["num"]
                local param = {["rewardType"] = iteminfo["type"], ["itemId"] = itemId, ["count"] = itemCnt}
                totalCnt = totalCnt + 1
                self:ShowRewardItem(param)
            end
        end
    end
    return totalCnt
end

--[[
    处理领奖按钮
]]
function MailSystem:ShowRewardBtn(maildata)
    self.isGoUpdate = false
    --是否有版本信息
    local reward = maildata:GetMailReward()
    if reward then
        local rewardVersion = reward["rewardVersion"]
        if rewardVersion then
            local curServerVersion = CS.GameEntry.Sdk.Version
            local strMailVersion = string.split(rewardVersion,".")
            local strLocalVersion = string.split(curServerVersion,".")
            for i = 1, #strMailVersion do
                if tonumber(strMailVersion[i]) > tonumber(strLocalVersion[i]) then
                    --版本低于最新版本，前往更新
                    self.isGoUpdate = true
                end
            end
            if not self.isGoUpdate then
                self._objGetReward:SetActive(maildata.rewardStatus == 0)
                self._btnGetReward:SetActive(maildata.rewardStatus == 0)
                self._txtGetReward:SetLocalText(GameDialogDefine.GET_REWARD)
                if DataCenter.BuildManager.MainLv >= reward.rewardLevel then
                    CS.UIGray.SetGray(self._btnGetReward.transform, false, true)
               else
                    CS.UIGray.SetGray(self._btnGetReward.transform, true, true)
                end
            else
                self._txtGetReward:SetLocalText(GameDialogDefine.GOTO)
                self._objGetReward:SetActive(true)
                self._btnGetReward:SetActive(true)
                CS.UIGray.SetGray(self._btnGetReward.transform, false, true)
            end
            CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.go.transform)
            self.view:RefreshToBottomBtn(self._btnGetReward)
            return
        end
    end
    
    self._btnGetReward:SetActive(maildata.rewardStatus == 0)
    self._txtGetReward:SetLocalText(GameDialogDefine.GET_REWARD)
    self._objGetReward:SetActive(maildata.rewardStatus == 0)
    self._btnGiveBack:SetActive(false)
    self.view:RefreshToBottomBtn(self._btnGetReward)
end

--奖励领取成功，开始飞动画
function MailSystem:RewardSuccess()
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Common_GetReward)
    local isGold = false
    local pay = self._mailData:GetMailPay()
    if pay ~= nil then
        if pay["gold"] > 0 then
            isGold = true
            UIUtil.DoFly(RewardType.GOLD,2,DataCenter.RewardManager:GetPicByType(RewardType.GOLD),self._objReward.transform:GetChild(0).gameObject.transform.position,Vector3.New(0,0,0),100,100)
        end
    end

    local reward = self._mailData:GetMailReward()
    local tempType = {}
    if reward and reward.rewardInfo then
        for i = 1, #reward.rewardInfo do
            if reward.rewardInfo[i].type ~= RewardType.MONEY and reward.rewardInfo[i].type ~= RewardType.GOLD then
                table.insert(tempType,RewardToResType[reward.rewardInfo[i].type])
            end
        end
    end
    if next(tempType) then
        EventManager:GetInstance():Broadcast(EventId.RefreshTopResByPickUp,tempType)
    end
    if reward ~= nil and table.count(reward["rewardInfo"]) > 0 then
        for i = 1, #reward.rewardInfo do
            local child = self._objReward.transform:GetChild(i - 1)
            local img = child.gameObject.transform:Find("clickBtn/ItemIcon")
            local pic = DataCenter.RewardManager:GetPicByType(reward.rewardInfo[i].type,reward.rewardInfo[i].id)
            local flyPos =Vector3.New(0,0,0)
            UIUtil.DoFly(reward.rewardInfo[i].type,2,pic,img.gameObject.transform.position,flyPos,100,100)
        end
    end
end

-- 相关用户信息
function MailSystem:ShowUser(maildata)
    local userInfo = maildata:GetMailUserInfo()
    if userInfo ~= nil then
        self:ShowUserItem(userInfo)
    end
end

function MailSystem:ShowUserItem(userInfo)
    local objName = "player_" .. userInfo["uid"]
    --复制基础prefab，每次循环创建一次
    local item = self.userPrefab:GameObjectSpawn(self._objUser.transform)
    item.name = objName
    local obj = self._objUser:AddComponent(MailUserItem, item.name)
    obj:RefreshData(userInfo)
end

function MailSystem:OnTranslateSucc(mailInfo)
    if mailInfo.uuid == self._mailData.uuid then
        local showTranslated = self.view.ctrl:GetShowTranslated()
        local mailContent = ""
        if showTranslated then
            mailContent = mailInfo:GetMailMessageTranslated()
        else
            mailContent = mailInfo:GetMailMessage()
        end
        local value = string.gsub(mailContent, "\\n", "\n")
        self._txtDesc:SetText(value)
    end
end

function MailSystem:IsShowingRewardBtn()
    
end

return MailSystem