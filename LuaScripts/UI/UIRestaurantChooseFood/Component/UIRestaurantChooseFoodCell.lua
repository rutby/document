--- Created by shimin.
--- DateTime: 2023/12/7 20:44
--- 餐厅选择食物界面cell

local UIRestaurantChooseFoodCell = BaseClass("UIRestaurantChooseFoodCell", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray

local cell_bg_path = ""
local food_bg_path = "food_bg"
local food_icon_path = "food_bg/food_icon"
local name_text_path = "name_text"
local des_text_path = "des_text"
local cost_text_path = "cost_text"
local got_text_path = "got_text"
local select_btn_path = "select_btn"
local select_btn_text_path = "select_btn/select_btn_text"
local unselect_btn_text_path = "select_btn/unselect_btn_text"

function UIRestaurantChooseFoodCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIRestaurantChooseFoodCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIRestaurantChooseFoodCell:OnEnable()
    base.OnEnable(self)
end

function UIRestaurantChooseFoodCell:OnDisable()
    base.OnDisable(self)
end

function UIRestaurantChooseFoodCell:ComponentDefine()
    self.cell_bg = self:AddComponent(UIImage, cell_bg_path)
    self.food_bg = self:AddComponent(UIImage, food_bg_path)
    self.food_icon = self:AddComponent(UIImage, food_icon_path)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
    self.cost_text = self:AddComponent(UITextMeshProUGUIEx, cost_text_path)
    self.got_text = self:AddComponent(UITextMeshProUGUIEx, got_text_path)
    self.select_btn = self:AddComponent(UIButton, select_btn_path)
    self.select_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnSelectBtnClick()
    end)
    self.select_btn_text = self:AddComponent(UITextMeshProUGUIEx, select_btn_text_path)
    self.unselect_btn_text = self:AddComponent(UITextMeshProUGUIEx, unselect_btn_text_path)
end

function UIRestaurantChooseFoodCell:ComponentDestroy()
end

function UIRestaurantChooseFoodCell:DataDefine()
    self.param = {}
end

function UIRestaurantChooseFoodCell:DataDestroy()
    self.param = {}
end

function UIRestaurantChooseFoodCell:OnAddListener()
    base.OnAddListener(self)
end

function UIRestaurantChooseFoodCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIRestaurantChooseFoodCell:ReInit(param)
    self.param = param
    self.des_text:SetLocalText(self.param.desc)
    self.name_text:SetLocalText(self.param.name)
    self.cost_text:SetText(tostring(-self.param.foodCost))
    self.got_text:SetText(tostring(self.param.addHunger))
    self.food_icon:LoadSprite(self.param.icon)
    self:RefreshSelect()
end

function UIRestaurantChooseFoodCell:RefreshSelect()
    self.select_btn_text:SetActive(false)
    self.unselect_btn_text:SetActive(false)
    if self.param.select then
        self.select_btn_text:SetActive(true)
        self.select_btn_text:SetLocalText(GameDialogDefine.CUR_SELECT)
        UIGray.SetGray(self.select_btn.transform, true, false)
        self.cell_bg:LoadSprite("Assets/Main/Sprites/UI/UIFurniture/cook_bg_03.png")
        self.food_bg:LoadSprite("Assets/Main/Sprites/UI/UIFurniture/cook_bg_01.png")
    else
        self.unselect_btn_text:SetActive(true)
        self.unselect_btn_text:SetLocalText(GameDialogDefine.SELECT)
        UIGray.SetGray(self.select_btn.transform, false, true)
        self.cell_bg:LoadSprite("Assets/Main/Sprites/UI/UIFurniture/cook_bg_04.png")
        self.food_bg:LoadSprite("Assets/Main/Sprites/UI/UIFurniture/cook_bg_02.png")
    end
end

function UIRestaurantChooseFoodCell:OnSelectBtnClick()
    SFSNetwork.SendMessage(MsgDefines.ResidentSetFood, self.param.foodType)
end

return UIRestaurantChooseFoodCell