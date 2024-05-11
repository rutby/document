--- Created by shimin.
--- DateTime: 2023/12/7 20:44
--- 餐厅选择食物界面

local UIRestaurantChooseFoodCtrl = BaseClass("UIRestaurantChooseFoodCtrl", UIBaseCtrl)

function UIRestaurantChooseFoodCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRestaurantChooseFood)
end

return UIRestaurantChooseFoodCtrl