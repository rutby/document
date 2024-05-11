--- Created by shimin.
--- DateTime: 2024/03/27 20:20
--- 章节任务章节图
local UITaskChapterAdv = BaseClass("UITaskChapterAdv", UIBaseContainer)
local base = UIBaseContainer
local QuestAnimScene = require "Scene.QuestAnimScene.QuestAnimScene"
local Localization = CS.GameEntry.Localization

local this_path = ""
local chapter_bg_img_path = "chapter_bg_img"
local chapter_title_text_path = "chapter_title_img/chapter_title_text"
local chapter_name_text_path = "chapter_name_img/chapter_name_text"
local chapter_des_text_path = "chapter_des_text"
local survivor_name_text_path = "num_go/survivor_name_text"
local survivor_value_text_path = "num_go/survivor_name_text/survivor_value_text"
local deceased_name_text_path = "num_go/deceased_name_text"
local deceased_value_text_path = "num_go/deceased_name_text/deceased_value_text"
local facility_name_text_path = "num_go/facility_name_text"
local facility_value_text_path = "num_go/facility_name_text/facility_value_text"
local chapter_bg_img_large_path = "chapter_bg_img/chapter_bg_img_renwu"

local DeadCountList = {0,1,3}--章节死亡数量

function UITaskChapterAdv:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UITaskChapterAdv:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UITaskChapterAdv:ComponentDefine()
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        self:OnBtnClick()
    end)
    self.chapter_bg_img = self:AddComponent(UIImage, chapter_bg_img_path)
    self.chapter_title_text = self:AddComponent(UIText, chapter_title_text_path)
    self.chapter_name_text = self:AddComponent(UIText, chapter_name_text_path)
    self.chapter_des_text = self:AddComponent(UIText, chapter_des_text_path)
    self.survivor_name_text = self:AddComponent(UIText, survivor_name_text_path)
    self.survivor_value_text = self:AddComponent(UIText, survivor_value_text_path)
    self.deceased_name_text = self:AddComponent(UIText, deceased_name_text_path)
    self.deceased_value_text = self:AddComponent(UIText, deceased_value_text_path)
    self.facility_name_text = self:AddComponent(UIText, facility_name_text_path)
    self.facility_value_text = self:AddComponent(UIText, facility_value_text_path)
    self.chapter_bg_img_large = self:AddComponent(UIImage, chapter_bg_img_large_path)
end

function UITaskChapterAdv:ComponentDestroy()
end

function UITaskChapterAdv:DataDefine()
    self.param = {}
    self.print_finish_callback = function() 
        self:PrintFinishCallback()
    end
    self.scene = nil
    self.canClick = false
    self.effectId = nil

    if self.tweenSequence ~= nil then
        self.tweenSequence:Pause()
        self.tweenSequence:Kill()
        self.tweenSequence = nil
        DOTween.timeScale = 1
    end
end

function UITaskChapterAdv:DataDestroy()
    self:StopSound()
    self.param = {}
    self:DestroyScene()

    if self.tweenSequence ~= nil then
        self.tweenSequence:Pause()
        self.tweenSequence:Kill()
        self.tweenSequence = nil
        DOTween.timeScale = 1
    end
end

function UITaskChapterAdv:OnEnable()
    base.OnEnable(self)
end

function UITaskChapterAdv:OnDisable()
    base.OnDisable(self)
end

function UITaskChapterAdv:OnAddListener()
    base.OnAddListener(self)
end

function UITaskChapterAdv:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UITaskChapterAdv:ReInit(param)
    self.param = param
    self:Refresh()
end

function UITaskChapterAdv:Refresh()
    self.chapter_des_text:SetText("")
    self.survivor_name_text:SetText("")
    self.survivor_value_text:SetText("")
    self.deceased_name_text:SetText("")
    self.deceased_value_text:SetText("")
    self.facility_name_text:SetText("")
    self.facility_value_text:SetText("")
    
    local chapter_bg = GetTableData(DataCenter.ChapterTemplateManager:GetTableName(),  self.param.chapterId, "chapter_bg", "")
    if chapter_bg ~= nil and chapter_bg ~= "" then
        self.chapter_bg_img:LoadSprite(string.format(LoadPath.UIChapterBgTexture, self.param.chapterId, chapter_bg))
        self.chapter_bg_img_large:LoadSprite(string.format(LoadPath.UIChapterBgTexture, self.param.chapterId, "0" .. chapter_bg))
    end
    self.chapter_title_text:SetLocalText(GameDialogDefine.CHAPTER_TITLE, self.param.chapterId)
    self.chapter_name_text:SetLocalText(GetTableData(DataCenter.ChapterTemplateManager:GetTableName(),  self.param.chapterId, "name", ""))
end

function UITaskChapterAdv:OnBtnClick()
    if self.canClick then
        if not self.isSpeed then
            DOTween.timeScale = 5
        else
            self.view:PlayAnimChapterImg()
        end
    end
end

function UITaskChapterAdv:PlayPrint()
    self.canClick = true
    self.isSpeed = false
    self:DoPlayPrint()
    self.effectId = SoundUtil.PlayLoopEffect(SoundAssets.Music_Effect_Chapter_Print)
    local description = GetTableData(DataCenter.ChapterTemplateManager:GetTableName(),  self.param.chapterId, "description", "")
    SoundUtil.PlayDub(tostring(description))
end

function UITaskChapterAdv:DoPlayPrint()
    
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    local str1 = Localization:GetString(GetTableData(DataCenter.ChapterTemplateManager:GetTableName(),  self.param.chapterId, "description", ""))
    print(str1)

    sequence:Append(self.chapter_des_text:GetUnityText():DOText(str1,5))
    local str2 = Localization:GetString(GameDialogDefine.WORK_NAME)
    sequence:Append(self.survivor_name_text:GetUnityText():DOText(str2,0.5))
    --sequence:Append(self.survivor_value_text:GetUnityText():DOText(tostring(DataCenter.VitaManager:GetResidentMaxCount()),0.1))
    sequence:Append(self.survivor_value_text:GetUnityText():DOText(tostring(DataCenter.VitaManager:GetResidentCount()),0.1))

    local deadCount = DeadCountList[self.param.chapterId]
    if deadCount == nil then
        self.deceased_name_text:SetActive(false)
    else
        self.deceased_name_text:SetActive(true)
        local str3 = Localization:GetString(GameDialogDefine.DEAD_PEOPLE_NUM)
        sequence:Append(self.deceased_name_text:GetUnityText():DOText(str3,0.5))
        sequence:Append(self.deceased_value_text:GetUnityText():DOText(tostring(deadCount),0.1))
    end
    local str4 = Localization:GetString(GameDialogDefine.TASK_ADV_BUILD)
    sequence:Append(self.facility_name_text:GetUnityText():DOText(str4,0.5))
    sequence:Append(self.facility_value_text:GetUnityText():DOText(tostring(DataCenter.BuildManager:GetOwnBuildNum()),0.1))
    sequence:AppendCallback(function()
        self.isSpeed = true
        DOTween.timeScale = 1

        self:LoadScene()
        self:StopSound()
    end)
    sequence:SetLoops(0)
    self.tweenSequence = sequence
end

function UITaskChapterAdv:LoadScene()
    if self.scene == nil then
        self.scene = QuestAnimScene.New()
    end
    self.scene:ReInit()
end

function UITaskChapterAdv:DestroyScene()
    if self.scene ~= nil then
        self.scene:Destroy()
        self.scene = nil
    end
end

function UITaskChapterAdv:DoFlipAnim(loadCallback, flipCallback, frontGo, afterGo)
    self.scene:DoFlipAnim(loadCallback, flipCallback, frontGo, afterGo)
end

function UITaskChapterAdv:StopSound()
    if self.effectId ~= nil then
        SoundUtil.StopSound(self.effectId)
        self.effectId = nil
    end
end

return UITaskChapterAdv