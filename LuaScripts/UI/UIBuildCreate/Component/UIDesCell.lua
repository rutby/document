local UIDesCell = BaseClass("UIDesCell", UIBaseContainer)
local base = UIBaseContainer

local des_name_path = "AccelerateText"
local des_add_path = "AddValue"
local des_cur_path = "CurValue"

-- 创建
function UIDesCell:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UIDesCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

-- 显示
function UIDesCell:OnEnable()
    base.OnEnable(self)
end

-- 隐藏
function UIDesCell:OnDisable()
    base.OnDisable(self)
end


--控件的定义
function UIDesCell:ComponentDefine()
    self.des_name = self:AddComponent(UITextMeshProUGUIEx, des_name_path)
    self.des_add = self:AddComponent(UITextMeshProUGUIEx, des_add_path)
    self.des_cur = self:AddComponent(UITextMeshProUGUIEx, des_cur_path)
end

--控件的销毁
function UIDesCell:ComponentDestroy()
end

--变量的定义
function UIDesCell:DataDefine()
    self.param = {}
end

--变量的销毁
function UIDesCell:DataDestroy()
    self.param = nil
end

-- 全部刷新
function UIDesCell:ReInit(param)
    self.param = param
    self:Refresh()
end

function UIDesCell:Refresh()
    if self.param.visible then
        self:SetActive(true)
        self.des_name:SetText(self.param.param.name)
        if self.param.param.addValue == nil then
            self.des_add:SetActive(false)
        else
            self.des_add:SetActive(true)
            self.des_add:SetText(self.param.param.addValue)
        end
        if self.param.param.curValue == nil then
            self.des_cur:SetActive(false)
        else
            self.des_cur:SetActive(true)
            self.des_cur:SetText(self.param.param.curValue)
        end
    else
        self:SetActive(false)
    end
end


return UIDesCell