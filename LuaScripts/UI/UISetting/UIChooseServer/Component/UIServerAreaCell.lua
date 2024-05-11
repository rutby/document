local UIServerAreaCell = BaseClass("UIServerAreaCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Color_Select_MainTitle = Color.New(208/255, 104/255, 50/255, 1)
-- 创建
function UIServerAreaCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIServerAreaCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UIServerAreaCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UIServerAreaCell:OnDisable()
	base.OnDisable(self)
end


--控件的定义
function UIServerAreaCell:ComponentDefine()
	self.goTextMat = self.transform:Find("Txt_ServerArea/goTextMat"):GetComponent(typeof(CS.UnityEngine.MeshRenderer))
	self.btn = self:AddComponent(UIButton, "")
	self.btn:SetOnClick(function()
		self:OnBtnClick()
	end)
	self.un_select_img = self:AddComponent(UIImage, "unselect")
	self.select_img = self:AddComponent(UIImage, "select")
	self._server_txt = self:AddComponent(UITextMeshProUGUIEx, "Txt_ServerArea")
	
end

--控件的销毁
function UIServerAreaCell:ComponentDestroy()
	self.btn = nil
	self._server_txt = nil
end

--变量的定义
function UIServerAreaCell:DataDefine()
	self.param = {}
end

--变量的销毁
function UIServerAreaCell:DataDestroy()
	self.param = nil
end

-- 全部刷新
function UIServerAreaCell:ReInit(param,index,callback)
	self.param = param
	self.callback = callback
	self.index = param.index
	if param~=nil then
		if param.index<0 then
			self._server_txt:SetLocalText(208234)
		else
			local minId = param.minNum
			local maxId = param.maxNum
			self._server_txt:SetText(minId.."-"..maxId)
		end
	end
	self:OnCheckSelect()
end


function UIServerAreaCell:OnBtnClick()
	if self.callback then
		self.callback(self.index)
	end
end

function UIServerAreaCell:OnCheckSelect(data)
	if self.param~=nil and self.index == self.view.selectIndex then
		self.un_select_img:SetActive(false)
		self.select_img:SetActive(true)
		self._server_txt:SetColor(WhiteColor)
		self._server_txt:SetMaterial(self.goTextMat.sharedMaterials[1])
	else
		self.un_select_img:SetActive(true)
		self.select_img:SetActive(false)
		self._server_txt:SetColor(Color.New(93/255.0, 67/255.0, 63/255.0, 1))
		self._server_txt:SetMaterial(self.goTextMat.sharedMaterials[0])
	end
end

function UIServerAreaCell:OnAddListener()
	base.OnAddListener(self)
	self:AddUIListener(EventId.OnSelectAccountServer, self.OnCheckSelect)
end

function UIServerAreaCell:RemoveListener()
	self:RemoveUIListener(EventId.OnSelectAccountServer, self.OnCheckSelect)
	base.OnRemoveListener(self)
end

return  UIServerAreaCell
