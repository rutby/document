---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 

local AllianceAlertItem = BaseClass("AllianceAlertItem",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local itembg_img_path = "mainContent/Common_supple"
local dir1_img_path = "mainContent/Common_supple/jiantou/Rect_MarchDir/Rect_MarchDir1"
local dir2_img_path = "mainContent/Common_supple/jiantou/Rect_MarchDir/Rect_MarchDir2"
local bg_btn_path = "mainContent/BgButton"
local left_pos_btn_path ="mainContent/left"
local left_pos_txt_path = "mainContent/left/leftPosTxt"
local left_name_path = "mainContent/left/leftNameTxt"
local left_playerHead_path = "mainContent/left/lefthead/LeftUIPlayerHead/LeftHeadIcon"
local left_CityHead_path = "mainContent/left/lefthead/LeftUIPlayerHead/LeftCityHead"
local left_playerHeadFg_path = "mainContent/left/lefthead/LeftUIPlayerHead/lForeground"
--local distance_txt_path = "left/Image/Image/distanceTxt"
local distance_txt_path = "mainContent/left/Image/distanceTxt"
local rightDistanceTxt_txt_path = "mainContent/right/rightDistanceTxt"
local right_pos_txt_path = "mainContent/right/rightPosTxt"
local right_righthead_path = "mainContent/right/righthead"
local right_otherHead_path = "mainContent/right/otherhead"
local right_name_path = "mainContent/right/rightNameTxt"
local slider_path = "mainContent/sliderBg/Slider"
local slider_bg_path = "mainContent/sliderBg/Slider/FillArea/Fill"
local march_txt_path = "mainContent/sliderBg/Slider/FillArea/progressTxt"
local time_txt_path = "mainContent/sliderBg/TimeTxt"
local LmarchMax_rect_path = "mainContent/LeftMarchRect"
local RmarchMax_rect_path = "mainContent/RightMarchRect"
local RmarchMax_txt_path = "mainContent/RightMarchRect/RMarchNumRect/RMarchMax_Txt"
local layout_rect = "mainContent/layout"
local right_playerHead_path = "mainContent/right/righthead/RightUIPlayerHead/RightHeadIcon"
local right_playerHeadFg_path = "mainContent/right/righthead/RightUIPlayerHead/rForeground"
--准备、等待/行军、攻击
local marchState ={[1] = "Common_pro_green",[2] = "Common_pro_yellow",[3] = "Common_pro_red" }
local function OnCreate(self,index)
    base.OnCreate(self)
    self.index = index
    self.dir1_img = self:AddComponent(UIImage,dir1_img_path)
    self.dir2_img = self:AddComponent(UIImage,dir2_img_path)

    self.march_txt = self:AddComponent(UITextMeshProUGUIEx,march_txt_path)

    self.itemBg_img = self:AddComponent(UIImage,itembg_img_path)
    self.LmarchMax_rect = self:AddComponent(UIBaseContainer,LmarchMax_rect_path)
    self.RmarchMax_rect = self:AddComponent(UIBaseContainer,RmarchMax_rect_path)
    self._RmarchNumTab = {}
    for i=1,6 do
        local rectpath = "mainContent/RightMarchRect/RMemberNum"..i
        self._RmarchNumTab[i] = self:AddComponent(UIImage,rectpath)
    end
    self.RmarchMax_txt = self:AddComponent(UITextMeshProUGUIEx,RmarchMax_txt_path)
    self.slider = self:AddComponent(UISlider,slider_path)
    self._sliderBg = self:AddComponent(UIImage,slider_bg_path)
    self.time_txt = self:AddComponent(UITextMeshProUGUIEx,time_txt_path)
    
    self.layout_rect = self:AddComponent(UIBaseContainer,layout_rect)
    self.rightDistance_txt = self:AddComponent(UITextMeshProUGUIEx,rightDistanceTxt_txt_path)
    self.right_pos_txt = self:AddComponent(UITextMeshProUGUIEx,right_pos_txt_path)
    self.right_righthead = self:AddComponent(UIBaseContainer,right_righthead_path)
    self.right_otherHead = self:AddComponent(UIImage,right_otherHead_path)
    self.right_name = self:AddComponent(UITextMeshProUGUIEx,right_name_path)

    self.distance_txt = self:AddComponent(UITextMeshProUGUIEx,distance_txt_path)
    self.left_pos_btn = self:AddComponent(UIButton,left_pos_btn_path)
    self.left_pos_btn:SetOnClick(function ()
        self:OnLeftPosClick()
    end)
    self.left_name = self:AddComponent(UITextMeshProUGUIEx,left_name_path)
    self.left_pos_txt = self:AddComponent(UITextMeshProUGUIEx,left_pos_txt_path)
    self.left_playerHead = self:AddComponent(UIPlayerHead, left_playerHead_path)
    self.left_CityHead = self:AddComponent(UIBaseContainer,left_CityHead_path)
    self.left_playerHeadBg = self:AddComponent(UIImage, left_playerHeadFg_path)
    self.left_playerHeadBg.transform:SetAsLastSibling()

    self.bg_btn = self:AddComponent(UIButton, bg_btn_path)
    self.bg_btn:SetOnClick(function ()
       -- self:OnBgClick()
    end)
    self.right_playerHead = self:AddComponent(UIPlayerHead, right_playerHead_path)
    self.right_playerHeadBg = self:AddComponent(UIImage, right_playerHeadFg_path)
    self.right_playerHeadBg.transform:SetAsLastSibling()
end

local function OnDestroy(self)
    self.itemBg_img = nil
    self.dir1_img = nil
    self.dir2_img = nil
    self.march_txt = nil
    self.bg_btn = nil
    self.left_pos_btn = nil
    self.left_name = nil
    self.left_pos_txt = nil
    self.distance_obj = nil
    self.distance_txt = nil
    self.depart_btn = nil
    self.depart_txt = nil
    self.right_pos_btn = nil
    self.right_name = nil
    self.sliderBg = nil
    self.LmarchMax_rect = nil
    self._LmarchNumTab = nil
    self.LmarchMax_txt = nil
    --self.slider_txt = nil
    self.layout_rect = nil
    self.time_txt = nil
    self.join_btn = nil
    self.cancel_btn = nil
    self.isUpdate = nil
    self.left_playerHead = nil
    self.left_CityHead = nil
    self.right_playerHead = nil
    self.right_bossHead = nil
    self.right_CityHead = nil
    --self.goback_btn_path = nil
    self.goback_txt = nil
    base.OnDestroy(self)
end

local function RefreshData(self,key,targetPoint)
    self.data = DataCenter.AllianceAlertDataManager:GetAllianceAlertDataByKey(key)
    if not self.data then
        return
    end
    self.targetPoint = targetPoint
    self.LmarchMax_rect:SetActive(false)
    self.RmarchMax_rect:SetActive(true)
    for i = 1 ,6 do
        self._RmarchNumTab[i]:SetActive(false)
    end
    self.RmarchMax_txt:SetText(Localization:GetString("141098").." "..self.data.num)
    self.layout_rect:SetActive(false)
    self.right_righthead:SetActive(true)
    self.rightDistance_txt:SetActive(false)
    self.right_pos_txt:SetActive(false)
    self.dir1_img:SetLocalScaleXYZ(1,1,1)
    self.dir2_img:SetLocalScaleXYZ(1,1,1)
    self.right_otherHead:SetActive(false)
    self.march_txt:SetLocalText(141100)
    self.time_txt:SetLocalText(141099)
    self.slider:SetValue(1)
    self.itemBg_img:LoadSprite(string.format(LoadPath.CommonNewPath,"Common_supple_red"))
    self._sliderBg:LoadSprite(string.format(LoadPath.CommonNewPath,marchState[3]))
    if self.data.type == AllianceAlertType.ALLIANCE_CITY then
        local nameKey = GetTableData(TableName.WorldCity, self.data.content, "name")
        self.left_name:SetLocalText(nameKey)--Localization:GetString()
    else
        self.left_name:SetText("[".. self.data.alAbbr .."]"..self.data.name)
    end
    self.left_name:SetColorRGBA(0.1607843,0.7137255,0.9411765,1)

    if self.data.atkAlAbbr and self.data.atkAlAbbr ~= "" then
        self.right_name:SetText("["..self.data.atkAlAbbr.."]"..self.data.atkName)
    else
        self.right_name:SetText(self.data.atkName)
    end

    self.right_playerHead:SetData(self.data.atkUid, self.data.atkPic, self.data.atkPicVer)
    if self.data.atkHeadFrame > 0 then
        self.right_playerHeadBg:SetActive(true)
    else
        self.right_playerHeadBg:SetActive(false)
    end

    self.left_CityHead:SetActive(self.data.type == AllianceAlertType.ALLIANCE_CITY)
    self.left_playerHead:SetActive(self.data.type ~= AllianceAlertType.ALLIANCE_CITY)   --打城时关闭玩家头像
    self.left_playerHead:SetData(self.data.targetUid,self.data.pic,self.data.picVer)
    if self.data.headFrame == 1 then
        self.left_playerHeadBg:SetActive(true)
    else
        self.left_playerHeadBg:SetActive(false)
    end
    local rightPos = SceneUtils.IndexToTilePos(self.data.point,ForceChangeScene.World)
    local distance = math.ceil(SceneUtils.TileDistance(rightPos, SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(),ForceChangeScene.World)))
    self.left_pos_txt:SetLocalText(GameDialogDefine.SHOW_POS, rightPos.x, rightPos.y)
    self.distance_txt:SetText(distance..Localization:GetString(GameDialogDefine.KILOMETRE))
end

local function OnLeftPosClick(self)
    if self.targetPoint then
        self.view.ctrl:OnClickPosBtn(self.targetPoint)
    else
        self.view.ctrl:OnClickPosBtn(self.data.point)
    end
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnBgClick(self)
    self.view.ctrl:OpenAlertInfo(self.data)
end

local function IsWarItem(self)
    return false
end

local function GetIndex(self)
    return self.index
end

AllianceAlertItem.OnCreate = OnCreate
AllianceAlertItem.OnDestroy = OnDestroy
AllianceAlertItem.OnEnable = OnEnable
AllianceAlertItem.OnDisable = OnDisable
AllianceAlertItem.RefreshData = RefreshData
AllianceAlertItem.OnLeftPosClick =OnLeftPosClick
AllianceAlertItem.OnBgClick =OnBgClick
AllianceAlertItem.IsWarItem =IsWarItem
AllianceAlertItem.GetIndex = GetIndex
return AllianceAlertItem