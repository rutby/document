---
--- 引导对话页面
--- Created by shimin.
--- DateTime: 2021/8/18 22:17
---
local UIGuideTalkView = BaseClass("UIGuideTalkView", UIBaseView)
local base = UIBaseView

local panel_path = "panel"
local talk_anim_path = ""
local des_text_path = "Anim/talk_bg/des_text"
local name_text_path = "Anim/talk_bg/name_text"
local icon_img_path = "Anim/icon"
local bg_img_path = "Anim/bg"
local black_bg_path = "black_bg"
local spine_go_path = "Anim/spine_go"

local AnimName =
{
    MoveLeft = "UIGuideTalkShowLeft",
    NoMoveLeft = "UIGuideTalkShowNoMoveLeft",
    MoveRight = "UIGuideTalkShowRight",
    NoMoveRight = "UIGuideTalkShowNoMoveRight",
}

local CloseAnimFunction =
{
    Close = 1,
    Click = 2,
}

local DefaultSpineName = "duihua_hero04"
local FlipScale = Vector3.New(-1, 1, 1)

--创建
function UIGuideTalkView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIGuideTalkView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIGuideTalkView:ComponentDefine()
    self.panel = self:AddComponent(UIButton, panel_path)
    self.icon_img = self:AddComponent(UIImage, icon_img_path)
    self.talk_anim = self:AddComponent(UIAnimator, talk_anim_path)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
    self.panel:SetOnClick(function()
        self:OnBtnClick()
    end)
    self.bg_img = self:AddComponent(UIImage, bg_img_path)
    self.black_bg = self:AddComponent(UIImage, black_bg_path)
    self.spine_go = self.transform:Find(spine_go_path):GetComponent(typeof(CS.Spine.Unity.SkeletonGraphic))
end

function UIGuideTalkView:ComponentDestroy()
end

function UIGuideTalkView:DataDefine()
    self.param = {}
    self.auto_to_do_next_timer_action = function()
        self:AutoDoNextTimerAction()
    end
    self.closeFun = CloseAnimFunction.Close
    self.autoDoNextTimer = nil
    self.modelName = nil
    self.emojiParam = nil
    self.uuid = ""
end

function UIGuideTalkView:DataDestroy()
    self:DeleteAutoDoNextTimer()
    self:DeleteResidentEmoji()
end

function UIGuideTalkView:OnEnable()
    base.OnEnable(self)
end

function UIGuideTalkView:OnDisable()
    base.OnDisable(self)
end

function UIGuideTalkView:ReInit()
    self.param = self:GetUserData()
    self:Refresh()
end

function UIGuideTalkView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
    self:AddUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
end

function UIGuideTalkView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
    self:RemoveUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
end

function UIGuideTalkView:Refresh()
    if self.param ~= nil then
        self.gameObject:SetActive(true)
        self:AddAutoDoNextTimer(self.param.time)
        self.name_text:SetText(self.param.name or "")
        self.des_text:SetText(self.param.dialog)
        self.des_text:PlayPrint()
        
        self.spine_go.gameObject:SetActive(false)
        if self.param.spineName ~= nil and self.param.spineName ~= "" then
            self.icon_img:SetActive(false)
            if self.spineName ~= self.param.spineName then
                self.spineName = self.param.spineName
                CommonUtil.LoadAsset(string.format(LoadPath.HeroSpine, self.spineName, self.spineName), DefaultSpineName, typeof(CS.Spine.Unity.SkeletonDataAsset), function(asset)
                    if asset then
                        self.spine_go.gameObject:SetActive(true)
                        self.spine_go.skeletonDataAsset = asset
                        self.spine_go:Initialize(true)
                        self.spineAnimName = nil
                        self:RefreshSpineAnim()
                    end
                end)
            else
                self.spine_go.gameObject:SetActive(true)
                self:RefreshSpineAnim()
            end
        else
            self.spine_go.gameObject:SetActive(false)
            self.icon_img:SetActive(true)
            self.icon_img:LoadSprite(string.format(LoadPath.UIGuideTalk, self.param.modelName), nil, function()
                self.icon_img:SetNativeSize()
            end)
            self.modelName = self.param.modelName
        end
        
        if self.param.bg ~= nil then
            self.bg_img:SetActive(true)
            self.bg_img:LoadSprite(self.param.bg, nil, function()
                self.bg_img:SetNativeSize()
            end)
        else
            self.bg_img:SetActive(false)
        end

        if self.param.bgAlpha ~= nil and self.param.bgAlpha > 0 then
            self.black_bg:SetActive(true)
            self.black_bg:SetAlpha(self.param.bgAlpha)
        else
            self.black_bg:SetActive(false)
        end
      
        if self.param.modelPosition == self.modelPosition and ((self.param.modelName ~= nil and 
                self.param.modelName ~= "" and self.modelName == self.param.modelName) or (self.param.spineName ~= nil and
                self.param.spineName ~= "" and self.spineName == self.param.spineName)) then
            if self.param.modelPosition == GuideNpcPosition.Left then
                self.talk_anim:Play(AnimName.NoMoveLeft, 0, 0)
            else
                self.talk_anim:Play(AnimName.NoMoveRight, 0, 0)
            end
        else
            self.modelPosition = self.param.modelPosition
            if self.param.modelPosition == GuideNpcPosition.Left then
                self.talk_anim:Play(AnimName.MoveLeft, 0, 0)
            else
                self.talk_anim:Play(AnimName.MoveRight, 0, 0)
            end
        end
        --场景小人显示省略号
        self:CheckShowResidentEmoji()
    end
end

function UIGuideTalkView:RefreshGuideSignal()
    self:DeleteResidentEmoji()
    self:DeleteAutoDoNextTimer()
    local guideType = DataCenter.GuideManager:GetGuideType()
    if guideType == GuideType.ShowTalk then
        self.gameObject:SetActive(false)
    else
        self.closeFun = CloseAnimFunction.Close
        self:DoCloseAnim()
    end
end

function UIGuideTalkView:OnBtnClick()
    if not self.des_text:AddSpeedPrint() then
        self:DeleteAutoDoNextTimer()
        self.closeFun = CloseAnimFunction.Click
        local nextType = DataCenter.GuideManager:GetNextGuideTemplateParam("type")
        if nextType == GuideType.ShowTalk then
            local para2 = DataCenter.GuideManager:GetNextGuideTemplateParam("para2")
            if para2 ~= nil and para2 ~= "" then
                local spl = string.split(para2,",")
                if #spl > 3 then
                    local modelposition = tonumber(spl[4])
                    local modelName = spl[2]
                    local spineName = spl[5]
                    if self.modelPosition == modelposition and ((self.modelName ~= nil and self.modelName ~= "" and self.modelName == modelName)
                            or (self.spineName ~= nil and self.spineName ~= "" and self.spineName == spineName)) then
                        self:TimerAction()
                    else
                        self:DoCloseAnim()
                    end
                end
            end
        else
            self:TimerAction()
        end
    end
end

function UIGuideTalkView:TimerAction()
    if self.closeFun == CloseAnimFunction.Close then
        self.ctrl:CloseSelf()
    elseif self.closeFun == CloseAnimFunction.Click then
        DataCenter.GuideManager:HasClick(panel_path)
    end
end

function UIGuideTalkView:RefreshGuideAnimSignal(param)
    self.param = param
    self:Refresh()
end

function UIGuideTalkView:AddAutoDoNextTimer(time)
    self:DeleteAutoDoNextTimer()
    if time ~= nil and time > 0 then
        self.autoDoNextTimer = TimerManager:GetInstance():GetTimer(time, self.auto_to_do_next_timer_action , self, true,false,false)
        self.autoDoNextTimer:Start()
    end
end

function UIGuideTalkView:AutoDoNextTimerAction()
    self:DeleteAutoDoNextTimer()
    self:OnBtnClick()
end

function UIGuideTalkView:DeleteAutoDoNextTimer()
    if self.autoDoNextTimer then
        self.autoDoNextTimer:Stop()
        self.autoDoNextTimer = nil
    end
end

function UIGuideTalkView:DoCloseAnim()
    self:TimerAction()
end

function UIGuideTalkView:CheckShowResidentEmoji()
    if SceneUtils.GetIsInCity() and self.param.emojiParam ~= nil then
        if self.emojiParam == nil or self.param.emojiParam ~= self.emojiParam then
            self:DeleteResidentEmoji()
            self:ShowResidentEmoji()
        end
    else
        self:DeleteResidentEmoji()
    end
end

function UIGuideTalkView:DeleteResidentEmoji()
    if self.emojiParam ~= nil then
        DataCenter.CityHudManager:Destroy(self.uuid)
        self.uuid = ""
        self.emojiParam = nil
    end
end

function UIGuideTalkView:ShowResidentEmoji()
    if self.param.emojiParam ~= nil then
        local obj, uuid = DataCenter.GuideManager:GetGuideObjAndUuid(self.param.emojiParam)
        if obj ~= nil and obj.transform ~= nil then
            self.uuid = uuid
            self.emojiParam = self.param.emojiParam
            local hudParam = {}
            hudParam.uuid = uuid
            hudParam.GetPos = function()
                if obj ~= nil and obj.transform ~= nil then
                    return obj.transform.position
                else
                    DataCenter.CityHudManager:Destroy(uuid, CityHudType.AnimEmoji)
                    return Vector3.New(0, 0, 0)
                end
            end
            hudParam.type = CityHudType.AnimEmoji
            hudParam.emojiType = GuideResidentEmojiType.Anim
            hudParam.emojiPara = {"UIAnimEmojiSpeechless"}
            hudParam.worldOffset = Vector3.New(0, ResidentModelEmojiHeight, 0)
            hudParam.duration = 0
            hudParam.updateEveryFrame = true
            hudParam.layer = CityHudLayer.Speak
            hudParam.location = CityHudLocation.UI
            DataCenter.CityHudManager:Create(hudParam)
        end
    end
end

function UIGuideTalkView:RefreshSpineAnim()
    local spineAnimName = (self.param.spineAnimName or "Idle")
    if self.spineAnimName ~= spineAnimName then
        self.spineAnimName = spineAnimName
        self.spine_go.AnimationState:SetAnimation(0, self.spineAnimName, true)
    end
    self.spine_go.transform.localScale = Vector3.New(self.param.spineScale * (self.param.spineFlipX == 1 and -1 or 1), self.param.spineScale, self.param.spineScale)
end



return UIGuideTalkView