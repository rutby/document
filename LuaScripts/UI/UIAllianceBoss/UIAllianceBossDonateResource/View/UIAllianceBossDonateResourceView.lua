local UIAllianceBossDonateResource = BaseClass("UIAllianceBossDonateResource", UIBaseView)
local base = UIBaseView
local UIAllianceBossDonateResourceCell = require "UI.UIAllianceBoss.UIAllianceBossDonateResource.Component.UIAllianceBossDonateResourceCell"

-- path define start
local title_text_path = "UICommonPopUpTitle/bg_mid/titleText"
local common_btn_close_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local scroll_view_path = "ImgBg/ScrollView"

local boss_icon_path = "ImgBg/BossNode/iconBg/imgIcon"
local can_attack_times_label_path = "ImgBg/BossNode/CanAttackTimesLabel"
local boss_progress_slider_path = "ImgBg/BossNode/BossProgressSlider"
local boss_progress_label_path = "ImgBg/BossNode/BossProgressSlider/BossProgressLabel"

local text_level_path = "ImgBg/BossNode/iconBg/textLevel"
local des1_path = "ImgBg/TItleNode/Des1"
local des2_path = "ImgBg/TItleNode/Des2"
local des3_path = "ImgBg/TItleNode/Des3"


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
    self.isCanSend = true
    self:ShowCells()
    self:RefreshProgressbar(false)
    self.update_action = function()
        self:OnUpdate()
    end
    self:RefreshCanAttackTime()
    UpdateManager:GetInstance():AddUpdate(self.update_action)
end

local function OnDisable(self)
    UpdateManager:GetInstance():RemoveUpdate(self.update_action)
    self.update_action = nil
    base.OnDisable(self)

end

local function ComponentDefine(self)

    self.boss_icon = self:AddComponent(UIImage, boss_icon_path)
    self.can_attack_times_label = self:AddComponent(UITextMeshProUGUIEx, can_attack_times_label_path)
    self.boss_progress_slider = self:AddComponent(UISlider, boss_progress_slider_path)
    self.boss_progress_label = self:AddComponent(UITextMeshProUGUIEx, boss_progress_label_path)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.title_text:SetLocalText(373009)
    self.text_level = self:AddComponent(UITextMeshProUGUIEx, text_level_path)

    self.des1 = self:AddComponent(UITextMeshProUGUIEx, des1_path)
    self.des1:SetLocalText(373009)
    self.des2 = self:AddComponent(UITextMeshProUGUIEx, des2_path)
    self.des2:SetLocalText(373010)
    self.des3 = self:AddComponent(UITextMeshProUGUIEx, des3_path)
    self.des3:SetLocalText(373011)
    

    self.common_btn_close = self:AddComponent(UIButton, common_btn_close_path)
    self.common_btn_close:SetOnClick(function() 
        self.ctrl:CloseSelf()
    end)

    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnResourceItemMoveIn(itemObj, index)
    end)

    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnResourceItemMoveOut(itemObj, index)
    end)

    self.dataList = {}
end


local function ComponentDestroy(self)

    self.boss_icon = nil
    self.can_attack_times_label = nil
    self.boss_progress_slider = nil
    self.boss_progress_label = nil
    self.title_text = nil
    self.common_btn_close = nil
    self.scroll_view = nil
    self.text_level = nil
    self.des1 = nil
    self.des2 = nil
    self.des3 = nil
    
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.AllianceBossDonate, self.OnDonateReturn)

end


local function OnRemoveListener(self)

    self:RemoveUIListener(EventId.AllianceBossDonate, self.OnDonateReturn)
    base.OnRemoveListener(self)
end

-- scrollview相关

local function OnResourceItemMoveIn(self, itemObj, index)
    itemObj.name = tostring(index)
    local cellComp = self.scroll_view:AddComponent(UIAllianceBossDonateResourceCell, itemObj)
    cellComp:SetData(self.dataList[index])
    self.itemCell[index] = cellComp
end

local function OnResourceItemMoveOut(self, itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIAllianceBossDonateResourceCell)
    self.itemCell[index] = nil
end

local function ClearScroll(self)
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UIAllianceBossDonateResourceCell)
end

local function ShowCells(self)
    self:ClearScroll()
    self.dataList = DataCenter.AllianceBossManager:GetDonateItemArr()

    if self.dataList == nil then
        return
    end
    self.itemCell = {}
    self.scroll_view:SetTotalCount(#self.dataList)
    if #self.dataList > 0 then
        self.scroll_view:RefillCells()
    end
end

-- scrollview相关 end

local function OnDonateReturn(self)
    self.dataList = DataCenter.AllianceBossManager:GetDonateItemArr()
   -- self:ShowCells()
    if self.itemCell then
        for i ,v in pairs(self.itemCell) do
            v:SetData(self.dataList[i])
        end
    end
    self:UpdateDonateState(true)
    self:RefreshProgressbar(true)
    self:RefreshCanAttackTime()
end

local function UpdateDonateState(self,state)
    self.isCanSend = state
end

local function GetDonateState(self)
    return self.isCanSend
end

local function RefreshCanAttackTime(self)
    local itemId = toInt(LuaEntry.DataConfig:TryGetStr("alliance_boss", "k1"))
    local curNum = DataCenter.ItemData:GetItemCount(itemId)
    self.can_attack_times_label:SetLocalText(373013, tostring(curNum))
end

local function RefreshProgressbar(self, useAnim)
    local bossInfo = DataCenter.AllianceBossManager:GetBossInfo()
    if bossInfo == nil then
        return
    end

    if useAnim then
        -- 播放进度条增长动画
        self.targetLv = bossInfo.lv
        self.targetExp = bossInfo.exp
    else
        -- 不播放进度条增长动画
        -- 直接把当前进度设置到目标进度
        self.curLv = bossInfo.lv
        self.targetLv = bossInfo.lv
        self.curExp = bossInfo.exp
        self.targetExp = bossInfo.exp

        local lvExpInfo = DataCenter.AllianceBossManager:GetBossLvAndExpInfo()
        if lvExpInfo == nil then
            return
        end

        local curLvMaxExp = lvExpInfo[self.curLv].exp
        self.boss_progress_label:SetText(tostring(self.targetExp) .. "/" .. tostring(curLvMaxExp))
        local progressBarPercent =  self.curExp / curLvMaxExp
        self.boss_progress_slider:SetValue(progressBarPercent)
        self.text_level:SetLocalText(300665, self.curLv) -- 等级. xxx
    end
end

local function OnUpdate(self)
    self:UpdateProgressbar()
end

local function UpdateProgressbar(self)
    if self.targetLv > self.curLv then
        -- 要到下一级 按固定速度增长
        local lvExpInfo = DataCenter.AllianceBossManager:GetBossLvAndExpInfo()
        if lvExpInfo == nil then
            return
        end

        local curLvMaxExp = lvExpInfo[self.curLv].exp
        local increasePerFrame = curLvMaxExp / 10 -- 

        --当前帧要移动到的经验值
        local curFrameExp = self.curExp + increasePerFrame
        if curFrameExp >= curLvMaxExp then
            -- 判断是否达到了最大等级
            local isMaxLv = lvExpInfo[self.curLv] == nil
            if isMaxLv then
                curFrameExp = curLvMaxExp
                self.curExp = curLvMaxExp
            else
                self.curLv = self.curLv + 1
                curLvMaxExp = lvExpInfo[self.curLv].exp
                curFrameExp = 0
                self.curExp = 0
            end
        else
            self.curExp = curFrameExp
        end

        local progressBarPercent = curFrameExp / curLvMaxExp
        self.boss_progress_slider:SetValue(progressBarPercent)
        self.boss_progress_label:SetText(tostring(math.floor(curFrameExp)) .. "/" .. tostring(math.floor(curLvMaxExp)))
        self.text_level:SetLocalText(300665, self.curLv) -- 等级. xxx
    else
        -- 已经在目标等级 判断目标经验是否更高
        if self.targetExp > self.curExp then
            -- 插值
            local lvExpInfo = DataCenter.AllianceBossManager:GetBossLvAndExpInfo()
            if lvExpInfo == nil then
                return
            end
            local delta = self.targetExp - self.curExp
            local lerpValue = delta / 10
            if lerpValue < 1 then
                lerpValue = 1
            end

            local curLvMaxExp = lvExpInfo[self.curLv].exp
            local curFrameExp = self.curExp + lerpValue
            if curFrameExp > self.targetExp then
                curFrameExp = self.targetExp
            end

            if curFrameExp > curLvMaxExp then
                curFrameExp = curLvMaxExp
            end

            local progressBarPercent = curFrameExp / curLvMaxExp
            self.boss_progress_slider:SetValue(progressBarPercent)
            self.curExp = curFrameExp
            self.boss_progress_label:SetText(tostring(math.floor(curFrameExp)) .. "/" .. tostring(math.floor(curLvMaxExp)))
        end
    end
end

UIAllianceBossDonateResource.OnCreate = OnCreate
UIAllianceBossDonateResource.OnDestroy = OnDestroy
UIAllianceBossDonateResource.OnEnable = OnEnable
UIAllianceBossDonateResource.OnDisable = OnDisable
UIAllianceBossDonateResource.ComponentDefine = ComponentDefine
UIAllianceBossDonateResource.ComponentDestroy = ComponentDestroy
UIAllianceBossDonateResource.OnResourceItemMoveIn = OnResourceItemMoveIn
UIAllianceBossDonateResource.OnResourceItemMoveOut = OnResourceItemMoveOut
UIAllianceBossDonateResource.ClearScroll = ClearScroll
UIAllianceBossDonateResource.ShowCells = ShowCells
UIAllianceBossDonateResource.OnAddListener = OnAddListener
UIAllianceBossDonateResource.OnRemoveListener = OnRemoveListener
UIAllianceBossDonateResource.OnDonateReturn = OnDonateReturn
UIAllianceBossDonateResource.UpdateDonateState = UpdateDonateState
UIAllianceBossDonateResource.GetDonateState = GetDonateState
UIAllianceBossDonateResource.RefreshCanAttackTime = RefreshCanAttackTime
UIAllianceBossDonateResource.RefreshProgressbar = RefreshProgressbar
UIAllianceBossDonateResource.OnUpdate = OnUpdate
UIAllianceBossDonateResource.UpdateProgressbar = UpdateProgressbar

return UIAllianceBossDonateResource