--[[
    礼包按钮积分 累充开启时
--]]

local UIGiftPackagePoint = BaseClass("UIGiftPackagePoint", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local btn_path = ""
local pointActIcon_img_path = "Image"
local point_txt_path = "Txt_Point"
-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self.showingTip = false
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self.showingTip = nil
    base.OnDestroy(self)
end

-- 显示
local function OnEnable(self)
    base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
    base.OnDisable(self)
end

--控件的定义
local function ComponentDefine(self)
    self.point_btn = self:AddComponent(UIButton,btn_path)
    self.point_txt = self:AddComponent(UITextMeshProUGUIEx,point_txt_path)
    self.point_btn:SetOnClick(function()  
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:ShowTip()
    end)
    self.pointActIcon_img = self:AddComponent(UIImage,pointActIcon_img_path)
end

--控件的销毁
local function ComponentDestroy(self)
    self.point_btn = nil
    self.point_txt = nil
end

-- 全部刷新
local function RefreshPoint(self,param)
    self.rechargeType = nil
    if param then
        local point = param:getRechargePoint()
        if point ~= 0 then
            self.point_btn:SetActive(true)
            self.point_txt:SetText(point)
        else
            self.point_btn:SetActive(false)
        end
        local list = WelfareController.getShowTagInfos()
        for i, v in pairs(list) do
            if v:getType() == WelfareTagType.CumulativeRecharge or
               v:getType() == WelfareTagType.PaidLottery or v:getType() == WelfareTagType.DailyCumulativeRecharge or
               v:getType() == WelfareTagType.KeepPay then
                self.path = GetTableData("recharge", v:getID(), "image2")
                self.pointActIcon_img:LoadSprite(string.format(LoadPath.ItemPath, self.path))
                self.rechargeType = v:getType()
                self.rechargeId = v:getID()
                break
            end
        end
    else
        self.point_btn:SetActive(false)
    end
end

local function ShowTip(self)
    local param = {}
    param["alignObject"] = self.point_btn
    param.iconPath = self.path
    param.rechargeType = self.rechargeType
    param.rechargeId = self.rechargeId
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftScoreTips,{anim = true}, param)
end

UIGiftPackagePoint.OnCreate = OnCreate
UIGiftPackagePoint.OnDestroy = OnDestroy
UIGiftPackagePoint.OnDisable = OnDisable
UIGiftPackagePoint.RefreshPoint = RefreshPoint
UIGiftPackagePoint.ComponentDefine = ComponentDefine
UIGiftPackagePoint.ComponentDestroy = ComponentDestroy
UIGiftPackagePoint.OnEnable = OnEnable
UIGiftPackagePoint.ShowTip = ShowTip

return UIGiftPackagePoint