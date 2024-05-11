
local UIMoreInformationView = BaseClass("UIMoreInformationView", UIBaseView)
local base = UIBaseView
local UITabButton = require "UI.UIMoreInformation.Component.UITabButton"
local TitleItem = require "UI.UIMoreInformation.Component.EffectTitleItem"
local InfoItem = require "UI.UIMoreInformation.Component.EffectInfoItem"

local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local title_txt_Path = "UICommonPopUpTitle/bg_mid/titleText"
local table_btn_content_path = "ToggleGroupBg/ToggleGroup/UIMoreInformationTab_"

local head_icon_path = "PlayerContent/Head/UIPlayerHead/HeadIcon"
local head_Name_txt_path = "PlayerContent/Head/Head_Name"
local head_forceDes_txt_path = "PlayerContent/Head/layout/powerDi/ForceDes"
local head_force_txt_path = "PlayerContent/Head/layout/powerDi/Force"
local head_killDes_txt_path = "PlayerContent/Head/layout/KillDi/KillDes"
local head_kill_txt_path = "PlayerContent/Head/layout/KillDi/Kill"

local content_path = "Bg/LoopScroll/Viewport/Content"
local scrollView_path = "Bg/LoopScroll"

local max_tab_num = 4

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.title_txt = self:AddComponent(UITextMeshProUGUIEx, title_txt_Path)

    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self.head_icon = self:AddComponent(UIPlayerHead, head_icon_path)
    self.head_Name_txt = self:AddComponent(UITextMeshProUGUIEx, head_Name_txt_path)
    self.head_forceDes_txt = self:AddComponent(UITextMeshProUGUIEx, head_forceDes_txt_path)
    self.head_force_txt = self:AddComponent(UITextMeshProUGUIEx, head_force_txt_path)
    self.head_killDes_txt = self:AddComponent(UITextMeshProUGUIEx, head_killDes_txt_path)
    self.head_kill_txt= self:AddComponent(UITextMeshProUGUIEx, head_kill_txt_path)

    self.tab_btns = {}
    for i = 1, max_tab_num do
        local tab = self:AddComponent(UITabButton, table_btn_content_path..i)
        table.insert(self.tab_btns, tab)
        tab:SetActive(false)
    end
    
    self.content = self:AddComponent(UIBaseContainer, content_path)
    self.scroll_view = self:AddComponent(UILoopListView2, scrollView_path)
    self.scroll_view:InitListView(0, function(loopView, index)
        return self:OnGetItemByIndex(loopView, index)
    end)
end

local function ComponentDestroy(self)

end

local function DataDefine(self)
    self.infoItemIndex = 1
end

local function DataDestroy(self)
    self.infoItemIndex = 1
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.PlayerMessageInfo, self.OnPlayerDataCallBack)
    self:AddUIListener(EventId.PlayerPowerInfoUpdated, self.OnPlayerDataCallBack)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.PlayerMessageInfo, self.OnPlayerDataCallBack)
    self:RemoveUIListener(EventId.PlayerPowerInfoUpdated, self.OnPlayerDataCallBack)
    base.OnRemoveListener(self)
end

local function ReInit(self)
    self.uid = self:GetUserData()
    self.title_txt:SetLocalText(100092)
    if self.uid ~= nil then
        local info =  DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(self.uid)
        if info ~= nil then
            self:OnPlayerDataCallBack()
        else
            SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, self.uid)
        end
    end
end

local function TabClick(self, tabType)
    self.tabType = tabType
    self.tabAllData = self.ctrl:GetTabData(self.uid, self.tabType)
    self:RefreshTabBtns()
    self:RefreshTab()
end

local function GetCurShowTabData(self)
    self.tabShowData = {}
    for _, v in ipairs(self.tabAllData) do
        if v and v.effectList and #v.effectList > 0 then
            local title = {}
            title.isTitle = true
            title.nameStr = v.nameStr
            title.subType = v.subType
            title.callBack = BindCallback(self, self.OnTitleClick)
            title.isShow = v.isShow
            table.insert(self.tabShowData, title)
            if v.isShow then
                for _, effect in ipairs(v.effectList) do
                    local effectPara = {}
                    effectPara.nameStr = effect.nameStr
                    effectPara.valueStr = effect.valueStr
                    table.insert(self.tabShowData, effectPara)
                end
            end
        end
    end
end

local function RefreshTab(self)
    self:GetCurShowTabData()
    local count = table.count(self.tabShowData)
    
    self.scroll_view:SetListItemCount(count, false, false)
    self.scroll_view:RefreshAllShownItem()
end

local function RefreshTabBtns(self)
    if self.tabBtnData == nil then
        self.tabBtnData = self.ctrl:GetTabBtnData(self.uid)
    end
    for i = 1, max_tab_num do
        local data = self.tabBtnData[i]
        local cell = self.tab_btns[i]
        if data then
            data.callBack = BindCallback(self, self.TabClick)
            cell:SetActive(true)
            cell:ReInit(data)
            cell:SetSelect(self.tabType == data.tabType)
        else
            cell:SetActive(false)
        end
    end
end

local function OnPlayerDataCallBack(self)
    self:RefreshUserInfo()
    self:RefreshTabBtns()
    self:TabClick(self.tabBtnData[1].tabType)
end

local function OnGetItemByIndex(self, loopScroll, index)
    if self.tabShowData == nil then
        return nil
    end
    index = index + 1 --C#控件索引从0开始 
    if index < 1 or index > #self.tabShowData then
        return nil
    end

    local dt = self.tabShowData[index]

    --标题行-- titleLine
    if dt.isTitle then
        local item = loopScroll:NewListViewItem('Title')
        local script = self.content:GetComponent(item.gameObject.name, TitleItem)
        if script == nil then
            local objectName = self:GetItemNameSequence()
            item.gameObject.name = objectName
            if (not item.IsInitHandlerCalled) then
                item.IsInitHandlerCalled = true
            end

            script = self.content:AddComponent(TitleItem, objectName)
        end

        script:SetActive(true)
        script:SetData(dt)
        self:ResetInfoItemIndex()
        return item
    end

    --数据行
    local item = loopScroll:NewListViewItem('EffectItem')
    local script = self.content:GetComponent(item.gameObject.name, InfoItem)
    if script == nil then
        local objectName = self:GetItemNameSequence()
        item.gameObject.name = objectName
        if (not item.IsInitHandlerCalled) then
            item.IsInitHandlerCalled = true
        end

        script = self.content:AddComponent(InfoItem, objectName)
    end

    script:SetActive(true)
    dt.infoItemIndex = self.infoItemIndex
    self.infoItemIndex = self.infoItemIndex + 1
    script:SetData(dt)
    return item
end

local function ResetInfoItemIndex(self)
    self.infoItemIndex = 1
end

local function OnTitleClick(self, data)
    for _, v in ipairs(self.tabAllData) do
        if v.subType == data.subType then
            v.isShow = not v.isShow
            self.ctrl:SetTitleOpenState(v.mainType, v.subType, v.isShow)
        end
    end
    self:RefreshTab()
end

local function RefreshUserInfo(self)
    local info = self.ctrl:GetUserInfo(self.uid)
    if info.uid ~= nil then
        self.head_icon:SetData(info.uid, info.pic, info.picVer)
        self.head_Name_txt:SetText(info.name)
        self.head_forceDes_txt:SetLocalText(100644)
        self.head_force_txt:SetText(info.power)
        self.head_killDes_txt:SetLocalText(100196)
        self.head_kill_txt:SetText(info.armyKill)
    end
end

local function GetItemNameSequence()
    NameCount = NameCount + 1
    return tostring(NameCount)
end

UIMoreInformationView.OnCreate = OnCreate
UIMoreInformationView.OnDestroy = OnDestroy
UIMoreInformationView.OnEnable = OnEnable
UIMoreInformationView.OnDisable = OnDisable
UIMoreInformationView.ComponentDefine = ComponentDefine
UIMoreInformationView.ComponentDestroy = ComponentDestroy
UIMoreInformationView.DataDefine = DataDefine
UIMoreInformationView.DataDestroy = DataDestroy
UIMoreInformationView.OnAddListener = OnAddListener
UIMoreInformationView.OnRemoveListener = OnRemoveListener
UIMoreInformationView.ReInit = ReInit
UIMoreInformationView.TabClick = TabClick
UIMoreInformationView.RefreshTab = RefreshTab
UIMoreInformationView.RefreshTabBtns = RefreshTabBtns
UIMoreInformationView.GetCurShowTabData = GetCurShowTabData
UIMoreInformationView.OnPlayerDataCallBack = OnPlayerDataCallBack
UIMoreInformationView.OnGetItemByIndex = OnGetItemByIndex
UIMoreInformationView.OnTitleClick = OnTitleClick
UIMoreInformationView.RefreshUserInfo = RefreshUserInfo
UIMoreInformationView.GetItemNameSequence = GetItemNameSequence
UIMoreInformationView.ResetInfoItemIndex = ResetInfoItemIndex

return UIMoreInformationView