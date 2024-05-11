--- Created by shimin.
--- DateTime: 2024/2/29 18:32
--- 敲钟管理器
local BellManager = BaseClass("BellManager")
local bell_anim_path = "ModelGo/Normal/A_build_lingdang/A_build_lingdang_skin"
local BellAnimName = "sway"
local StopTIME = 3

function BellManager:__init()
	self.isShow = false
	self:AddListener()
end

function BellManager:__delete()
	self.isShow = false
	self:RemoveListener()
end

function BellManager:Startup()
end

function BellManager:AddListener()
end

function BellManager:RemoveListener()
end

function BellManager:ClickBell()
	if (not self.isShow) and DataCenter.BuildManager.MainLv >= LuaEntry.DataConfig:TryGetNum("zombie_defence", "k2") then
		self:StartBell()
		--local curTime = UITimeManager:GetInstance():GetServerTime()
		--local dayNight = DataCenter.VitaManager:GetDayNight(curTime)
		--if dayNight == VitaDefines.DayNight.Night or dayNight == VitaDefines.DayNight.Night then
		--	self:StartBell()
		--end
	end
end

function BellManager:StartBell()
	self.isShow = true
	--播放摇铃音效
	--出现紧急戒备
	--土肥圆说先去掉 2024/4/18
	--DataCenter.VitaManager:PushMatter(VitaDefines.Matter.Bell)
	
	
end

function BellManager:EndBell()
	self.isShow = false

end

--小人敲钟（小人敲钟动画，钟敲钟动画）
function BellManager:Toll(residentId)
	local data = DataCenter.CityResidentManager:GetDataById(CityResidentDefines.Type.Resident, residentId)
	if data ~= nil then
		--钟敲钟动画
		local simpleAnim = nil
		local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_BELL)
		if buildData ~= nil then
			local city = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
			if city ~= nil then
				local transform = city:GetTransform()
				if transform ~= nil then
					simpleAnim = transform:Find(bell_anim_path):GetComponentInChildren(typeof(CS.SimpleAnimation))
				end
			end
		end

		if simpleAnim ~= nil then
			simpleAnim:Play(BellAnimName)
		end
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Bell)
		--小人敲钟动画
		data:SetGuideControl(true)
		data:Idle()
		data:PlayAnim(CityResidentDefines.AnimName.Sway)
		data:WaitForFinish(StopTIME)
		data.onFinish = function()
			data.onFinish = nil
			data:PlayAnim(CityResidentDefines.AnimName.Idle)
			if simpleAnim ~= nil then
				simpleAnim:Stop()
			end
		end
	end
	
end

return BellManager