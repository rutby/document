---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/10/28 15:46
---
local RewardItem = require "UI.UIActivityRewardTip.Component.RewardItem"
local UIActivityRewardTipView = BaseClass("UIActivityRewardTipView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Screen = CS.UnityEngine.Screen
local RewardSciencePanel = require "UI.UIActivityRewardTip.Component.ActivityRewardSciencePanel"


local tip_path = "Tips"
local anim_path = "Tips/Anim"
local tips_txt_path = "Tips/Anim/TipsTitle"
local tips_task_txt_path = "Tips/Anim/TipsTitleTask"

local scroll_path = "Tips/Anim/ScrollView"
local content_path = "Tips/Anim/ScrollView/Viewport/Content"
local return_btn_path = "Panel"
local cost_path = "Tips/Anim/TipsTitle/cost"
local rewardScience_path = "Tips/Anim/rewardScience"
local diamondDouble_path = "Tips/Anim/TipsTitle/cost/diamondDouble"
local rewardDouble_path = "Tips/Anim/DoubleBg"
local arrow_up_path = "Tips/Anim/Img_up"
local arrow_down_path = "Tips/Anim/Img_down"

local TipsWidth = 470

local function OnCreate(self)
    base.OnCreate(self)
    local des,activityType,posX,posY,isUp,accumulate,offset,activityId,rewardScience = self:GetUserData()
    self.des = des
    self.posX = posX
    self.posY = posY
    self.activityType = activityType
    self.isUp = isUp or false
    self.index = accumulate    --索引
    self.offset = offset or 0 --偏移量
    self.activityId = activityId or 0


    self.lossyScaleX = self.transform.lossyScale.x
    if self.lossyScaleX <= 0 then
        self.lossyScaleX = 1
    end
    self.lossyScaleY = self.transform.lossyScale.y
    if self.lossyScaleY <= 0 then
        self.lossyScaleY = 1
    end
    self.screenSize = Vector2.New(Screen.width ,Screen.height)
    self.tipMinX = TipsWidth / 2 * self.lossyScaleX
    self.tipMaxX = self.screenSize.x - TipsWidth / 2 * self.lossyScaleX
    
    self.tip_obj = self:AddComponent(UIBaseContainer,tip_path)
    self.anim = self:AddComponent(UIAnimator,anim_path)
    self.tips_txt = self:AddComponent(UITextMeshProUGUIEx,tips_txt_path)
    self.tips_task_txt = self:AddComponent(UITextMeshProUGUIEx,tips_task_txt_path)
    self.rewardScienceInfo = rewardScience
    
    self.scroll_path = self:AddComponent(UIBaseContainer,scroll_path)
    self.content = self:AddComponent(UIBaseContainer,content_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.cost = self:AddComponent(UIImage,cost_path)
    self.rewardScienceN = self:AddComponent(RewardSciencePanel, rewardScience_path)
    self.diamondDoubleN = self:AddComponent(UITextMeshProUGUIEx, diamondDouble_path)
    self.diamondDoubleN:SetActive(false)
    self.rewardDoubleN = self:AddComponent(UIBaseContainer, rewardDouble_path)
    self.arrowUp = self:AddComponent(UIBaseContainer, arrow_up_path)
    self.arrowDown = self:AddComponent(UIBaseContainer, arrow_down_path)
    -- self.get_btn = self:AddComponent(UIButton, get_btn_path)
    -- self.get_btn:SetOnClick(function()  
--SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
    --     self:OnGetClick()
    -- end)
    --self.animator = self:AddComponent(UIAnimator, animator_path)
end

local function OnDestroy(self)
    self:SetAllCellDestroy()
    self.tip_obj =nil
    self.anim =nil
    self.content = nil
    self.animator = nil
    self.return_btn =nil
    --self.get_btn =nil
    --self.get_btn_txt =nil
    self.tips_txt =nil
    self.tips_task_txt =nil
    self.des = nil
    self.isShowBtn = nil
    self.posX = nil
    self.posY = nil
    self.activityType =nil
    self.cost = nil
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self:RefreshData()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function RefreshData(self)
    self.tip_obj:SetActive(false)
    -- 横向超框
    local posX = self.posX
    if posX < self.tipMinX then
        posX = self.tipMinX
    elseif posX > self.tipMaxX then
        posX = self.tipMaxX
    end
    self.tip_obj.transform.position = Vector3.New(posX, self.posY, 0)
    -- 纵向超框
    local anchoredPos = self.tip_obj.rectTransform.anchoredPosition
    local height = self.tip_obj.rectTransform.rect.height
    local showUpArrow = false
    if not self.isUp then
        if anchoredPos.y - self.offset - height < -Screen.height / 2 then
            anchoredPos.y = anchoredPos.y + self.offset + height
            showUpArrow = false
        else
            anchoredPos.y = anchoredPos.y - self.offset
            showUpArrow = true
        end
    else
        if anchoredPos.y + self.offset + height > Screen.height / 2 then
            anchoredPos.y = anchoredPos.y - self.offset
            showUpArrow = true
        else
            anchoredPos.y = anchoredPos.y + self.offset + height
            showUpArrow = false
        end
    end
    self.tip_obj.transform.anchoredPosition = anchoredPos
    self.tip_obj:SetActive(true)
    self.arrowUp:SetActive(showUpArrow)
    self.arrowDown:SetActive(not showUpArrow)
    if showUpArrow then
        self.arrowUp.transform.position = Vector3.New(self.posX, self.arrowUp.transform.position.y, 0)
    else
        self.arrowDown.transform.position = Vector3.New(self.posX, self.arrowDown.transform.position.y, 0)
    end

    self.anim:Play("CommonPopup_movein", 0, 0)
    self.rewardDoubleN:SetActive(false)
    self.diamondDoubleN:SetActive(false)
    local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.activityId))
    
    --self.scroll_path:SetSizeDelta({x = 418,y = 452})
    --self.tips_task_txt:SetSizeDelta({x = 420,y = 68})
    if self.activityType == nil then
        self.tips_task_txt:SetText(self.des)
        self.tips_txt:SetActive(false)
        self.tips_task_txt:SetActive(true)
    elseif self.activityType == -1 then
        self.tips_task_txt:SetText(self.des)
        self.tips_txt:SetActive(false)
        self.tips_task_txt:SetActive(true)
    elseif self.activityType == -2 then
        self.tips_task_txt:SetText(self.des)
        self.tips_txt:SetActive(false)
        self.tips_task_txt:SetActive(true)
    elseif self.activityType == -3 then
        self.tips_task_txt:SetText(self.des)
        self.tips_txt:SetActive(false)
        self.tips_task_txt:SetActive(true)
    elseif self.activityType == -4 then
        self.tips_task_txt:SetText(self.des)
        self.tips_txt:SetActive(false)
        self.tips_task_txt:SetActive(true)
    elseif self.activityType == ActivityEnum.ActivityType.TurntableActivity then
        self.tips_txt:SetActive(false)
        self.tips_task_txt:SetActive(true)
        self.tips_task_txt:SetText(self.des)
        self.cost:SetActive(false)
    elseif self.activityType == ActivityEnum.ActivityType.BattlePass then
        self.tips_txt:SetActive(false)
        self.tips_task_txt:SetActive(true)
        self.tips_task_txt:SetText(self.des)
        self.cost:SetActive(false)
        --self.scroll_path:SetSizeDelta({x = 418,y = 452})
        --self.tips_task_txt:SetSizeDelta({x = 420,y = 68})
    elseif self.activityType == EnumActivity.SeasonPass.Type then
        self.tips_txt:SetActive(false)
        self.tips_task_txt:SetActive(true)
        self.tips_task_txt:SetText(self.des)
        self.cost:SetActive(false)
        --self.scroll_path:SetSizeDelta({x = 418,y = 452})
        --self.tips_task_txt:SetSizeDelta({x = 420,y = 68})
    elseif self.activityType == EnumActivity.HeroGrowth.Type then
        if activityInfo.sub_type == 2 then
            self.tips_task_txt:SetActive(false)
        else
            self.tips_task_txt:SetActive(true)
            self.tips_task_txt:SetText(self.des)
            --self.tips_task_txt:SetSizeDelta({x = 420,y = 68})
        end
        self.tips_txt:SetActive(false)
        self.cost:SetActive(false)
        --self.scroll_path:SetSizeDelta({x = 418,y = 452})
    elseif self.activityType == EnumActivity.AllianceCompete.EventType then
        local effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.EFFECT_ONE_MORE_TIMES)
        self.rewardDoubleN:SetActive(effectNum and effectNum > 0)
        --self.diamondDoubleN:SetActive(effectNum and effectNum > 0)
        self.tips_txt:SetActive(true)
        self.tips_txt:SetText(self.des)
        self.cost:SetActive(true)
        self.tips_task_txt:SetActive(false)
    elseif self.activityType == ActivityEnum.ActivityType.CountryRating then
        self.tips_txt:SetActive(false)
        self.tips_task_txt:SetActive(true)
    else
        self.tips_txt:SetText(self.des)
        self.cost:SetActive(true)
        self.tips_task_txt:SetActive(false)
        self.tips_txt:SetActive(true)
    end
    
    self:SetAllCellDestroy()
    self.modelwelfare = {}
    local newList = self.ctrl:GetRewardListByType(self.activityType,self.index,self.activityId)
    if newList ~= nil then
        for i = 1, table.length(newList) do
            --复制基础prefab，每次循环创建一次
            self.modelwelfare[newList[i]] = self:GameObjectInstantiateAsync(UIAssets.ActivityRewardTipCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.name ="item" .. i
                local cell = self.content:AddComponent(RewardItem,go.name)
                cell:RefreshData(newList[i])
            end)
        end
    end
    
    self:RefreshRewardScience()
end

local function SetAllCellDestroy(self)
    self.content:RemoveComponents(RewardItem)
    if self.modelwelfare~=nil then
        for k,v in pairs(self.modelwelfare) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
end

local function RefreshRewardScience(self)
    if not self.rewardScienceInfo then
        self.rewardScienceN:SetActive(false)
    else
        self.rewardScienceN:SetActive(true)
        self.rewardScienceN:ShowPanel(self.rewardScienceInfo)
    end
end

local function OnGetClick(self)
    self.ctrl:GetRewardByType(self.activityType)
end

UIActivityRewardTipView.OnCreate= OnCreate
UIActivityRewardTipView.OnDestroy = OnDestroy
UIActivityRewardTipView.RefreshData = RefreshData
UIActivityRewardTipView.OnEnable= OnEnable
UIActivityRewardTipView.OnDisable = OnDisable
UIActivityRewardTipView.OnGetClick = OnGetClick
UIActivityRewardTipView.RefreshRewardScience = RefreshRewardScience
UIActivityRewardTipView.SetAllCellDestroy = SetAllCellDestroy
return UIActivityRewardTipView