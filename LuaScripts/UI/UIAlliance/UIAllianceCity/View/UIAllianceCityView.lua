local base = UIBaseView--Variable
local UIAllianceCityView = BaseClass("UIAllianceCityView", base)--Variable

local AllianceCityItem = require "UI.UIAlliance.UIAllianceCity.Component.AllianceCityItem"
local AllianceStorage = require "UI.UIAlliance.UIAllianceCity.Component.AllianceStorage"
local AllianceLogGrid = require "UI.UIAlliance.UIAllianceMainTable.Component.AllianceLogGrid"
local AllianceLogCell = require "UI.UIAlliance.UIAllianceMainTable.Component.AllianceLogCell"
local AllianceMinePanel = require "UI.UIAlliance.UIAllianceCity.Component.AllianceMinePanel"
local AllianceCenterPanel = require "UI.UIAlliance.UIAllianceCity.Component.AllianceCenterPanel"
local closeBtn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local titleTxt_path = "UICommonPopUpTitle/bg_mid/titleText"
local content_path = "offset/citys/ScrollView/Viewport/Content/allianceContent"
local noCity_path = "offset/citys/ScrollView/Viewport/Content/allianceContent/NoCity"
local noCityTxt_path = "offset/citys/ScrollView/Viewport/Content/allianceContent/NoCity/NoCityTxt"
local cityCount_path = "offset/citys/cityCount"
local tab_path = "offset/Tab/Toggle"
local cityContainer_path = "offset/citys"
local storageContainer_path = "offset/storage"
local alMineContainer_path = "offset/mines"
local AlCenterContainer_path = "offset/allianceCIty"

local rect_alliancelog_path = "offset/citys/Rect_AllianceLog"
local rect_arrow_path = "offset/citys/Rect_AllianceLog/Rect_arrow"
local rect_logloop_path = "offset/citys/Rect_AllianceLog/Rect_LogLoop"
local txt_logloop1_path = "offset/citys/Rect_AllianceLog/Rect_LogLoop/Txt_LogLoop1"
local txt_logloop2_path = "offset/citys/Rect_AllianceLog/Rect_LogLoop/Txt_LogLoop2"
local btn_showlog_path = "offset/citys/Btn_ShowLog"
local btn_hidelog_path = "offset/citys/Btn_HideLog"
local img_logSign1_path = "offset/citys/Rect_AllianceLog/Rect_LogLoop/Txt_LogLoop1/Img_LogSign1"
local img_logSign2_path = "offset/citys/Rect_AllianceLog/Rect_LogLoop/Txt_LogLoop2/Img_LogSign2"
local log_des_path = "offset/citys/logDes"
local _cp_scrollView = "offset/citys/Rect_AllianceLog/Scroll_AllianceLog"
local _cp_scrollViewContent = "offset/citys/Rect_AllianceLog/Scroll_AllianceLog/Rect_ContentLog"
local rectDeclareWar_path = "offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar"
local noDeclareWar_txt_path = "offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar/Txt_NoDeclareWar"
local rect_city_path = "offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar/Rect_City"
local cityPos_txt_path = "offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar/Rect_City/Txt_CityPos"
local pos_btn_path ="offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar/Rect_City/Btn_Pos"
--local cancel_btn_path = "offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar/Rect_City/Btn_Cancel"
local content_txt_path = "offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar/Rect_City/Txt_Content"
local cityLevel_txt_path = "offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar/Rect_City/Txt_CityLevel"

local own_txt_path = "offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar/Rect_City/layout/ownObj/Txt_Own"
local own_des_path = "offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar/Rect_City/layout/ownObj/des_Own"
local startTime_des_path = "offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar/Rect_City/layout/startTimeObj/des_StartTime"
local startTime_txt_path = "offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar/Rect_City/layout/startTimeObj/Txt_StartTime"
local declareTime_des_path = "offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar/Rect_City/layout/declareTimeObj/des_DeclareTime"
local declareTime_txt_path = "offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar/Rect_City/layout/declareTimeObj/Txt_DeclareTime"
local declareTime_btn_path = "offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar/Rect_City/layout/declareTimeObj/Txt_DeclareTime/Btn_Tips"

local new_img_path = "offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar/Rect_City/Img_New"
local relics_txt_path = "offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar/Txt_Relics"
local relics2_txt_path = "offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar/Txt_Relics2"

local rect_declareContent = "offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar/Rect_City/Rect_DeclareContent"
local des_txt_path = "offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar/Rect_City/Rect_DeclareContent/ScrollView/Viewport/Content/desTxt"
local btn_showContent_path = "offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar/Rect_City/Rect_DeclareContent/Btn_ShowContent"
local btn_hideContent_path = "offset/citys/ScrollView/Viewport/Content/Rect_DeclareWar/Rect_City/Rect_DeclareContent/Btn_HideContent"
local alliance_mine_red_dot_path = "offset/Tab/Toggle1/ImgWarn1"
local allianceWarRed_path = "offset/Tab/Toggle2/ImgWarn2"
local alliance_center_red_dot_path = "offset/Tab/Toggle4/ImgWarn4"
local Localization = CS.GameEntry.Localization
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    
    self.curTabIndex,self.selectPos = self:GetUserData()
    if self.curTabIndex==nil then
        self.curTabIndex = 4
        if SeasonUtil.IsInSeasonDesertMode()==false then
            self.curTabIndex = 1
        end
        if not LuaEntry.DataConfig:CheckSwitch("alliance_res_build") then
            self.curTabIndex = 2
        end
    else
        if SeasonUtil.IsInSeasonDesertMode()==false and self.curTabIndex == 4 then
            self.curTabIndex = 1
        end
        if not LuaEntry.DataConfig:CheckSwitch("alliance_res_build")  and self.curTabIndex == 1 then
            self.curTabIndex = 2
        end
    end
    for i = 1,#self.tabsTb do
        self.tabsTb[i]:SetIsOn(self.curTabIndex == i)
    end
    if self.selectPos==nil then
        self.selectPos = 0
    end
    
    self:RefreshAll()
    self.alliance_mine_red_dot:SetActive(DataCenter.AllianceMineManager:GetShowRedDotNum())
    self.alliance_center_red_dot:SetActive(DataCenter.AllianceMineManager:GetShowAllianceCityRedDotNum())
end

local function OnDestroy(self)
    DOTween.Kill(self._allianceLog_rect.transform)
    DOTween.Kill(self._logLoop1_txt.transform)
    DOTween.Kill(self._logLoop2_txt.transform)
    DOTween.Kill(self._declareContent_rect.transform)
    self:DeleteDeclareTimer()
    self._scrollViewContent:RemoveComponents(AllianceLogGrid)
    self._scrollViewContent:RemoveComponents(AllianceLogCell)
    self._scrollView:ClearAllItems()
    self._scrollView.unity_looplistview2.mOnEndDragAction = nil
    self:DeleteTimer()
    self:ClearScroll()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.titleTxtN = self:AddComponent(UITextMeshProUGUIEx, titleTxt_path)
    self.titleTxtN:SetLocalText(300724) 
    self.contentN = self:AddComponent(UIBaseContainer, content_path)
    self.noCityN = self:AddComponent(UIBaseContainer, noCity_path)
    self.noCityTxtN = self:AddComponent(UITextMeshProUGUIEx, noCityTxt_path)
    self.noCityTxtN:SetLocalText(300725)
    
    self.log_des = self:AddComponent(UITextMeshProUGUIEx, log_des_path)
    self.log_des:SetLocalText(311047)
    self.cityCountN = self:AddComponent(UITextMeshProUGUIEx, cityCount_path)
    self.alliance_mine_red_dot = self:AddComponent(UIBaseContainer, alliance_mine_red_dot_path)
    self.alliance_center_red_dot = self:AddComponent(UIBaseContainer, alliance_center_red_dot_path)
    self.allianceWarRedN = self:AddComponent(UIBaseContainer, allianceWarRed_path)
    self.tabsTb = {}
    self.chooseTb = {}
    self.selectNameTb = {}
    self.unselectNameTb = {}
    
    for i = 1, 4 do
        local tempTab = self:AddComponent(UIToggle, tab_path .. i)
        local tempChoose = tempTab:AddComponent(UIBaseContainer, "Choose")
        local unselectName = tempTab:AddComponent(UITextMeshProUGUIEx, "unselectName")
        local selectName = tempTab:AddComponent(UITextMeshProUGUIEx, "Choose/selectName")
        if i == 1 then
            if LuaEntry.DataConfig:CheckSwitch("alliance_res_build") == true then
                tempTab:SetActive(true)
                tempTab:SetOnValueChanged(function(tf)
                    if tf then
                        self:OnToggleChange()
                    end
                end)
            else
                tempTab:SetActive(false)
            end
        elseif i == 4 then
            if SeasonUtil.IsInSeasonDesertMode() == true then
                tempTab:SetActive(true)
                tempTab:SetOnValueChanged(function(tf)
                    if tf then
                        self:OnToggleChange()
                    end
                end)
            else
                tempTab:SetActive(false)
            end
        else
            tempTab:SetOnValueChanged(function(tf)
                if tf then
                    self:OnToggleChange()
                end
            end)
            
        end
        table.insert(self.tabsTb, tempTab)
        table.insert(self.chooseTb, tempChoose)
        table.insert(self.unselectNameTb, unselectName)
        table.insert(self.selectNameTb, selectName)
    end
    self.selectNameTb[1]:SetLocalText(100281)
    self.unselectNameTb[1]:SetLocalText(100281)
    self.selectNameTb[2]:SetLocalText(302610)
    self.unselectNameTb[2]:SetLocalText(302610)
    self.selectNameTb[3]:SetLocalText(100024)
    self.unselectNameTb[3]:SetLocalText(100024)
    self.selectNameTb[4]:SetLocalText(310148)
    self.unselectNameTb[4]:SetLocalText(310148)
    self.cityContainerN = self:AddComponent(UIBaseContainer, cityContainer_path)
    self.storageContainerN = self:AddComponent(AllianceStorage, storageContainer_path)
    self.alMinesContainerN = self:AddComponent(AllianceMinePanel, alMineContainer_path)
    self.AlCenterContainerN = self:AddComponent(AllianceCenterPanel, AlCenterContainer_path)
    self._allianceLog_rect = self:AddComponent(UIBaseContainer,rect_alliancelog_path)
    self._logLoop_rect = self:AddComponent(UIBaseContainer,rect_logloop_path)
    self._arrow_rect = self:AddComponent(UIImage,rect_arrow_path)
    self._logLoop1_txt = self:AddComponent(UITextMeshProUGUIEx,txt_logloop1_path)
    self._logLoop2_txt = self:AddComponent(UITextMeshProUGUIEx,txt_logloop2_path)
    self._logSign1_img = self:AddComponent(UIImage,img_logSign1_path)
    self._logSign2_img = self:AddComponent(UIImage,img_logSign2_path)
    self._logLoop1_txt:SetText(Localization:GetString("141096"))
    self._logSign1_img:SetActive(false)
    self._showLog_btn = self:AddComponent(UIButton,btn_showlog_path)
    self._showLog_btn:SetOnClick(function()
        self:OnClickLogBtn(1)
    end)
    self._hideLog_btn = self:AddComponent(UIButton,btn_hidelog_path)
    self._hideLog_btn:SetOnClick(function()
        self:OnClickLogBtn(2)
    end)

    self._scrollView = self:AddComponent(UILoopListView2, _cp_scrollView)
    self._scrollView_ScrollRect = self:AddComponent(UIScrollRect, _cp_scrollView)
    self._scrollViewContent = self:AddComponent(UIBaseContainer, _cp_scrollViewContent)
    self._scrollView:InitListView(0, function(loopView, index)
        return self:OnGetItemByIndex(loopView, index)
    end)
    self._scrollView.unity_looplistview2.mOnEndDragAction = function()
        self:OnEndDrag();
    end

    self.rectDeclareWar = self:AddComponent(UIBaseContainer, rectDeclareWar_path)
    self._noDeclareWar_txt = self:AddComponent(UITextMeshProUGUIEx,noDeclareWar_txt_path)
    self._rect_city = self:AddComponent(UIBaseComponent,rect_city_path)
    self._cityPos_txt = self:AddComponent(UITextMeshProUGUIEx,cityPos_txt_path)
    self.pos_btn_path = self:AddComponent(UIButton,pos_btn_path)
    self.pos_btn_path:SetOnClick(function()
        self:OnClickPos()
    end)
    self._tips_btn = self:AddComponent(UIButton,declareTime_btn_path)
    self._tips_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickTips()
    end)
    --self.cancel_btn_path = self:AddComponent(UIButton,cancel_btn_path)
    --self.cancel_btn_path:SetOnClick(function()
    --    self:OnClickCancel()
    --end)
    self._content_txt = self:AddComponent(UITextMeshProUGUIEx,content_txt_path)
    self._cityLevel_txt = self:AddComponent(UITextMeshProUGUIEx,cityLevel_txt_path)

    self.own_txt = self:AddComponent(UITextMeshProUGUIEx,own_txt_path)
    self.own_des = self:AddComponent(UITextMeshProUGUIEx,own_des_path)
    self.own_des:SetLocalText(300696)
    self.declareTime_des = self:AddComponent(UITextMeshProUGUIEx,declareTime_des_path)
    self.declareTime_des:SetLocalText(450095)
    self.declareTime_txt = self:AddComponent(UITextMeshProUGUIEx,declareTime_txt_path)
    self.startTime_des = self:AddComponent(UITextMeshProUGUIEx,startTime_des_path)
    self.startTime_des:SetLocalText(450094)
    self.startTime_txt = self:AddComponent(UITextMeshProUGUIEx,startTime_txt_path)

    self._new_img = self:AddComponent(UIImage,new_img_path)
    self._relics_txt = self:AddComponent(UITextMeshProUGUIEx,relics_txt_path)
    self._relics_txt:SetLocalText(143549)
    self._relics2_txt = self:AddComponent(UITextMeshProUGUIEx,relics2_txt_path)
    self._relics2_txt:SetLocalText(390876)

    self._declareContent_rect = self:AddComponent(UIBaseContainer,rect_declareContent)
    self._declareDes_txt = self:AddComponent(UITextMeshProUGUIEx,des_txt_path)
    self._showContent_btn = self:AddComponent(UIButton,btn_showContent_path)
    self._hideContent_btn = self:AddComponent(UIButton,btn_hideContent_path)
    -- self._showContent_btn:SetOnClick(function()
    --     self:OnClickContent(1)
    -- end)
    -- self._hideContent_btn:SetOnClick(function()
    --     self:OnClickContent(2)
    -- end)
end

local function ComponentDestroy(self)
    self.closeBtnN = nil
    self.titleTxtN = nil
    self.contentN = nil
    self.noCityN = nil
    self.noCityTxtN = nil
    self.cityCountN = nil
    self.alMinesContainerN = nil
    self.AlCenterContainerN = nil
end

local function DataDefine(self)
    self.alCityIdList = nil

    self._timer_loop = nil
    self._timer_loop_action = function(temp)
        self:RefreshLog()
    end
    self.allLog = {}    --联盟日志
    self.listLog = {}   --处理时间后的日志
    self.allLogCurNum = 0 --日志当前循环索引
    self.isCreat = false  --是否第一次创建日志
    self.isShowLog = false  --是否展开日志
    self.lastLogCount = 0
    self.cells = {}
    self._isFetchingMore = false
    self.timer = nil
    self.timer_action = function(temp)
        self:RefreshTimer()
    end
end

local function DataDestroy(self)
    self.alCityIdList = nil
end


local function InitData(self)
    SFSNetwork.SendMessage(MsgDefines.GetAllAlCityInfo)
    self._allianceLog_rect:SetSizeDelta(Vector2.New(self._allianceLog_rect:GetSizeDelta().x, 0))
    self._logLoop_rect:SetActive(true)
    self._showLog_btn:SetActive(true)
    self._hideLog_btn:SetActive(false)
    self._arrow_rect:SetActive(false)

    self:AllianceLogUpdateSignal()
end

local function OnToggleChange(self)
    self.curTabIndex = 1
    if self.tabsTb[1]:GetIsOn() then
        self.curTabIndex = 1
    elseif self.tabsTb[2]:GetIsOn() then
        self.curTabIndex = 2
    elseif self.tabsTb[3]:GetIsOn() then
        self.curTabIndex = 3
    elseif self.tabsTb[4]:GetIsOn() then
        self.curTabIndex = 4
    end
    self:RefreshAll()
end

local function RefreshAll(self)
    if self.curTabIndex == 2 then
        self.cityContainerN:SetActive(true)
        self.storageContainerN:SetActive(false)
        self.alMinesContainerN:SetActive(false)
        self.AlCenterContainerN:SetActive(false)
        self:InitData()
        self:RefreshDeclareWar()
        --self:ShowCitys()
    elseif self.curTabIndex == 3 then
        self.storageContainerN:SetActive(true)
        self.cityContainerN:SetActive(false)
        self.alMinesContainerN:SetActive(false)
        self.AlCenterContainerN:SetActive(false)
        self:ShowStorage()
    elseif self.curTabIndex == 1 then
        
        self.storageContainerN:SetActive(false)
        self.cityContainerN:SetActive(false)
        self.AlCenterContainerN:SetActive(false)
        if LuaEntry.DataConfig:CheckSwitch("alliance_res_build") == true then
            self.alMinesContainerN:SetActive(true)
            self:ShowAllianceMine()
        else
            self.alMinesContainerN:SetActive(false)
        end

    elseif self.curTabIndex == 4 then

        self.storageContainerN:SetActive(false)
        self.cityContainerN:SetActive(false)
        self.alMinesContainerN:SetActive(false)
        if SeasonUtil.IsInSeasonDesertMode() == true then
            self.AlCenterContainerN:SetActive(true)
            self:ShowAllianceCenter()
        else
            self.AlCenterContainerN:SetActive(false)
        end
    end
   
    for i = 1, 4 do
        self.chooseTb[i]:SetActive(i == self.curTabIndex)
        self.selectNameTb[i]:SetActive(i == self.curTabIndex)
        self.unselectNameTb[i]:SetActive(i ~= self.curTabIndex)
    end

    local hasRed = DataCenter.AllianceDeclareWarManager:CheckWarIsNew()
    self.allianceWarRedN:SetActive(hasRed)
end

local function ShowAllianceMine(self)
    self.titleTxtN:SetLocalText(300747)
    self.alMinesContainerN:ShowPanel()
end
local function ShowAllianceCenter(self)
    self.titleTxtN:SetLocalText(302741)
    self.AlCenterContainerN:ShowPanel(self.selectPos)
end
local function ShowStorage(self)
    self.titleTxtN:SetLocalText(390963)
    self.storageContainerN:InitData()
end

local function ShowCitys(self)
    if self.curTabIndex ~= 2 then
        return
    end
    self.titleTxtN:SetLocalText(300724)
    self:ClearScroll()
    self.alCityIdList = self.ctrl:GetMyAllianceCities() or {}
    local dataCount = table.count(self.alCityIdList)

    if dataCount <= 0 then
        self.noCityN:SetActive(true)
    else
        self.noCityN:SetActive(false)
        local list = self.alCityIdList
        if list~=nil and #list>0 then
            for i = 1, #list do
                --复制基础prefab，每次循环创建一次
                self.build_model[list[i]] = self:GameObjectInstantiateAsync("Assets/Main/Prefab_Dir/UI/Alliance/AllianceCityItem.prefab", function(request)
                    if request.isError then
                        return
                    end
                    local go = request.gameObject;
                    go.gameObject:SetActive(true)
                    go.transform:SetParent(self.contentN.transform)
                    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                    local nameStr = tostring(NameCount)
                    go.name = nameStr
                    NameCount = NameCount + 1
                    local cell = self.contentN:AddComponent(AllianceCityItem,nameStr)
                    cell:ShowCity(list[i])
                    self.buildItemList[list[i]] = cell
                end)
            end
        end
    end
    
    local cityMax = LuaEntry.DataConfig:TryGetNum("worldcity_s0", "k12")
    local effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.ALLIANCE_CITY_MAX_NUM)
    cityMax = cityMax + effectNum
    self.cityCountN:SetLocalText(302290, Localization:GetString("150033", #self.alCityIdList,  cityMax)) 
end

local function ClearScroll(self)
    if self.contentN~=nil then
        self.contentN:RemoveComponents(AllianceCityItem)
    end
    if self.build_model~=nil then
        for k,v in pairs(self.build_model) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.build_model ={}
    self.buildItemList = {}
end


local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.UpdateMyAlCities, self.ShowCitys)
    self:AddUIListener(EventId.MyAlCityListChanged, self.InitData)
    self:AddUIListener(EventId.AllianceCityLogUpdate, self.AllianceLogUpdateSignal)
    self:AddUIListener(EventId.DeclareWar, self.RefreshDeclareWar)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.UpdateMyAlCities, self.ShowCitys)
    self:RemoveUIListener(EventId.MyAlCityListChanged, self.InitData)
    self:RemoveUIListener(EventId.AllianceCityLogUpdate, self.AllianceLogUpdateSignal)
    self:RemoveUIListener(EventId.DeclareWar, self.RefreshDeclareWar)
    base.OnRemoveListener(self)
end

local function OnGetItemByIndex(self, loopScroll, index)
    index = index + 1 --C#控件索引从0开始 
    if index < 1 or index > self.count then
        return nil
    end
    self.prefabIndex = self.prefabIndex or 0
    local dt = self.listLog[self.count + 1 - index]

    if type(dt) == 'number' then
        local item = loopScroll:NewListViewItem('AllianceLogGrid')
        if (item == nil) then
            return nil
        end
        if self.cells[item] ~= nil then
            self.cells[item]:SetActive(true)
            self.cells[item]:ReInit(dt)
        else
            local script = self._scrollViewContent:GetComponent(item.gameObject.name, AllianceLogGrid)
            if script == nil then
                local objectName = "AllianceLogGrid_".. self.prefabIndex
                self.prefabIndex = self.prefabIndex + 1
                item.gameObject.name = objectName
                if (not item.IsInitHandlerCalled) then
                    item.IsInitHandlerCalled = true
                end

                script = self._scrollViewContent:AddComponent(AllianceLogGrid, objectName)
            end

            script:SetActive(true)
            script:ReInit(dt)
            self.cells[item] = script
        end
        return item
    end

    local item = loopScroll:NewListViewItem('AllianceLogCell')
    if (item == nil) then
        return nil
    end
    if self.cells[item] ~= nil then
        self.cells[item]:SetActive(true)
        self.cells[item]:ReInit(dt)
    else
        local script = self._scrollViewContent:GetComponent(item.gameObject.name, AllianceLogCell)
        if script == nil then
            local objectName = "AllianceLogCell_".. self.prefabIndex
            self.prefabIndex = self.prefabIndex + 1
            item.gameObject.name = objectName
            if (not item.IsInitHandlerCalled) then
                item.IsInitHandlerCalled = true
            end

            script = self._scrollViewContent:AddComponent(AllianceLogCell, objectName)
        end

        script:SetActive(true)
        script:ReInit(dt)
        self.cells[item] = script
    end
    return item
end

local function OnEndDrag(self)
    if (not self._isFetchingMore) then
        if (self._scrollView.unity_looplistview2.ContainerTrans.rect.height - self._scrollView.unity_looplistview2.ContainerTrans.localPosition.y < 400) then
            self:GetHistoricalChat()
        end
    end
end

local function GetHistoricalChat(self)
    self._isFetchingMore = true
    --DataCenter.AllianceMainManager:SetLastLogTime(self.allLog[table.count(self.allLog)].time)
    SFSNetwork.SendMessage(MsgDefines.ViewAllianceLog,self.allLog[table.count(self.allLog)].time,true)
end

local function AllianceLogUpdateSignal(self)
    --当创建过并且正在查看日志时更新数据
    if self.isCreat then
        self.allLog = DataCenter.AllianceCityLogManager:GetAllLog()
        self._isFetchingMore = false;
        self.listLog,self.count = DataCenter.AllianceCityLogManager:GetAnalyseData()
        self._scrollView:SetListItemCount(self.count, false, false)
        self._scrollView:RefreshAllShownItem()
        local oldChatCount = self.lastLogCount
        self._scrollView.unity_looplistview2:ForceUpdate()
        --  self._scrollView:MovePanelToItemIndex(oldChatCount, 0)
        self.lastLogCount = self.count
        return
    end
    self.isCreat = true
    --获取日志
    self.allLog = DataCenter.AllianceCityLogManager:GetAllLog()
    if not self.allLog then
        return
    end
    self.listLog,self.count = DataCenter.AllianceCityLogManager:GetAnalyseData()
    self.lastLogCount = #self.listLog
    if next(self.allLog) then
        --默认先填充第一条
        self._logLoop1_txt:SetText(self.allLog[1]:GetStrLog(true))
        self._logSign1_img:LoadSprite(self.allLog[1]:GetLogSignIconPath())
        self._logSign1_img:SetActive(true)
        --判断是否只有一条日志
        if table.count(self.allLog) ~= 1 then
            self._logLoop2_txt:SetText(self.allLog[2]:GetStrLog(true))
            self._logSign2_img:LoadSprite(self.allLog[2]:GetLogSignIconPath())
            self._logSign2_img:SetActive(true)
            --日志当前循环索引
            self.allLogCurNum = 2
            self:AddTimer()
        else
            self.allLogCurNum = 1
            self._logLoop2_txt:SetText("")
        end
        self._scrollView:SetListItemCount(self.count, false, false)
        --self._scrollView:RefreshAllShownItem()
    end
end

local function DeleteTimer(self)
    if self._timer_loop ~= nil then
        self._timer_loop:Stop()
        self._timer_loop = nil
    end
end

local function AddTimer(self)
    if self._timer_loop == nil then
        self.loopYPos1 = 29
        self.loopYPos2 = 0
        self.loopYPosSign1 = 30
        self.loopYPosSign2 = 0
        self._logLoop1_txt:SetAnchoredPositionXY(30,0)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate( self._logLoop1_txt.rectTransform)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate( self._logLoop2_txt.rectTransform)
        --计算文本滚动次数，处理文本多行换行时
        local height1 = self._logLoop1_txt:GetSizeDelta().y
        self.loopInitNum1 = math.ceil(height1) / 29
        self.loopNum1 = Mathf.Ceil(self.loopInitNum1)
        self._logLoop2_txt:SetAnchoredPositionXY(30,-29)
        local height2 = self._logLoop2_txt:GetSizeDelta().y
        self.loopInitNum2 = math.ceil(height2) / 29
        self.loopNum2 = Mathf.Ceil(self.loopInitNum2)
        self._timer_loop = TimerManager:GetInstance():GetTimer(3, self._timer_loop_action , self, false,false,false)
        self._timer_loop:Start()
    end
end

local function RefreshLog(self)
    --刷新
    if self.loopNum2 == 1 or self.loopYPos2 == 0 then
        self._logLoop1_txt.rectTransform:DOAnchorPosY(self.loopYPos1, 0.5):OnComplete(function()
            --计算文本滚动次数
            if self.loopYPos1 ~= 0 or self.loopYPos1 == 29 then
                self.loopNum1 = self.loopNum1 - 1
            end
            --循环结束，进行下一次循环
            if self.loopNum1 == 0 then
                self._logLoop1_txt:SetAnchoredPositionXY(30,-29)
                --获取下一条日志
                local data = DataCenter.AllianceCityLogManager:GetAllianceLogById(self.allLogCurNum + 1)
                --下一条日志是否存在
                if data then
                    self.allLogCurNum = self.allLogCurNum + 1
                    self._logLoop1_txt:SetText(data:GetStrLog(true))
                    self._logSign1_img:LoadSprite(data:GetLogSignIconPath())
                else
                    --下一条日志不存在时从第一条重新开始循环
                    self.allLogCurNum = 1
                    self._logLoop1_txt:SetText(self.allLog[1]:GetStrLog(true))
                    self._logSign1_img:LoadSprite(self.allLog[1]:GetLogSignIconPath())
                end
                CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._logLoop1_txt.rectTransform)
                local height = self._logLoop1_txt:GetSizeDelta().y
                self.loopInitNum1 = math.ceil(height) / 29
                self.loopNum1 = Mathf.Ceil(self.loopInitNum1)
                self.loopYPos1 = 0
            else
                --计算下次文本位置
                self.loopYPos1 = 29 + 29 * (self.loopInitNum1 - self.loopNum1)
            end
        end)
        --self._logSign2_img.rectTransform:DOAnchorPosY(self.loopYPosSign2, 0.5):OnComplete(function()
        --    if self.loopYPosSign2 == 30 then
        --        self._logSign2_img:SetAnchoredPositionXY(-245,-35)
        --    end
        --    if self.loopYPosSign2 == 0 then
        --        self.loopYPosSign2 = 30
        --    else
        --        self.loopYPosSign2 = 0
        --    end
        --end)
    end
    if self.loopNum1 == 1 or self.loopYPos1 == 0 then
        self._logLoop2_txt.rectTransform:DOAnchorPosY(self.loopYPos2, 0.5):OnComplete(function()
            --计算文本滚动次数
            if self.loopYPos2 ~= 0 or self.loopYPos2 == 29 then
                self.loopNum2 = self.loopNum2 - 1
            end
            --循环结束，进行下一次循环
            if self.loopNum2 == 0 then
                self._logLoop2_txt:SetAnchoredPositionXY(30,-29)
                --获取下一条日志
                local data = DataCenter.AllianceCityLogManager:GetAllianceLogById(self.allLogCurNum + 1)
                --下一条日志是否存在
                if data then
                    self.allLogCurNum = self.allLogCurNum + 1
                    self._logLoop2_txt:SetText(data:GetStrLog(true))
                    self._logSign2_img:LoadSprite(data:GetLogSignIconPath())
                else
                    --下一条日志不存在时从第一条重新开始循环
                    self.allLogCurNum = 1
                    self._logLoop2_txt:SetText(self.allLog[1]:GetStrLog(true))
                    self._logSign2_img:LoadSprite(self.allLog[1]:GetLogSignIconPath())
                end
                CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._logLoop2_txt.rectTransform)
                local height = self._logLoop2_txt:GetSizeDelta().y
                self.loopInitNum2 = math.ceil(height) / 29
                self.loopNum2 = Mathf.Ceil(self.loopInitNum2)
                self.loopYPos2 = 0
            else
                --计算下次文本位置
                self.loopYPos2 = 29 + 29 * (self.loopInitNum2 - self.loopNum2)
            end
        end)
        --self._logSign1_img.rectTransform:DOAnchorPosY(self.loopYPosSign1, 0.5):OnComplete(function()
        --    if self.loopYPosSign1 == 30 then
        --        self._logSign1_img:SetAnchoredPositionXY(-245,-35)
        --    end
        --    if self.loopYPosSign1 == 0 then
        --        self.loopYPosSign1 = 30
        --    else
        --        self.loopYPosSign1 = 0
        --    end
        --end)
    end
end

local function OnClickLogBtn(self,type)
    if not self.allLog then
        return
    end
    if next(self.allLog) then
        if type == 1 then
            self.isShowLog = true
            self._showLog_btn:SetActive(false)
            self._logLoop_rect:SetActive(false)
            self._arrow_rect:SetActive(true)
            self._allianceLog_rect.rectTransform:DOSizeDelta(Vector2.New(self._allianceLog_rect:GetSizeDelta().x, 326),0.1):OnComplete(function()
                self._hideLog_btn:SetActive(true)
            end)
        else
            self._logLoop_rect:SetActive(true)
            self._allianceLog_rect.rectTransform:DOSizeDelta(Vector2.New(self._allianceLog_rect:GetSizeDelta().x, 0),0.3)
            self._showLog_btn:SetActive(true)
            self._hideLog_btn:SetActive(false)
            self._arrow_rect:SetActive(false)
            self.isShowLog = false
        end
    end
end

local function RefreshDeclareWar(self)
    self.declareWarData = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
    if self.declareWarData then
        self.rectDeclareWar:SetActive(true)
        self._rect_city:SetActive(true)
        self._noDeclareWar_txt:SetActive(false)
        local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(self.declareWarData.content)
        if cityTemplate~=nil then
            local str = ""
            local level = cityTemplate.level
            local userName = ""
            local name = cityTemplate.name
            local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(tonumber(self.declareWarData.content))
            if cityInfo~=nil and cityInfo.cityName~=nil and cityInfo.cityName~="" then
                userName = cityInfo.cityName
            end
            -- local pos  = self.pointId * 10 + 7
            -- local point = (pos - pos % 10) / 10
            --local tilePos = SceneUtils.IndexToTilePos(point)
            local tilePos = cityTemplate.pos
            if userName~=nil and userName~="" then
                str = Localization:GetString("140205",level,userName)
            else
                str = Localization:GetString("140205",level,Localization:GetString(name))
            end
            --self._cityLevel_txt:SetLocalText(143560,UITimeManager:GetInstance():TimeStampToTimeForLocalMinute(self.declareWarData.st),str)
            self.startTime_txt:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocalMinute(self.declareWarData.st))
            self._cityLevel_txt:SetText(str)
            self._cityPos_txt:SetText(Localization:GetString("300015",tilePos.x,tilePos.y))
            
            --遗迹归属
            local pointId = SceneUtils.TilePosToIndex(tilePos)
            local pointInfo = DataCenter.WorldPointManager:GetPointInfo(pointId)
            local alAbbr = ""
            local alName = ""
            if pointInfo~=nil then
                local allianceCityPointInfo = PBController.ParsePbFromBytes(pointInfo.extraInfo, "protobuf.AllianceCityPointInfo")
                if allianceCityPointInfo~=nil then
                    alAbbr = allianceCityPointInfo["alAbbr"]
                    alName = allianceCityPointInfo["alName"]
                end
            end
            local nameStr = Localization:GetString("100206")
            if alAbbr ~= "" and alName ~= "" then
                nameStr = "["..alAbbr.."]"..alName
            end
            self.own_txt:SetText(nameStr)
        end
        self._content_txt:SetText(Localization:GetString("143554")..": ")
        
        self._declareDes_txt:SetText(self.declareWarData.anno)
        
        if DataCenter.AllianceDeclareWarManager:CheckWarIsNew() then
            self._new_img:SetActive(true)
            DataCenter.AllianceDeclareWarManager:SetWarState(false)
            EventManager:GetInstance():Broadcast(EventId.DeclareWar)
        else
            self._new_img:SetActive(false)
        end
        
        self:AddDeclareTimer()
        self:RefreshTimer()
    else
        self.rectDeclareWar:SetActive(true)
        self._rect_city:SetActive(false)
        self._noDeclareWar_txt:SetActive(true)
        self._noDeclareWar_txt:SetLocalText(143555)
    end

    -- self._declareContent_rect:SetSizeDelta(Vector2.New(651, 44))
end

local function AddDeclareTimer(self)
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self, false,false,false)
        self.timer:Start()
    end
end

local function RefreshTimer(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.declareWarData.et - curTime
    if remainTime > 0 then
        self.declareTime_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
        self:DeleteDeclareTimer()
    end
end

local function DeleteDeclareTimer(self)
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
end

local function OnClickPos(self)
    local cityData = LocalController:instance():getLine(TableName.WorldCity,tonumber(self.declareWarData.content))
    local cityLoc = string.split(cityData.location, "|")
    local v2 = {x = tonumber(cityLoc[1]),y = tonumber(cityLoc[2])}
    local posIndex = SceneUtils.TilePosToIndex(v2,ForceChangeScene.World)
    local worldPos = SceneUtils.TileIndexToWorld(posIndex, ForceChangeScene.World)
    worldPos.x = worldPos.x - 6
    worldPos.z = worldPos.z - 6
    self.ctrl:JumpToTargetPoint(worldPos)
end

local function OnClickTips(self)
    local param = {}
    param.type = "desc"
    param.title = ""
    param.desc = Localization:GetString("302312")
    param.alignObject = self._tips_btn
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

local function OnClickContent(self,index)
    if index == 1 then
        self._showContent_btn:SetActive(false)
        self._declareContent_rect.rectTransform:DOSizeDelta(Vector2.New(self._declareContent_rect:GetSizeDelta().x, 200),0.1):OnComplete(function()
            self._hideContent_btn:SetActive(true)
        end)
    else
        self._declareContent_rect.rectTransform:DOSizeDelta(Vector2.New(self._declareContent_rect:GetSizeDelta().x, 44),0.3)
        self._showContent_btn:SetActive(true)
        self._hideContent_btn:SetActive(false)
    end
end

--local function OnClickCancel(self)
--    UIUtil.ShowMessage(Localization:GetString("143559"),2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
--        SFSNetwork.SendMessage(MsgDefines.AllianceDeclareWarCancel,self.declareWarData.uuid)
--    end)
--end

UIAllianceCityView.OnCreate = OnCreate
UIAllianceCityView.OnDestroy = OnDestroy
UIAllianceCityView.OnAddListener = OnAddListener
UIAllianceCityView.OnRemoveListener = OnRemoveListener
UIAllianceCityView.ComponentDefine = ComponentDefine
UIAllianceCityView.ComponentDestroy = ComponentDestroy
UIAllianceCityView.DataDefine = DataDefine
UIAllianceCityView.DataDestroy = DataDestroy
UIAllianceCityView.OnCreateCell = OnCreateCell
UIAllianceCityView.OnDeleteCell = OnDeleteCell
UIAllianceCityView.InitData = InitData
UIAllianceCityView.ShowCitys = ShowCitys
UIAllianceCityView.ClearScroll = ClearScroll
UIAllianceCityView.OnToggleChange = OnToggleChange
UIAllianceCityView.ShowStorage = ShowStorage
UIAllianceCityView.ShowAllianceMine = ShowAllianceMine
UIAllianceCityView.RefreshAll = RefreshAll
UIAllianceCityView.OnGetItemByIndex =OnGetItemByIndex
UIAllianceCityView.OnEndDrag =OnEndDrag
UIAllianceCityView.GetHistoricalChat =GetHistoricalChat
UIAllianceCityView.AllianceLogUpdateSignal =AllianceLogUpdateSignal
UIAllianceCityView.DeleteTimer =DeleteTimer
UIAllianceCityView.AllianceLogUpdateSignal =AllianceLogUpdateSignal
UIAllianceCityView.AddTimer =AddTimer
UIAllianceCityView.RefreshLog =RefreshLog
UIAllianceCityView.OnClickLogBtn =OnClickLogBtn
UIAllianceCityView.RefreshDeclareWar = RefreshDeclareWar
UIAllianceCityView.OnClickPos = OnClickPos
--UIAllianceCityView.OnClickCancel = OnClickCancel
UIAllianceCityView.AddDeclareTimer = AddDeclareTimer
UIAllianceCityView.RefreshTimer = RefreshTimer
UIAllianceCityView.DeleteDeclareTimer = DeleteDeclareTimer
UIAllianceCityView.OnClickTips = OnClickTips
UIAllianceCityView.OnClickContent = OnClickContent
UIAllianceCityView.ShowAllianceCenter = ShowAllianceCenter
return UIAllianceCityView