---
--- Created by shimin.
--- DateTime: 2022/4/28 21:55
---

local UITalentChooseCell = BaseClass("UITalentChooseCell", UIBaseContainer)
local base = UIBaseContainer

local submit_btn_path = "aim/Bg"
local buff_icon_path = "aim/BuffIcon"
local des_text_path = "aim/Text_num"
local selected_path = "aim/selected"
local BgNameList = {"UIBattleBuff_bg_green","UIBattleBuff_bg_blue","UIBattleBuff_bg_purple","UIBattleBuff_bg_orange","UIBattleBuff_bg_red"}
local rs1_path = "aim/rsContent/rs1"
local rs1_num_path = "aim/rsContent/rs1/rs1Txt"
local rs1_icon_path = "aim/rsContent/rs1/rs1Txt/rs1Image"
local Localization = CS.GameEntry.Localization
local rs2_path = "aim/rsContent/rs2"
local rs2_num_path = "aim/rsContent/rs2/rs2Txt"
local rs2_icon_path = "aim/rsContent/rs2/rs2Txt/rs2Image"
local recommondTalent_path = "aim/recommondTalent"
local animation_path = "aim"

local CellAnimation = {
    animation_left = "V _ui_UITalentChooseCell_zhong_chuxian",
    animation_middle = "V _ui_UITalentChooseCell_zhong_chuxian",
    animation_right = "V _ui_UITalentChooseCell_zhong_chuxian",
    animation_choose = "V_ui_UITalentChooseCell_xuanzhong",
    animation_cancel = "V_ui_UITalentChooseCell_quxiao",
    animation_normal = "V_ui_UITalentChooseCell_normal",
}

local PosVec = {
    Vector3.New(-319, 0, 0),
    Vector3.New(0, 0, 0),
    Vector3.New(319, 0, 0),
}

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.animator = self:AddComponent(UIAnimator, animation_path)
    self.submit_btn = self:AddComponent(UIButton, submit_btn_path)
    self.buff_icon = self:AddComponent(UIImage, buff_icon_path)
    self.bg_icon = self:AddComponent(UIImage, submit_btn_path)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.selected = self:AddComponent(UIBaseContainer, selected_path)
    self.selected:SetActive(false)
    self.submit_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBtnClick()
    end)

    self.rs1 = self:AddComponent(UIBaseContainer, rs1_path)
    self.rs1_num = self:AddComponent(UITextMeshProUGUIEx, rs1_num_path)
    self.rs1_icon = self:AddComponent(UIImage, rs1_icon_path)

    self.rs2 = self:AddComponent(UIBaseContainer, rs2_path)
    self.rs2_num = self:AddComponent(UITextMeshProUGUIEx, rs2_num_path)
    self.rs2_icon = self:AddComponent(UIImage, rs2_icon_path)
    
    self.recommondTalent = self:AddComponent(UIBaseContainer, recommondTalent_path)
    self.needShowInitAnimation = true
end

local function ComponentDestroy(self)
    self:StopAnim()
    self.submit_btn = nil
    self.buff_icon = nil
    self.bg_icon = nil
    self.des_text = nil
    if self.initDelayTime then
        self.initDelayTime:Stop()
        self.initDelayTime = nil
    end
end

local function DataDefine(self)
    self.param = nil
    self.trigger = nil
end

local function DataDestroy(self)
    self.param = nil
    self.trigger = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end
local function ReInit(self,param)
    self.param = param
    local template = DataCenter.TalentTemplateManager:GetTemplate(self.param.triggerId)
    self.transform:Set_localPosition(PosVec[self.param.index].x, PosVec[self.param.index].y, PosVec[self.param.index].z)
    if template ~= nil then
        local nameStr = Localization:GetString("300665", template.lv).." "..template.name
        self.des_text:SetText(nameStr)
        local color = template.color + 1
        if color > table.count(BgNameList) then
            color = table.count(BgNameList)
        end
        local bgName = BgNameList[color]
        self.bg_icon:LoadSprite(string.format(LoadPath.UIPveBattleBuff, bgName))
        self.buff_icon:LoadSprite(template.icon)
        local rsNeed = template.resourceNeed
        local index = 1
        self.rs1:SetActive(false)
        self.rs2:SetActive(false)
        self.recommondTalent:SetActive(self.param.triggerId == self.param.recommondTalentId)
        for k, v in pairs(rsNeed) do
            local cell = self["rs"..index]
            local txt = self["rs"..index.."_num"]
            local icon = self["rs"..index.."_icon"]

            if cell ~= nil then
                cell:SetActive(true)
                txt:SetText(string.GetFormattedSeperatorNum(v))
                local temp = DataCenter.ResourceTemplateManager:GetResourceTemplate(k)
                if temp ~= nil then
                    local iconStr = string.format(LoadPath.CommonPath, temp.icon)
                    icon:LoadSprite(iconStr)
                end
            end
            index = index + 1
        end
    end
    if self.needShowInitAnimation then
        self:ShowInitAnimation()
    else
        if param.showAnimation == true then
            self:ShowAppearAnimation()
        end
    end
end

local function OnBtnClick(self)
    self.view:SetCurrentSelect(self.param.index, false)
end

local function SetSelectEffectShow(self, currentSelectIndex, firstShow)
    local isPreSelect = self.selected:GetActive()
    self.selected:SetActive(self.param.index == currentSelectIndex)
    local isNowSelect = self.selected:GetActive()
    if firstShow then
        --if currentSelectIndex ~= 2 then
            if isNowSelect then
                self.animator:Play(CellAnimation.animation_choose, 0, 0)
            else
                self.animator:Play(CellAnimation.animation_normal, 0, 0)
            end
    else
        if isPreSelect and not isNowSelect then
            self.animator:Play(CellAnimation.animation_cancel, 0, 0)
        end
        if not isPreSelect and isNowSelect then
            self.animator:Play(CellAnimation.animation_choose, 0, 0)
        end
    end
end

local function ShowAppearAnimation(self)
    if self.sequence ~= nil then
        self.sequence:Pause()
        self.sequence:Kill()
        self.sequence = nil
    end

    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Append(self.transform:DOScale(Vector3.New(0.1, 1, 1), 0.2))
    sequence:Append(self.transform:DOScale(Vector3.New(1, 1, 1), 0.2))

    sequence:AppendCallback(function()
        self:StopAnim()
    end)

    self.sequence = sequence
end

local function ShowInitAnimation(self)
    self.needShowInitAnimation = false
    local delayTime = 0
    local aniName = CellAnimation.animation_middle
    if string.IsNullOrEmpty(self.param.recommondTalentId) or toInt(self.param.recommondTalentId) < 0 then
        if self.param.index ~= 1 then
            delayTime = 0.18
        end
    else
        if self.param.recommondTalentId ~= self.param.triggerId then
            delayTime = 0.18
        end
    end
    if self.initDelayTime then
        self.initDelayTime:Stop()
        self.initDelayTime = nil
    end
    self.transform.gameObject:SetActive(false)
    self.initDelayTime = TimerManager:GetInstance():DelayInvoke(function()
        self.transform.gameObject:SetActive(true)
        self.animator:Play(aniName, 0, 0)
        if self.initDelayTime then
            self.initDelayTime:Stop()
            self.initDelayTime = nil
        end

    end, delayTime)
end

local function StopAnim(self)
    if self.sequence ~= nil then
        self.sequence:Pause()
        self.sequence:Kill()
        self.sequence = nil
    end
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
end

local function ResetAimPos(self)
    self.animator.transform:Set_localPosition(0, 0, 0)
end

UITalentChooseCell.OnCreate = OnCreate
UITalentChooseCell.OnDestroy = OnDestroy
UITalentChooseCell.ComponentDefine = ComponentDefine
UITalentChooseCell.ComponentDestroy = ComponentDestroy
UITalentChooseCell.DataDefine = DataDefine
UITalentChooseCell.DataDestroy = DataDestroy
UITalentChooseCell.OnEnable = OnEnable
UITalentChooseCell.OnDisable = OnDisable
UITalentChooseCell.OnAddListener = OnAddListener
UITalentChooseCell.OnRemoveListener = OnRemoveListener
UITalentChooseCell.ReInit = ReInit
UITalentChooseCell.OnBtnClick = OnBtnClick
UITalentChooseCell.SetSelectEffectShow = SetSelectEffectShow
UITalentChooseCell.ShowAppearAnimation = ShowAppearAnimation
UITalentChooseCell.StopAnim = StopAnim
UITalentChooseCell.ShowInitAnimation = ShowInitAnimation
UITalentChooseCell.ResetAimPos = ResetAimPos

return UITalentChooseCell