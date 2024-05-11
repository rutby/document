---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/11/5 14:39
---
local UIGolloesTraderItem = BaseClass("UIGolloesTraderItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

-- 创建
function UIGolloesTraderItem:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UIGolloesTraderItem:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

-- 显示
function UIGolloesTraderItem:OnEnable()
    base.OnEnable(self)
end

-- 隐藏
function UIGolloesTraderItem:OnDisable()
    base.OnDisable(self)
end


--控件的定义
function UIGolloesTraderItem:ComponentDefine()
    self._name_txt = self:AddComponent(UITextMeshProUGUIEx, "Txt_Name")
    self._receive_btn = self:AddComponent(UIButton, "Btn_Receive")
    self._receive_txt = self:AddComponent(UITextMeshProUGUIEx,"Btn_Receive/Txt_Receive")
    self._receive_btn:SetOnClick(function()
        self:OnClickBgBtn()
    end)
    self._new_img = self:AddComponent(UIImage, "Img_New")

    self.head = self:AddComponent(UIPlayerHead, "UIPlayerHead/HeadIcon")
end

--控件的销毁
function UIGolloesTraderItem:ComponentDestroy()

end

--变量的定义
function UIGolloesTraderItem:DataDefine()
  
end 

--变量的销毁
function UIGolloesTraderItem:DataDestroy()
   
end


function UIGolloesTraderItem:SetData(data)
    self.data = data
    self.uid = data.uid
    self._name_txt:SetText(data.name)
    self.head:SetData(data.uid, data.pic, data.picVer)
    if data.time then
        self._receive_txt:SetLocalText(320343)
        self._new_img:SetActive(data.isNew)
        data:SetNewState(false)
    else
        self._receive_txt:SetLocalText(390146)
        self._new_img:SetActive(false)
    end
end

function UIGolloesTraderItem:OnClickBgBtn()
    self.view:OnClickCell(self.data)
   
end

return UIGolloesTraderItem