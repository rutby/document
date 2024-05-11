---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/2 17:33
---

local UIVitaResidentChange = BaseClass("UIVitaResidentChange", UIBaseView)
local base = UIBaseView
local UIVitaResidentItem = require "UI.UIVita.Component.UIVitaResidentItem"

local title_path = "imgBg/title"
--local close_path = "UICommonPopUpTitle/CloseBtn"
local return_path = "UICommonPanel"
local bg_path = "imgBg"
local desc_path = "imgBg/Desc"
local list_path = "imgBg/List"
local go_path = "imgBg/Go"
local go_text_path = "imgBg/Go/GoText"

local CellWidth = 136
local CellSpace = 50

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:DataDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self:ReInit()
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Resident_Change) 
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.return_btn = self:AddComponent(UIButton, return_path)
    self.return_btn:SetOnClick(function()
        self:OnCloseClick()
    end)
    self.bg_image = self:AddComponent(UIImage, bg_path)
    self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_path)
    self.list_go = self:AddComponent(UIBaseContainer, list_path)
    self.go_btn = self:AddComponent(UIButton, go_path)
    self.go_btn:SetOnClick(function()
        self:OnCloseClick()
    end)
    self.go_text = self:AddComponent(UITextMeshProUGUIEx, go_text_path)
    self.go_text:SetLocalText(110006)
end

local function ComponentDestroy(self)

end

local function DataDefine(self)
    self.type = VitaDefines.ComeType.Normal
    self.idList = {}
    self.callback = nil
    self.reqs = {}
    self.items = {}
end

local function DataDestroy(self)
    for _, req in pairs(self.reqs) do
        req:Destroy()
    end
    self.reqs = {}
    self.items = {}
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function ReInit(self)
    local isNewbie = DataCenter.VitaManager.isNewbie
    DataCenter.VitaManager.isNewbie = false
    
    self.type, self.idList, self.callback = self:GetUserData()
    if self.type == VitaDefines.ComeType.LandReward then
        self.bg_image:LoadSprite(string.format(LoadPath.UIVita, "survivor_first_bg_selected"))
    else
        self.bg_image:LoadSprite(string.format(LoadPath.UIVita, "survivor_last_bg_selected"))
    end
    self.title_text:SetLocalText(350017)
    self.desc_text:SetLocalText(isNewbie and 350018 or 350020, #self.idList)
    self.go_text:SetLocalText(isNewbie and 350019 or 350021)
    for i, id in ipairs(self.idList) do
        self.reqs[i] = self:GameObjectInstantiateAsync(UIAssets.UIVitaResidentItem, function(req)
            local go = req.gameObject
            go.name = tostring(i)
            local tf = go.transform
            tf:SetParent(self.list_go.transform)
            tf:Set_localScale(1, 1, 1)
            local item = self.list_go:AddComponent(UIVitaResidentItem, go.name)
            item:SetData(id)
            self.items[i] = item
        end)
    end

    local colCount = math.min(#self.idList, 3)
    local listWidth = colCount * CellWidth + (colCount - 1) * CellSpace
    local size = self.list_go.rectTransform.sizeDelta
    self.list_go.rectTransform.sizeDelta = Vector2.New(listWidth, size.y)
end

local function OnCloseClick(self)
    -- fly icon
    for i, id in ipairs(self.idList) do
        if self.items[i] then
            local icon = GetTableData(TableName.VitaResident, id, "icon")
            local path = string.format(LoadPath.Resident, icon)
            local srcPos = self.items[i].transform.position
            local destPos = UIUtil.GetUIMainSavePos(UIMainSavePosType.VitaResident)
            UIUtil.DoFlyCustom(path, nil, 1, srcPos, destPos)
        end
    end
    
    if self.callback then
        self.callback()
    end
    self.ctrl:CloseSelf()
end

UIVitaResidentChange.OnCreate = OnCreate
UIVitaResidentChange.OnDestroy = OnDestroy
UIVitaResidentChange.OnEnable = OnEnable
UIVitaResidentChange.OnDisable = OnDisable
UIVitaResidentChange.ComponentDefine = ComponentDefine
UIVitaResidentChange.ComponentDestroy = ComponentDestroy
UIVitaResidentChange.DataDefine = DataDefine
UIVitaResidentChange.DataDestroy = DataDestroy
UIVitaResidentChange.OnAddListener = OnAddListener
UIVitaResidentChange.OnRemoveListener = OnRemoveListener

UIVitaResidentChange.ReInit = ReInit
UIVitaResidentChange.OnCloseClick = OnCloseClick

return UIVitaResidentChange