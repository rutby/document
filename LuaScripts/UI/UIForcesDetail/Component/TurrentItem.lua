local TurrentItem = BaseClass("TurrentItem", UIBaseContainer)
local base = UIBaseContainer

local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization


local lv_txt_path = "Text_Lv"
local name_txt_path = "Text_Name"
local point_txt_path = "Text_point"
local point_btn_path = "Text_point"
local item_icon_path = "Item_Icon"
local slider_txt_path = "Progress/TimeSlider_up/TimeSliderText"
local slider_path = "Progress/TimeSlider_up"



--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)


    self.lv_txt  = self:AddComponent(UITextMeshProUGUIEx, lv_txt_path)
    self.name_txt = self:AddComponent(UITextMeshProUGUIEx,name_txt_path)
    self.point_txt = self:AddComponent(UITextMeshProUGUIEx, point_txt_path)
    self.item_icon = self:AddComponent(UIImage, item_icon_path)
    self.slider_txt = self:AddComponent(UITextMeshProUGUIEx, slider_txt_path)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.point_btn = self:AddComponent(UIButton, point_btn_path)
    self.point_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnPointClick()
    end)
    
end

local function ComponentDestroy(self)
  --  self.title_txt = nil
end


local function DataDefine(self)
  --  self.cellList = {}
end

local function DataDestroy(self)
  --  self.cellList = nil
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
    if self.param ~= nil then
        local buildData = self.param.value
        self.lv_txt:SetLocalText(300665, buildData.level) 
        self.name_txt:SetLocalText(buildData:GetDesTemplate().name) 
        local pos = SceneUtils.IndexToTilePos(buildData:GetCenterIndex())
        self.point_txt:SetLocalText(310137, pos.x, pos.y) 
        self.item_icon :LoadSprite(string.format(LoadPath.BuildIconOutCity,buildData:GetDesTemplate().pic))
        self.slider_txt:SetText(buildData.currentHp.."/"..buildData:GetLevelTemplate().max_hp)
        self.slider:SetValue(buildData.currentHp/buildData:GetLevelTemplate().max_hp)
    end
end

local function OnPointClick(self)
    GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(self.param.value:GetCenterIndex()), CS.SceneManager.World.InitZoom,LookAtFocusTime)
    --关闭界面
    UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

TurrentItem.OnCreate = OnCreate
TurrentItem.OnDestroy = OnDestroy
TurrentItem.OnEnable = OnEnable
TurrentItem.OnDisable = OnDisable
TurrentItem.ComponentDefine = ComponentDefine
TurrentItem.ComponentDestroy = ComponentDestroy
TurrentItem.DataDefine = DataDefine
TurrentItem.DataDestroy = DataDestroy
TurrentItem.OnAddListener = OnAddListener
TurrentItem.OnRemoveListener = OnRemoveListener
TurrentItem.ReInit = ReInit
TurrentItem.OnPointClick = OnPointClick




return TurrentItem
