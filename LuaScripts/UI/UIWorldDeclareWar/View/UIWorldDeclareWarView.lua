---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime:
--- 联盟宣战
local UIWorldDeclareWarView = BaseClass("UIWorldDeclareWarView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization


local title_path = "UICommonMiniPopUpTitle/Bg_mid/titleText"
local close_path = "UICommonMiniPopUpTitle/Bg_mid/CloseBtn"
local return_path = "UICommonMiniPopUpTitle/panel"
local rect_info_path = "Root/Info"
local Txt_DeclareCity = "Root/Info/Txt_DeclareCity"
local Txt_CityNamePos = "Root/Info/Txt_CityNamePos"
local Txt_DeclareTitle = "Root/Info/Txt_DeclareTitle"
local input_path = "Root/Info/InputField"
local Placeholder_path = "Root/Info/InputField/Text Area/Placeholder"
local declare_btn_path = "Root/Info/Btn_CreateDeclare"
local declare_txt_path = "Root/Info/Btn_CreateDeclare/Txt_CreateDeclare"
local Txt_Declare = "Root/Info/Txt_Declare"
local Txt_Reset = "Root/Info/Txt_Reset"
local Btn_Tips = "Root/Btn_Tips"
local Btn_Return = "Root/Btn_return"
local details_info_path = "Root/Details"
local desText_path = "Root/Details/ScrollView/Viewport/Content/desTxt"

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
    self._title_txt = self:AddComponent(UITextMeshProUGUIEx,title_path)
    self._close_btn = self:AddComponent(UIButton,close_path)
    self._return_btn = self:AddComponent(UIButton,return_path)
    self._close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self._return_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    
    self._rect_info = self:AddComponent(UIBaseContainer,rect_info_path)
    self._details_info = self:AddComponent(UIBaseContainer,details_info_path)
    
    --宣战城市
    self._declareCity_txt = self:AddComponent(UITextMeshProUGUIEx,Txt_DeclareCity)
    --宣战城市名字和坐标
    self._cityNamePos_txt = self:AddComponent(UITextMeshProUGUIEx,Txt_CityNamePos)

    --宣言
    self._declareTitle_txt = self:AddComponent(UITextMeshProUGUIEx,Txt_DeclareTitle)
    
    self.input = self:AddComponent(UITMPInput, input_path)
    self.input:SetOnValueChange(function (value)
        self:IptOnValueChange(value)
    end)
    self._placeholder_txt = self:AddComponent(UITextMeshProUGUIEx,Placeholder_path)
    --self.input_default = self:AddComponent(UITextMeshProUGUIEx, input_default_path)
    
    self._createDeclare_btn = self:AddComponent(UIButton,declare_btn_path)
    self._createDeclare_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickWar()
    end)
    self.declare_txt = self:AddComponent(UITextMeshProUGUIEx,declare_txt_path)
    
    self._declare_txt = self:AddComponent(UITextMeshProUGUIEx,Txt_Declare)
    self._reset_txt = self:AddComponent(UITextMeshProUGUIEx,Txt_Reset)

    self._tips_btn = self:AddComponent(UIButton,Btn_Tips)
    self.Btn_Return = self:AddComponent(UIButton,Btn_Return)
    self._tips_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickTips(1)
    end)
    self.Btn_Return:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickTips(2)
    end)
    
    self.desText = self:AddComponent(UITextMeshProUGUIEx,desText_path)
end

local function ComponentDestroy(self)
    self._title_txt = nil
    self._close_btn = nil
    self._return_btn = nil
    self._declareCity_txt = nil
    self._cityNamePos_txt = nil
    self._declareTitle_txt = nil
    self.input:SetText("")
    self.input = nil
    self._placeholder_txt = nil
    self._createDeclare_btn = nil
    self._declare_txt = nil
    self._reset_txt = nil
end


local function DataDefine(self)
    self.k2 = LuaEntry.DataConfig:TryGetNum("alliance_declare_war","k2")
    self.k3 = LuaEntry.DataConfig:TryGetNum("alliance_declare_war","k3")
    self.k5 = LuaEntry.DataConfig:TryGetNum("alliance_declare_war","k5")    --宣战最少联盟人数
    self.k6 = LuaEntry.DataConfig:TryGetNum("alliance_declare_war","k6")    --当日宣战最大次数
end

local function DataDestroy(self)
 
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end


local function ReInit(self)
     self.cityId,self.pointId,self.uuid = self:GetUserData()
    self._rect_info:SetActive(true)
    self._details_info:SetActive(false)
    self._tips_btn:SetActive(true)
    self.Btn_Return:SetActive(false)
    self._title_txt:SetLocalText(143549)
    self._declareCity_txt:SetLocalText(143550)
    self._declareTitle_txt:SetLocalText(143552)
    self._placeholder_txt:SetLocalText(143553)
    self._reset_txt:SetLocalText(302316)
    self.declare_txt:SetLocalText(110006)
    self.desText:SetLocalText(302324)
    local time = DataCenter.AllianceDeclareWarManager:GetDeclareTime()
    self.curNum = self.k6 - time
    self._declare_txt:SetLocalText(302315,self.curNum)
    local cityTemplate = LocalController:instance():getLine(TableName.WorldCity, self.cityId)
    if cityTemplate~=nil then
        local str = ""
        local level = cityTemplate:getValue("level")
        local userName = ""
        local name = cityTemplate:getValue("name")
        local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(self.cityId)
        if cityInfo~=nil and cityInfo.cityName~=nil and cityInfo.cityName~="" then
            userName = cityInfo.cityName
        end
        local pos  = self.pointId * 10 + 7
        local point = (pos - pos % 10) / 10
        local tilePos = SceneUtils.IndexToTilePos(point)
        if userName~=nil and userName~="" then
            str = Localization:GetString("140205",level,userName).." "..Localization:GetString("300015",tilePos.x,tilePos.y)
        else
            str = Localization:GetString("140205",level,Localization:GetString(name)).." "..Localization:GetString("300015",tilePos.x,tilePos.y)
        end
        self._cityNamePos_txt:SetText(str)
    end
end

local function IptOnValueChange(self,value)
    --local str = self.ctrl:GetStringCharCount(value)
end

--创建宣战
local function OnClickWar(self)
    local str = self.input:GetText()
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if data.curMember < self.k5 then
        UIUtil.ShowTipsId(302323)
        return
    end
    local v = string.match(str,"^%s+$")  == str
    if self.curNum > 0 then
        if str == "" or v then
            UIUtil.ShowTipsId(302330)
        else
            SFSNetwork.SendMessage(MsgDefines.AllianceDeclareWarCreate,0,0,tostring(self.cityId),str)
            self.ctrl:CloseSelf()
        end
    else
        UIUtil.ShowTipsId(302322)
    end
end

local function OnClickTips(self,state)
    if state == 1 then
        self._rect_info:SetActive(false)
        self._details_info:SetActive(true)
        self._tips_btn:SetActive(false)
        self.Btn_Return:SetActive(true)
    elseif state == 2 then
        self._rect_info:SetActive(true)
        self._details_info:SetActive(false)
        self._tips_btn:SetActive(true)
        self.Btn_Return:SetActive(false)
    end
    --local param = {}
    --param.type = "desc"
    --param.title = ""
    --param.desc = Localization:GetString("302324")
    --param.alignObject = self._tips_btn
    --UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

UIWorldDeclareWarView.OnCreate = OnCreate
UIWorldDeclareWarView.OnDestroy = OnDestroy
UIWorldDeclareWarView.OnEnable = OnEnable
UIWorldDeclareWarView.OnDisable = OnDisable
UIWorldDeclareWarView.ComponentDefine = ComponentDefine
UIWorldDeclareWarView.ComponentDestroy = ComponentDestroy
UIWorldDeclareWarView.DataDefine = DataDefine
UIWorldDeclareWarView.DataDestroy = DataDestroy
UIWorldDeclareWarView.ReInit = ReInit
UIWorldDeclareWarView.IptOnValueChange = IptOnValueChange
UIWorldDeclareWarView.OnClickWar = OnClickWar
UIWorldDeclareWarView.OnClickTips = OnClickTips
return UIWorldDeclareWarView