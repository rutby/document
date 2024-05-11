local UIAllianceScienceRowCell = BaseClass("UIAllianceScienceRowCell", UIBaseContainer)
local base = UIBaseContainer

local line1_path = "line1"
local line2_path = "line2"
-- 创建
function UIAllianceScienceRowCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIAllianceScienceRowCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UIAllianceScienceRowCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UIAllianceScienceRowCell:OnDisable()
	base.OnDisable(self)
end


--控件的定义
function UIAllianceScienceRowCell:ComponentDefine()
	self.line1 = self:AddComponent(UIImage, line1_path)
	self.line2 = self:AddComponent(UIImage, line2_path)
end

--控件的销毁
function UIAllianceScienceRowCell:ComponentDestroy()
end

--变量的定义
function UIAllianceScienceRowCell:DataDefine()
	self.param = {}
end

--变量的销毁
function UIAllianceScienceRowCell:DataDestroy()
	self.param = {}
end

-- 全部刷新
function UIAllianceScienceRowCell:ReInit(param)
	self.param = param
	self:Refresh()
end

function UIAllianceScienceRowCell:Refresh()
	local state1 = ScienceLineState.No
	local state2 = ScienceLineState.No
	local direct1 = ScienceLineDirectionState.Top
	local direct2 = ScienceLineDirectionState.Top

	if self.param.curList ~= nil then
		for k, v in pairs(self.param.curList) do
			local data = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(v)
			if data ~= nil then
				local needScience = data.science_condition
				if needScience ~= nil and needScience[1] ~= nil then
					for k1, v1 in ipairs(needScience) do
						local sId = v1.scienceId
						local position = GetTableData(TableName.AlScienceTab, sId,"position", nil)
						if position ~= nil and position[2] ~= k then
							if k == 1 then
								if state1 ~= ScienceLineState.Light then
									direct1 = ScienceLineDirectionState.Down
									state1 = ScienceLineState.Dark
								end
								if position[2] == 3 then
									if state2 ~= ScienceLineState.Light then
										state2 = ScienceLineState.Dark
										direct2 = ScienceLineDirectionState.Top
									end
								end
								if DataCenter.AllianceScienceDataManager:HasScienceByIdAndLevel(sId, v1.level) then
									state1 = ScienceLineState.Light
									if position[2] == 3 then
										state2 = ScienceLineState.Light
									end
								end
							elseif k == 2 then
								if position[2] == 1 then
									if state1 ~= ScienceLineState.Light then
										direct1 = ScienceLineDirectionState.Top
										state1 = ScienceLineState.Dark
									end
									if DataCenter.AllianceScienceDataManager:HasScienceByIdAndLevel(sId, v1.level) then
										state1 = ScienceLineState.Light
									end
								elseif position[2] == 3 then
									if state2 ~= ScienceLineState.Light then
										direct2 = ScienceLineDirectionState.Top
										state2 = ScienceLineState.Dark
									end
									if DataCenter.AllianceScienceDataManager:HasScienceByIdAndLevel(sId, v1.level) then
										state2 = ScienceLineState.Light
									end
								end
							elseif k == 3 then
								if state2 ~= ScienceLineState.Light then
									direct2 = ScienceLineDirectionState.Down
									state2 = ScienceLineState.Dark
								end
								if position[2] == 1 then
									if state1 ~= ScienceLineState.Light then
										state1 = ScienceLineState.Dark
										direct1 = ScienceLineDirectionState.Top
									end
								end
								if DataCenter.AllianceScienceDataManager:HasScienceByIdAndLevel(sId, v1.level) then
									state2 = ScienceLineState.Light
									if position[2] == 1 then
										state1 = ScienceLineState.Light
									end
								end
							end
						end
					end
				end
			end
		end
	end

	if self.param.lastList ~= nil then
		for k, v in pairs(self.param.lastList) do
			local list = self.param.preAndNeed[v]
			if list ~= nil and list[1] ~= nil then
				local curLevel = DataCenter.AllianceScienceDataManager:GetScienceLevel(v)
				for k1, v1 in ipairs(list) do
					if v1.y ~= k then
						if k == 1 then
							if state1 ~= ScienceLineState.Light then
								direct1 = ScienceLineDirectionState.Top
								state1 = ScienceLineState.Dark
							end
							if v1.y == 3 then
								if state2 ~= ScienceLineState.Light then
									state2 = ScienceLineState.Dark
									direct2 = ScienceLineDirectionState.Down
								end
							end
							if v1.needLevel <= curLevel then
								state1 = ScienceLineState.Light
								if v1.y == 3 then
									state2 = ScienceLineState.Light
								end
							end
						elseif k == 2 then
							if v1.y == 1 then
								if state1 ~= ScienceLineState.Light then
									direct1 = ScienceLineDirectionState.Down
									state1 = ScienceLineState.Dark
								end
								if v1.needLevel <= curLevel then
									state1 = ScienceLineState.Light
								end
							elseif v1.y == 3 then
								if state2 ~= ScienceLineState.Light then
									direct2 = ScienceLineDirectionState.Down
									state2 = ScienceLineState.Dark
								end
								if v1.needLevel <= curLevel then
									state2 = ScienceLineState.Light
								end
							end
						elseif k == 3 then
							if state2 ~= ScienceLineState.Light then
								direct2 = ScienceLineDirectionState.Top
								state2 = ScienceLineState.Dark
							end
							if v1.y == 1 then
								if state1 ~= ScienceLineState.Light then
									state1 = ScienceLineState.Dark
									direct1 = ScienceLineDirectionState.Down
								end
							end
							if v1.needLevel <= curLevel then
								state2 = ScienceLineState.Light
								if v1.y == 1 then
									state1 = ScienceLineState.Light
								end
							end
						end
					end
				end
			end
		end
	end

	if state1 == ScienceLineState.No then
		self.line1:SetActive(false)
	else
		self.line1:SetActive(true)
		if state1 == ScienceLineState.Dark then
			self.line1:LoadSprite(string.format(LoadPath.UIScience, "science_bar4_01"))
		elseif state1 == ScienceLineState.Light then
			self.line1:LoadSprite(string.format(LoadPath.UIScience, "science_bar4_02"))
		end
	end

	if state2 == ScienceLineState.No then
		self.line2:SetActive(false)
	else
		self.line2:SetActive(true)
		if state2 == ScienceLineState.Dark then
			self.line2:LoadSprite(string.format(LoadPath.UIScience, "science_bar4_01"))
		elseif state2 == ScienceLineState.Light then
			self.line2:LoadSprite(string.format(LoadPath.UIScience, "science_bar4_02"))
		end
	end
end

return UIAllianceScienceRowCell