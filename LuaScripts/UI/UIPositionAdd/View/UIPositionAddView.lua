---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Still4.
--- DateTime: 2021/6/30 16:35
---
local UIPositionAddView = BaseClass("UIPositionAddView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local return_btn_path = "UICommonPopUpTitle/panel"
local title_path = "UICommonPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local point_txt_path = "ImgBg/TxtPosition"
local subDesc_txt_path = "ImgBg/layout/subDesc"
local layout_path = "ImgBg/layout"
local input_path = "ImgBg/InputField"
local LeftTabs_path = "ImgBg/LeftTabs"
local toggle_personal_path = "ImgBg/LeftTabs/togPersonal"--位置标记
local togglePersonalSelected_path = "ImgBg/LeftTabs/togPersonal/Background/Checkmark1"
local toggle_alliance_path = "ImgBg/LeftTabs/togAlliance"--联盟标记
local toggleAllianceSelected_path = "ImgBg/LeftTabs/togAlliance/Background/Checkmark2"
local toggleAllianceTextSelected_path = "ImgBg/LeftTabs/togAlliance/checkText2"
local toggleAllianceTextUnSelected_path = "ImgBg/LeftTabs/togAlliance/text2"
local togglePersonalTextSelected_path = "ImgBg/LeftTabs/togPersonal/checkText1"
local togglePersonalTextUnSelected_path = "ImgBg/LeftTabs/togPersonal/text1"
local personal_mark_container_path = "ImgBg/PersonalMarks"--位置标记
local toggle1_path = "ImgBg/PersonalMarks/Toggle1"
local toggle1_text_path = "ImgBg/PersonalMarks/Toggle1/Text1"
local toggle2_path = "ImgBg/PersonalMarks/Toggle2"
local toggle2_text_path = "ImgBg/PersonalMarks/Toggle2/Text2"
local toggle3_path = "ImgBg/PersonalMarks/Toggle3"
local toggle3_text_path = "ImgBg/PersonalMarks/Toggle3/Text3"
local alliance_mark_container_path = "ImgBg/AllianceMarks"--联盟标记
local alliance_mark_item_path = "ImgBg/AllianceMarks/Items/Toggle_"--联盟标记
local alliance_mark_name_path = "ImgBg/AllianceMarks/SelectedName"--当前选中联盟标记名称
local set_btn_path = "ImgBg/Btns/setBtnObj"
local set_btn_txt_path = "ImgBg/Btns/setBtnObj/setText"
local del_btn_path = "ImgBg/Btns/delBtnObj"
local del_btn_txt_path = "ImgBg/Btns/delBtnObj/delText"

local MarkGroup = {
    Alliance = 1,
    Personal = 2,
}
--
--local MarkType = {
--    Special = 0,
--    Friend = 1,
--    Enemy = 2,
--    Alliance_Attack = 3,
--    Alliance_Sun = 4,
--    Alliance_LuckyClover = 5,
--}


local function OnCreate(self)
    base.OnCreate(self)
    -- 组装分享参数
    local share_param = self:GetUserData()
    --所有打开的地方，位置都统一做了操作：pointId*10+tileSize
    local point = (share_param.pos - share_param.pos % 10) / 10
    local pos = SceneUtils.IndexToTilePos(point)
    share_param.x = pos.x
    share_param.y = pos.y
    self.chat_data_param = share_param
    self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
    --self.title:SetLocalText(300033) 
    self.point_txt = self:AddComponent(UITextMeshProUGUIEx, point_txt_path)
    self.input = self:AddComponent(UITMPInput, input_path)
    self.input:SetOnEndEdit(function(value)
        self:IptOnValueChange(value)
    end)
    
    self.togglePersonal = self:AddComponent(UIToggle, toggle_personal_path)
    self.togglePersonal:SetOnValueChanged(function(tf)
        if tf then
            self:SelectMark(MarkType.Special)
            --self:OnMarkGroupChanged()
        end
    end)
    self.LeftTabs = self:AddComponent(UIBaseContainer, LeftTabs_path)
    self.togglePersonalSelected = self:AddComponent(UIBaseContainer, togglePersonalSelected_path)
    self.togglePersonalSelected:SetActive(false)
    self.togglePersonalTextSelected = self:AddComponent(UITextMeshProUGUIEx, togglePersonalTextSelected_path)
    self.togglePersonalTextSelected:SetActive(false)
    self.togglePersonalTextUnSelected = self:AddComponent(UITextMeshProUGUIEx, togglePersonalTextUnSelected_path)
    self.subDesc_txt = self:AddComponent(UITextMeshProUGUIEx, subDesc_txt_path)
    self.togglePersonalTextSelected:SetLocalText(100188)
    self.togglePersonalTextUnSelected:SetLocalText(100188)
    self.subDesc_txt:SetLocalText(100188)
    
    self.layout = self:AddComponent(UIBaseContainer, layout_path)
    self.toggleAlliance = self:AddComponent(UIToggle, toggle_alliance_path)
    self.toggleAlliance:SetOnValueChanged(function(tf)
        if tf then
            self:SelectMark(MarkType.Alliance_Attack)
            --self:OnMarkGroupChanged()
        end
    end)
    self.toggleAllianceSelected = self:AddComponent(UIBaseContainer, toggleAllianceSelected_path)
    self.toggleAllianceSelected:SetActive(false)

    self.toggleAllianceTextSelected = self:AddComponent(UITextMeshProUGUIEx, toggleAllianceTextSelected_path)
    self.toggleAllianceTextSelected:SetActive(false)

    self.toggleAllianceTextUnSelected = self:AddComponent(UITextMeshProUGUIEx, toggleAllianceTextUnSelected_path)
    self.toggleAllianceTextSelected:SetLocalText(241023)
    self.toggleAllianceTextUnSelected:SetLocalText(241023)


    self.personalMarkContainer = self:AddComponent(UIBaseContainer, personal_mark_container_path)

    self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
    --self.toggle1:SetIsOn(true)
    self.toggle1:SetOnValueChanged(function(tf)
        if tf then
            self:SelectMark(MarkType.Special)
            --self:ToggleControlBorS()
        end
    end)
    self.toggle1_text = self:AddComponent(UITextMeshProUGUIEx, toggle1_text_path)
    self.toggle1_text:SetLocalText(100185) 

    self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
    --self.toggle2:SetIsOn(false)
    self.toggle2:SetOnValueChanged(function(tf)
        if tf then
            self:SelectMark(MarkType.Friend)
            --self:ToggleControlBorS()
        end
    end)
    self.toggle2_text = self:AddComponent(UITextMeshProUGUIEx, toggle2_text_path)
    self.toggle2_text:SetLocalText(100186) 

    self.toggle3 = self:AddComponent(UIToggle, toggle3_path)
    --self.toggle3:SetIsOn(false)
    self.toggle3:SetOnValueChanged(function(tf)
        if tf then
            self:SelectMark(MarkType.Enemy)
            --self:ToggleControlBorS()
        end
    end)
    self.toggle3_text = self:AddComponent(UITextMeshProUGUIEx, toggle3_text_path)
    self.toggle3_text:SetLocalText(GameDialogDefine.BOOKMARK_ENEMY) 
    
    self.toggleImgTab = {}
    for i = 1, 3 do
        local imgPath = "ImgBg/PersonalMarks/Toggle"..i.."/ImgType"..i
        self.toggleImgTab[i] = self:AddComponent(UIImage,imgPath)
    end
    
    self.allianceMarkContainer = self:AddComponent(UIBaseContainer, alliance_mark_container_path)
    self.allianceMarksDic = {}
    self.allianceMarkTipsDic = {}
    for i = MarkType.Alliance_Attack, MarkType.Alliance_12 do
        local tempAlMark = self:AddComponent(UIToggle, alliance_mark_item_path .. i)
        tempAlMark:SetOnValueChanged(function(tf)
            if tf then
                self:OnAllianceMarkStateChanged(i)
            end
        end)
        self.allianceMarksDic[i] = tempAlMark
        local usedTxt = tempAlMark:AddComponent(UITextMeshProUGUIEx, "useBg/used")
        local useBg = tempAlMark:AddComponent(UIBaseContainer, "useBg")
        usedTxt:SetLocalText(129001) 
        self.allianceMarkTipsDic[i] = useBg
        self.allianceMarkTipsDic[i]:SetActive(DataCenter.WorldFavoDataManager:CheckIfAllianceMarkInUse(i))
    end
    self.allianceMarkName = self:AddComponent(UITextMeshProUGUIEx, alliance_mark_name_path)

    self.set_btn = self:AddComponent(UIButton, set_btn_path)
    self.set_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnSetClick()
    end)
    self.set_btn_txt = self:AddComponent(UITextMeshProUGUIEx, set_btn_txt_path)
    self.set_btn_txt:SetLocalText(GameDialogDefine.CONFIRM) 

    self.del_btn_txt = self:AddComponent(UITextMeshProUGUIEx, del_btn_txt_path)
    self.del_btn_txt:SetLocalText(100190) 
    self.delBtn = self:AddComponent(UIButton, del_btn_path)
    self.delBtn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickDelBtn()
    end)

    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)

    self:InitState()
end
local function OnDestroy(self)
    self.chat_data_param = nil
    self.name = nil
    self.title = nil
    self.point_txt = nil
    self.input = nil
    self.toggle1 = nil
    self.toggle1_text = nil
    self.toggle2 = nil
    self.toggle2_text = nil
    self.toggle3 = nil
    self.toggle3_text = nil
    self.set_btn = nil
    self.set_btn_txt = nil
    self.close_btn = nil
    self.return_btn = nil
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function InitState(self)
    local t = self.chat_data_param
    local data = self.ctrl:GetBookmark(t.pos, t.sid)
    local name = ""
    self.isInclude = false
    if data ~= nil then
        self.chat_data_param.type = data.type
        if data.type ~= MarkType.Alliance_Attack then
            self.isInclude = true
        end
        --self.selectType = data.type
        self:SelectMark(data.type)
        name = data.name-- Localization:GetString(data.name)
        --local isInUse = DataCenter.WorldFavoDataManager:CheckIfPointInUse(self.chat_data_param.pos)
        self.delBtn:SetActive(true)

        --if self.selectType == 0 then
        --    self.toggle1:SetIsOn(true)
        --elseif self.selectType == 1 then
        --    self.toggle2:SetIsOn(true)
        --elseif self.selectType == 2 then
        --    self.toggle3:SetIsOn(true)
        --end
    else
        self.chat_data_param.type = nil
        
        --self.selectType = 0
        
        
        self.delBtn:SetActive(false)
        
        --local uname = nil
        --if not string.IsNullOrEmpty(t.uname) then
        --    if string.IsNullOrEmpty(t.abbr) then
        --        uname = t.uname
        --    else
        --        uname = "[" .. t.abbr .. "]" .. t.uname
        --    end
        --end
        local oname = nil
        if not string.IsNullOrEmpty(t.oname) then
            if tonumber(t.oname) then
                oname = Localization:GetString(t.oname) .. ";" .. t.oname
                if t.olv ~=nil and t.olv > 0 then
                    oname = Localization:GetString(GameDialogDefine.LEVEL_NUMBER, t.olv) .. " " .. oname .. ";" .. t.olv
                end
            else
                oname = t.oname
            end
        end
        --if uname ~= nil and oname ~= nil then
        --    name = Localization:GetString(GameDialogDefine.POSITION_DESC, uname, oname)
        --else
        --    if uname ~= nil then
        --        name = uname
        --    end
        if oname ~= nil then
            name = oname
        end
        --end
    end

    local tempType = MarkType.Special
    if not self.ctrl:CheckIfCanAddAllianceMark() then
        self.layout:SetActive(true)
        self.LeftTabs:SetActive(false)
    else
        self.LeftTabs:SetActive(true)
        self.layout:SetActive(false)
    end
    self:SelectMark(tempType)
    
    local nameOnShow = string.split(name, ";")
    self.input:SetText(nameOnShow[1])
    self.name = name
    if DataCenter.AccountManager:GetServerTypeByServerId(self.chat_data_param.sid) == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
        self.point_txt:SetLocalText(376134,self.chat_data_param.x,  self.chat_data_param.y)
    else
        self.point_txt:SetLocalText(GameDialogDefine.POSITION_COORDINATE_CROSS,  self.chat_data_param.sid,  self.chat_data_param.x,  self.chat_data_param.y)
    end
    --self:ToggleControlBorS()
end

local function SelectMark(self, markType)
    self.selectType = markType
    
    if self.selectType == MarkType.Special or self.selectType == MarkType.Enemy or self.selectType == MarkType.Friend then
        self:SelectMarkGroup(MarkGroup.Personal)
        if self.selectType == 0 then
            self.toggle1:SetIsOn(true)
        elseif self.selectType == 1 then
            self.toggle2:SetIsOn(true)
        elseif self.selectType == 2 then
            self.toggle3:SetIsOn(true)
        end
        if LuaEntry.Player.serverType == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
            CS.UIGray.SetGray(self.set_btn.transform, true,false)
        else
            CS.UIGray.SetGray(self.set_btn.transform, false,true)
        end
    else
        CS.UIGray.SetGray(self.set_btn.transform, false,true)
        self:SelectMarkGroup(MarkGroup.Alliance)
        self.allianceMarksDic[self.selectType]:SetIsOn(true)
    end
end

local function SelectMarkGroup(self, groupType)
    if self.curMarkGroup == groupType then
        return
    end
    self.curMarkGroup = groupType
    if self.curMarkGroup == MarkGroup.Alliance then
        self.togglePersonal:SetIsOn(false)
        self.toggleAlliance:SetIsOn(true)
        self.toggleAllianceSelected:SetActive(true)
        self.toggleAllianceTextSelected:SetActive(true)
        self.toggleAllianceTextUnSelected:SetActive(false)
        self.togglePersonalSelected:SetActive(false)
        self.togglePersonalTextSelected:SetActive(false)
        self.togglePersonalTextUnSelected:SetActive(true)
        self:OnMarkGroupChanged()
        self:SetAllianceMarks()
        local isInUse = DataCenter.WorldFavoDataManager:CheckIfAllianceMarkInUse(self.selectType)
        self.delBtn:SetActive(isInUse)
        self.title:SetLocalText(390847) 
    else
        self.toggleAlliance:SetIsOn(false)
        self.togglePersonal:SetIsOn(true)
        self.toggleAllianceSelected:SetActive(false)
        self.toggleAllianceTextSelected:SetActive(false)
        self.toggleAllianceTextUnSelected:SetActive(true)
        self.togglePersonalSelected:SetActive(true)
        self.togglePersonalTextSelected:SetActive(true)
        self.togglePersonalTextUnSelected:SetActive(false)
        self:OnMarkGroupChanged()
        if self.isInclude then
            self.title:SetLocalText(300032)
        else
            self.title:SetLocalText(300033)
        end
        self.delBtn:SetActive(self.isInclude)
    end
end

--刷新联盟标记使用状态
local function SetAllianceMarks(self)
    for i, v in pairs(self.allianceMarksDic) do
        v:SetActive(true)--MK 补充
    end
end

local function IptOnValueChange(self, value)
    self.name = value
end

local function ToggleControlBorS(self)
    if self.toggle1:GetIsOn() then
        self.selectType = 0
    elseif self.toggle2:GetIsOn() then
        self.selectType = 1
    elseif self.toggle3:GetIsOn() then
        self.selectType = 2
    end
end

local function OnSetClick(self)
    if self.curMarkGroup == MarkGroup.Alliance then
        if not LuaEntry.Player:IsInAlliance() then
            UIUtil.ShowTipsId(390820) 
            return
        elseif not DataCenter.AllianceBaseDataManager:IsR4orR5() then
            local isInUse = DataCenter.WorldFavoDataManager:CheckIfPointInUse(self.chat_data_param.pos)
            if isInUse then
                UIUtil.ShowTipsId(390823) 
            else
                UIUtil.ShowTipsId(390821) 
            end
            return
        end
        self.ctrl:AddAllianceMark(self.chat_data_param.pos, self.chat_data_param.sid, self.name, self.selectType)
    else
        local SearchFlyType = 999
        UIUtil.DoFly(SearchFlyType,1,string.format(LoadPath.CommonNewPath,self.toggleImgTab[self.selectType + 1]:GetImage().name)
            ,self.toggleImgTab[self.selectType + 1].transform.position, UIUtil.GetUIMainSavePos(UIMainSavePosType.Search))
        self.ctrl:AddBookMark(self.chat_data_param.pos, self.chat_data_param.sid, self.name, self.selectType, 0)
    end
end

local function OnClickDelBtn(self)
    if self.curMarkGroup == MarkGroup.Alliance then
        if not LuaEntry.Player:IsInAlliance() then
            UIUtil.ShowTipsId(390820) 
            return
        elseif not DataCenter.AllianceBaseDataManager:IsR4orR5() then
            UIUtil.ShowTipsId(390822) 
            return
        end
        self.ctrl:DelAllianceMark(self.selectType)
    elseif self.curMarkGroup == MarkGroup.Personal then
        SFSNetwork.SendMessage(MsgDefines.WorldFavoDel,self.chat_data_param.pos,self.chat_data_param.type,self.chat_data_param.sid)
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPositionAdd, { anim = true, UIMainAnim = UIMainAnimType.LeftRightBottomShow })
    end
end

    --点击左侧页签切换联盟标记或个人标记
local function OnMarkGroupChanged(self)
    if self.toggleAlliance:GetIsOn() then
        self.allianceMarkContainer:SetActive(true)
        self.personalMarkContainer:SetActive(false)
        self.toggleAllianceSelected:SetActive(true)
        self.toggleAllianceTextSelected:SetActive(true)
        self.toggleAllianceTextUnSelected:SetActive(false)
        self.togglePersonalSelected:SetActive(false)
        self.togglePersonalTextSelected:SetActive(false)
        self.togglePersonalTextUnSelected:SetActive(true)
    elseif self.togglePersonal:GetIsOn() then
        self.allianceMarkContainer:SetActive(false)
        self.personalMarkContainer:SetActive(true)
        self.toggleAllianceSelected:SetActive(false)
        self.toggleAllianceTextSelected:SetActive(false)
        self.toggleAllianceTextUnSelected:SetActive(true)
        self.togglePersonalSelected:SetActive(true)
        self.togglePersonalTextSelected:SetActive(true)
        self.togglePersonalTextUnSelected:SetActive(false)
    end
end

--点击选择联盟标记
local function OnAllianceMarkStateChanged(self, markType)
    self.selectType = markType
    local isInUse = DataCenter.WorldFavoDataManager:CheckIfAllianceMarkInUse(markType)
    self.delBtn:SetActive(isInUse)
    self.allianceMarkName:SetLocalText(AllianceMarkName[self.selectType])
    
end

    
    
UIPositionAddView.OnCreate = OnCreate
UIPositionAddView.OnDestroy = OnDestroy
UIPositionAddView.InitState = InitState
UIPositionAddView.OnEnable = OnEnable
UIPositionAddView.OnDisable = OnDisable
UIPositionAddView.IptOnValueChange = IptOnValueChange
UIPositionAddView.ToggleControlBorS = ToggleControlBorS
UIPositionAddView.OnSetClick = OnSetClick
UIPositionAddView.OnClickDelBtn = OnClickDelBtn
UIPositionAddView.OnMarkGroupChanged = OnMarkGroupChanged
--UIPositionAddView.MarkGroup = MarkGroup
--UIPositionAddView.MarkType = MarkType
UIPositionAddView.OnAllianceMarkStateChanged = OnAllianceMarkStateChanged
UIPositionAddView.SelectMarkGroup = SelectMarkGroup
UIPositionAddView.SelectMark = SelectMark
UIPositionAddView.SetAllianceMarks = SetAllianceMarks

return UIPositionAddView