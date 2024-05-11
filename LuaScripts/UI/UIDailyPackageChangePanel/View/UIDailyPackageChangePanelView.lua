
local UIDailyPackageChangePanelView = BaseClass("UIDailyPackageChangePanelView", UIBaseView)
local base = UIBaseView
local UIDailyHeroItem = require "UI.UIDailyPackageChangePanel.Comp.UIDailyHeroItem"

local btnPanelBack_path = "panelBack"
local btnClose_path = "Bg/btnClose"
local txtHeroName_path = "Bg/txtHeroName"
local imgCamp_path = "Bg/imgCamp"
local btnSearch_path = "Bg/btnSearch"
local imgHero_path = "Bg/imgHero"
local btnSelect_path = "Bg/btnSelect"
local txtSelect_path = "Bg/btnSelect/btnText"
local scrollView_path = "Bg/ScrollView"
local UIGray = CS.UIGray
function UIDailyPackageChangePanelView : OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIDailyPackageChangePanelView : ComponentDefine()
    self.btnPanelBack = self:AddComponent(UIButton, btnPanelBack_path)
    self.btnPanelBack:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.btnClose = self:AddComponent(UIButton, btnClose_path)
    self.btnClose:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.txtHeroName = self:AddComponent(UITextMeshProUGUIEx, txtHeroName_path)
    self.imgCamp = self:AddComponent(UIImage, imgCamp_path)
    self.btnSearch = self:AddComponent(UIButton, btnSearch_path)
    self.btnSearch:SetOnClick(function()
        self:OnClickBtnSearch()
    end)
    self.imgHero = self:AddComponent(UIImage, imgHero_path)
    self.btnSelect = self:AddComponent(UIButton, btnSelect_path)
    self.btnSelect:SetOnClick(function()
        self:OnClickBtnSelect()
    end)
    self.txtSelect = self:AddComponent(UITextMeshProUGUIEx, txtSelect_path)
    self.txtSelect:SetLocalText(110108)
    self.scrollView = self:AddComponent(UIScrollView, scrollView_path)
    self.scrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
end

function UIDailyPackageChangePanelView : ComponentDestroy()
end

function UIDailyPackageChangePanelView : DataDefine()
    self.curSelectedId,self.heroIdList = self:GetUserData()
    self.heroItemList = {}
end

function UIDailyPackageChangePanelView : DataDestroy()
    self.curSelectedId = -1
    self.heroIdList = {}
    self.heroItemList = {}
end

function UIDailyPackageChangePanelView : OnDestroy()
    self:ClearScrollView()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIDailyPackageChangePanelView : OnEnable()
    base.OnEnable(self)
end

function UIDailyPackageChangePanelView : OnDisable()
    base.OnDisable(self)
end

function UIDailyPackageChangePanelView : OnAddListener()
    base.OnAddListener(self)
end

function UIDailyPackageChangePanelView : OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIDailyPackageChangePanelView : ReInit()
    DataCenter.DailyPackageManager:OnChooseListClick()
    self:RefreshCells()
    self:UpdateHero()
end
function UIDailyPackageChangePanelView:UpdateHero()
    local heroId = GetTableData("custom_dailypackage",self.curSelectedId, "hero")
    if heroId~=nil then
        local picPath = HeroUtils.GetHeroBigPic(heroId)
        self.imgHero:LoadSprite(picPath)
        self.txtHeroName:SetText(HeroUtils.GetHeroNameByConfigId(heroId))
        local camp = HeroUtils.GetCampByHeroId(heroId)
        self.imgCamp:LoadSprite(HeroUtils.GetCampIconPath(camp))
    end
    if self.curSelectedId == DataCenter.DailyPackageManager:GetCurSelectId() then
        UIGray.SetGray(self.btnSelect.transform, true, false)
    else
        UIGray.SetGray(self.btnSelect.transform, false, true)
    end 
end
function UIDailyPackageChangePanelView : OnClickBtnSearch()

end

function UIDailyPackageChangePanelView : OnClickBtnSelect()
    SFSNetwork.SendMessage(MsgDefines.DailyPackageSelectHero, tostring(self.curSelectedId))
    self.ctrl:CloseSelf()
end

function UIDailyPackageChangePanelView : OnCreateCell(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scrollView:AddComponent(UIDailyHeroItem, itemObj)
    item:ReInit(self.heroIdList[index])
    self.heroItemList[index] = item
end

function UIDailyPackageChangePanelView : OnDeleteCell(itemObj, index)
    self.scrollView:RemoveComponent(itemObj.name, UIDailyHeroItem)
    self.heroItemList[index] = nil
end

function UIDailyPackageChangePanelView : RefreshCells()
    self:ClearScrollView()
    local count = table.count(self.heroIdList)
    if count > 0 then
        self.scrollView:SetTotalCount(count)
        self.scrollView:RefillCells()
    end
end

function UIDailyPackageChangePanelView : ClearScrollView()
    self.scrollView:ClearCells()
    self.scrollView:RemoveComponents(UIDailyHeroItem)
    self.heroItemList = {}
end

function UIDailyPackageChangePanelView : SetSelectHeroId(id)
    self.curSelectedId = id
    for k,v in pairs(self.heroItemList) do
        v:OnRefreshSelect()
    end
    self:UpdateHero()
end
function UIDailyPackageChangePanelView: GetSelectHeroId()
    return self.curSelectedId
end

return UIDailyPackageChangePanelView