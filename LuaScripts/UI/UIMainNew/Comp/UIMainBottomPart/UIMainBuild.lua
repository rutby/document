--- Created by shimin.
--- DateTime: 2024/2/21 19:29
--- UIMain建筑列表

local UIMainBuild = BaseClass("UIMainBuild", UIBaseContainer)
local base = UIBaseContainer
local UIMainBuildCell = require "UI.UIMainNew.Comp.UIMainBottomPart.UIMainBuildCell"

local build_btn_path = "build_btn"
local icon_path = "build_btn/icon"
local red_num_path = "build_btn/RedDot/DotText"
local scroll_view_path = "scroll_view"
local build_close_btn_path = "scroll_view/build_close_btn"

local ScrollWidth =
{
    Two = 252,
    Three = 362,
    More = 422,
}

function UIMainBuild:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UIMainBuild:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

--控件的定义
function UIMainBuild:ComponentDefine()
    self.build_btn = self:AddComponent(UIButton, build_btn_path)
    self.build_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBuildBtnClick()
    end)
    self.icon = self:AddComponent(UIImage, icon_path)
    self.red_num = self:AddComponent(UITextMeshProUGUIEx, red_num_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
    
    self.build_close_btn = self:AddComponent(UIButton, build_close_btn_path)
    self.build_close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBuildCloseBtnClick()
    end)
end

--控件的销毁
function UIMainBuild:ComponentDestroy()
end

function UIMainBuild:DataDefine()
    self.list = {}
end

function UIMainBuild:DataDestroy()
    self.list = {}
end

function UIMainBuild:ReInit()
    self:Refresh()
end

function UIMainBuild:OnEnable()
    base.OnEnable(self)
end

function UIMainBuild:OnDisable()
    base.OnDisable(self)
end

function UIMainBuild:Refresh()
    if DataCenter.BuildManager:CanShowUIMainBuild() and SceneUtils.GetIsInCity() then
        self:GetDataList()
        local count = #self.list
        if count > 0 then
            self:SetActive(true)
            self.scroll_view:SetActive(false)
            self.build_btn:SetActive(true)
            self.icon:LoadSprite(DataCenter.BuildManager:GetBuildIconPath(self.list[1], 1))
            self.red_num:SetText(tostring(count))
        else
            self:SetActive(false)
        end
    else
        self:SetActive(false)
    end
end

function UIMainBuild:OnBuildBtnClick()
    local count = #self.list
    if count > 1 then
        self.scroll_view:SetActive(true)
        self.build_btn:SetActive(false)
        local width = ScrollWidth.More
        if count == 2 then
            width = ScrollWidth.Two
        elseif count == 3 then
            width = ScrollWidth.Three
        else
            width = ScrollWidth.More
        end
        self.scroll_view:SetSizeDelta({x = width, y = self.scroll_view.rectTransform.rect.height})
        self:ShowCells()
    else
        GoToUtil.GotoCityByBuildId(self.list[1])
    end
end

function UIMainBuild:OnBuildCloseBtnClick()
    self.scroll_view:SetActive(false)
    self.build_btn:SetActive(true)
end

function UIMainBuild:ShowCells()
    self:ClearScroll()
    local count = table.count(self.list)
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

function UIMainBuild:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIMainBuildCell)--清循环列表gameObject
end

function UIMainBuild:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIMainBuildCell, itemObj)
    item:ReInit(self.list[index])
end

function UIMainBuild:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIMainBuildCell)
end

function UIMainBuild:GetDataList()
    self.list = DataCenter.BuildCityBuildManager:GetCanCreateBuildIdList()
end

return UIMainBuild