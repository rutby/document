---
--- 
--- Created by zzl.
--- DateTime:
---
--local MailListItem = require "UI.UIMainNotice.Component.MailListItem"
local UIMainNoticeView = BaseClass("UIMainNoticeView",UIBaseView)
local base = UIBaseView
local MailContentContainer = require "UI.UIMainNotice.Component.MailContentContainer"
local GroupCell = require "UI.UIMainNotice.Component.GroupCell"
local Localization = CS.GameEntry.Localization
--创建
function UIMainNoticeView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    DataCenter.WorldNoticeManager:InitData()
end

-- 销毁
function UIMainNoticeView:OnDestroy()
    self:SetAllTabGroupDestory()
    self._rightMailContent:SetAnchoredPosition(Vector2.New(0,0))
    DataCenter.WorldNoticeManager:SetCurId(0)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

function UIMainNoticeView:ComponentDefine()
    self.txt_title = self:AddComponent(UITextMeshProUGUIEx, "bg_mid/titleText")

    self.return_btn = self:AddComponent(UIButton, "bg_mid/CloseBtn")
    self.close_btn = self:AddComponent(UIButton, "panel")
    self.return_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    
    self._txtNoMail = self:AddComponent(UIText, "bg_mid/txtNoMail")

    self._rightScrollView = self:AddComponent(UIScrollRect, "bg_mid/RightScrollView")
    self._rightMailContent = self:AddComponent(MailContentContainer, "bg_mid/RightScrollView/Viewport/Content")

    self._btnToBottom = self:AddComponent(UIButton, "bg_mid/ToBottom")
    self._btnToBottom:SetOnClick(BindCallback(self, self.OnClickToBottomBtn))
    self._btnToBottom:SetActive(false)
    self._txtToBottom = self:AddComponent(UIText, "bg_mid/ToBottom/ToBottomText")
    self._txtToBottom:SetLocalText(208213)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._btnToBottom.rectTransform)


    self.content = self:AddComponent(UIBaseContainer, "bg_mid/LeftScrollView/Viewport/Content")
    
    self._translate_btn = self:AddComponent(UIButton,"bg_mid/btnTranslate")
    self._translate_btn:SetOnClick(BindCallback(self, self.OnClickTranslateBtn))
    self._translate_txt = self:AddComponent(UITextMeshProUGUIEx,"bg_mid/btnTranslate/Txt_Translate")
end

function UIMainNoticeView:ComponentDestroy()
    self.txt_title = nil
    self.close_btn = nil
    self.back_btn = nil
    self.day_task = nil
    self.return_btn = nil
end

function UIMainNoticeView:OnEnable()
    base.OnEnable(self)
end

function UIMainNoticeView:OnDisable()
    base.OnDisable(self)
end

function UIMainNoticeView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.NoticeItemClick, self.ClickItem)
    self:AddUIListener(EventId.GetNoticeList, self.OnRefresh)
end

function UIMainNoticeView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.NoticeItemClick, self.ClickItem)
    self:RemoveUIListener(EventId.GetNoticeList, self.OnRefresh)
end

function UIMainNoticeView:OnRefresh()
    self.isBtnReward = false
    self.txt_title:SetLocalText(312082)
    self.noticeData =  DataCenter.WorldNoticeManager:GetDataInfo()
    self.list =  DataCenter.WorldNoticeManager:GetDataType()
    self:SetAllTabGroupDestory()
    self.modelGroups = {}
    self._translate_txt:SetLocalText(290042)
    self.maildata = nil
    --类型可能不是连续 添加个新tab用来按顺序取出
    local tempList = {}
    for i ,v in pairs(self.list) do
        tempList[#tempList + 1] = i
    end
    table.sort(tempList,function(a,b)
        if a < b then
            return true
        end
        return false
    end)
    for i, v in ipairs(tempList) do
        if self.list[v] then
            if self.maildata == nil then
                self.maildata = self.list[v][1]
            end
            self.modelGroups[i] = self:GameObjectInstantiateAsync(UIAssets.UIMainNoticeGroup, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.name = "group"..v
                local cell = self.content:AddComponent(GroupCell, go.name)
                cell:RefreshGroup(v,self.list[v],function() self:CallBackRefresh() end)
            end)
        end
    end
    -- 显示第一封邮件内容
    self:ShowMailContentView()
end

function UIMainNoticeView:CallBackRefresh()
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
end

function UIMainNoticeView:SetAllTabGroupDestory()
    if self.content then
        self.content:RemoveComponents(GroupCell)
    end
    if self.modelGroups~=nil then
        for k,v in pairs(self.modelGroups) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
end

--[[
    右侧邮件内容 - 这个地方异步加载prefab
]]
function UIMainNoticeView:ShowMailContentView()
    self._txtNoMail:SetActive(false)
    self.ctrl:SetShowTranslated(false)
    self._translate_txt:SetLocalText(290042)
    self._rightScrollView.unity_uiscrollRect.verticalNormalizedPosition = 1;
    local result = self._rightMailContent:ShowData(self.maildata)
end

function UIMainNoticeView:OnClickTranslateBtn()
    local showTranslated = self.ctrl:GetShowTranslated()
    local tempShow = (not showTranslated)
    self.ctrl:SetShowTranslated(tempShow)
    if tempShow then
        self._translate_txt:SetLocalText(100163)
    else
        self._translate_txt:SetLocalText(290042)
    end
    if not self.maildata then
        return
    end
    if tempShow then
        local tempLang = Localization:GetLanguageName()
        tempLang = DataCenter.MailTranslateManager:GetLangString(tempLang)
        if not self.maildata.translateMsg or self.maildata.translateMsg == "" then
            DataCenter.WorldNoticeManager:TranslateNotice(self.maildata)
        else
            EventManager:GetInstance():Broadcast(EventId.ChangeShowTranslatedNotice, self.maildata)
        end
    else
        EventManager:GetInstance():Broadcast(EventId.ChangeShowTranslatedNotice, self.maildata)
    end
end


function UIMainNoticeView:OnClickToBottomBtn()
    local y = self._rightMailContent.rectTransform.sizeDelta.y - self._rightScrollView.rectTransform.sizeDelta.y
    self._rightMailContent.rectTransform.anchoredPosition = Vector2.New(0, y)
    self._btnToBottom:SetActive(false)
end

function UIMainNoticeView:RefreshToBottomBtn(btnGetReward)
    -- 如果：1.系统邮件；2.有奖励可领；3.领奖按钮超过视口下方，则显示跳转按钮
    local showToBottom = false
    self.btnGetReward = btnGetReward
    if btnGetReward ~= nil and btnGetReward:GetActive() then
        local standardScale = GetStandardScale()
        local posY = btnGetReward.transform.position.y + btnGetReward.rectTransform.sizeDelta.y / 2 * standardScale
        local bottom = self._rightScrollView.transform.position.y - self._rightScrollView.rectTransform.sizeDelta.y / 2 * standardScale
        if posY < bottom then
            showToBottom = true
        end
    end
    self._btnToBottom:SetActive(showToBottom)
    self.isBtnReward = true
end

function UIMainNoticeView:Update()
    if self.isBtnReward and self.btnGetReward ~= nil and self.btnGetReward:GetActive() and self._btnToBottom:GetActive() then
        local standardScale = GetStandardScale()
        local posY = self.btnGetReward.transform.position.y + self.btnGetReward.rectTransform.sizeDelta.y / 2 * standardScale
        local bottom = self._rightScrollView.transform.position.y - self._rightScrollView.rectTransform.sizeDelta.y / 2 * standardScale
        if posY >= bottom then
            self._btnToBottom:SetActive(false)
        end
    end
end

function UIMainNoticeView:ClickItem(uuid)
    for i = 1 ,table.count(self.noticeData) do
        if self.noticeData[i].uuid == uuid then
            self.maildata = self.noticeData[i]
            break
        end
    end
    self:ShowMailContentView()
end

return UIMainNoticeView